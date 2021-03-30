import 'package:fitness_logger_app/models/fl_tracking_group.dart';
import 'package:fitness_logger_app/pages/tracking_groups/fl_tracking_group_page.dart';
import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:fitness_logger_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FlTrackingGroupListPage extends StatefulWidget {
  // FlTrackingGroupListPage({Key key}) : super(key: key);

  @override
  _FlTrackingGroupListPageState createState() =>
      _FlTrackingGroupListPageState();
}

class _FlTrackingGroupListPageState extends State<FlTrackingGroupListPage> {
  _updateTrigger() {
    setState(() {});
  }

  Future<void> _refresh() {
    setState(() {});
    return Future.value();
  }

  Widget _buildTypesList(context) {
    final flTypesApiService = Provider.of<FlTGroupsApiService>(context);
    return FutureBuilder(
      future: flTypesApiService.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final flGroups = snapshot.data!.body;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: (flGroups.isEmpty)
                  ? Center(child: Text('Empty'))
                  : ListView.builder(
                      itemCount: flGroups.length,
                      itemBuilder: (BuildContext context, int i) {
                        FlGroup flGroup = FlGroup.fromJson(flGroups[i]);
                        return Column(
                          children: [
                            FlTrackingGroupListItem(
                              key: Key(flGroup.tgId!),
                              flGroup: flGroup,
                              updateTrigger: _updateTrigger,
                            ),
                          ],
                        );
                      },
                    ),
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error');
        }
        return Text('default');
      },
    );
  }

  _newWorkoutModal() {
    final _formKey = GlobalKey<FormState>();
    String? notes;

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text('Cancel'),
      onPressed: () {
        navigatorKey.currentState!.pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text('New Workput'),
      onPressed: () async {
        if (!(_formKey.currentState!.validate())) return;
        _formKey.currentState!.save();
        final flTGroupsApiService =
            Provider.of<FlTGroupsApiService>(context, listen: false);

        final c = ScaffoldMessenger.of(context);
        try {
          await flTGroupsApiService.start({'notes': notes!});
          c.removeCurrentSnackBar();
          c.showSnackBar(SnackBar(content: Text('Started')));
          navigatorKey.currentState!.pop();
        } catch (err) {
          c.removeCurrentSnackBar();
          c.showSnackBar(SnackBar(content: Text(err.toString())));
          navigatorKey.currentState!.pop();
        }
        _refresh();
      },
    );

    Widget notesField = TextFormField(
      validator: (String? value) {
        if (value!.isEmpty) return 'Notes cannot be empty';
        return null;
      },
      onSaved: (String? value) {
        notes = value;
      },
    );

    // set up the AlertDialog
    AlertDialog dialog = AlertDialog(
      title: Text('New workout'),
      content: notesField,
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: dialog,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: generateDrawer(),
      appBar: AppBar(
        title: Text('Workouts'),
        actions: [
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: _newWorkoutModal,
          )
        ],
      ),
      body: _buildTypesList(context),
    );
  }
}

class FlTrackingGroupListItem extends StatefulWidget {
  FlTrackingGroupListItem(
      {required Key key, required this.flGroup, required this.updateTrigger})
      : super(key: key);
  final FlGroup flGroup;
  final updateTrigger;

  @override
  _FlTrackingGroupListItemState createState() =>
      _FlTrackingGroupListItemState();
}

class _FlTrackingGroupListItemState extends State<FlTrackingGroupListItem> {
  _updateTrigger() {
    setState(() {});
  }

  _showDeleteAlertDialog(BuildContext context, FlGroup flGroup) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text('Cancel'),
      onPressed: () {
        navigatorKey.currentState!.pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text('Delete'),
      onPressed: () async {
        final flTGroupsApiService =
            Provider.of<FlTGroupsApiService>(context, listen: false);

        try {
          await flTGroupsApiService.deleteGroup(flGroup.tgId!);
          widget.updateTrigger();
          navigatorKey.currentState!.pop();
        } catch (err) {
          final c = ScaffoldMessenger.of(context);
          c.removeCurrentSnackBar();
          c.showSnackBar(SnackBar(content: Text(err.toString())));
          navigatorKey.currentState!.pop();
        }
        _updateTrigger();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Are you sure you want to delete ${flGroup.tgId}'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FlGroup flGroup = widget.flGroup;
    String startDate = DateFormat('yMd')
        .format(DateTime.fromMillisecondsSinceEpoch(flGroup.startTime));
    String subtitle = flGroup.notes!;

    String startTime = DateFormat('H:m')
        .format(DateTime.fromMillisecondsSinceEpoch(flGroup.startTime));
    subtitle += '\nStarted: $startTime';

    if (flGroup.endTime != null) {
      String endTime = DateFormat('H:m')
          .format(DateTime.fromMillisecondsSinceEpoch(flGroup.endTime!));

      subtitle += '\nEnded: $endTime';
    } else {
      subtitle += '\nStill active';
    }
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(startDate),
              subtitle: Text(subtitle),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text('View'),
                  onPressed: () => {
                    navigatorKey.currentState!.push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => FlTrackingGroup(
                            key: Key(flGroup.tgId!),
                            flGroup: flGroup,
                            updateParentClb: _updateTrigger),
                      ),
                    ),
                  },
                ),
                TextButton(
                  child: Text('Edit'),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) {
                    //       // return FlCreateTypePage(flType: flType);
                    //     },
                    //   ),
                    // );
                  },
                ),
                SizedBox(width: 8),
                TextButton(
                    child: Text('Delete'),
                    onPressed: () {
                      return _showDeleteAlertDialog(context, flGroup);
                    }),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
