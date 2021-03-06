import 'package:fitness_logger_app/helper_funcs/validators.dart';
import 'package:fitness_logger_app/models/fl_tracking_group.dart';
import 'package:fitness_logger_app/models/fl_tracking_point.dart';
import 'package:fitness_logger_app/models/fl_type.dart';
import 'package:fitness_logger_app/pages/tracking_groups/tracking_point/fl_tracking_point_form_page.dart';
import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:fitness_logger_app/widgets/drawer.dart';
import 'package:fitness_logger_app/widgets/fl_forms.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

///*****************************
///
///
///
/// This is the individual workout screen.
///
///
///
/// ****************************

SnackBar toBeImplemented = SnackBar(
  content: Text('To be implemented'),
);

class FlTrackingGroup extends StatefulWidget {
  FlTrackingGroup(
      {required Key key, this.flGroup, required this.updateParentClb})
      : super(key: key);
  final FlGroup? flGroup;
  final updateParentClb;

  @override
  _FlTrackingGroupState createState() => _FlTrackingGroupState();
}

class _FlTrackingGroupState extends State<FlTrackingGroup> {
  FlGroup? flGroup;
  final refreshkey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flGroup = widget.flGroup!;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flGroup != null) flGroup = widget.flGroup!;

    final flTPointsApiService =
        Provider.of<FlTPointsApiService>(context, listen: false);

    return Scaffold(
      drawer: generateDrawer(),
      appBar: AppBar(
        title: Text('Workout'),
        actions: [
          IconButton(
              icon: Icon(Icons.library_add),
              onPressed: () {
                navigatorKey.currentState!.push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return FlTrackingPointFormPage(
                      tgId: flGroup!.tgId!.toString(),
                      parentRefreshTrigger: _refresh,
                    );
                  }),
                );
              }),
          if (flGroup!.endTime == null)
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: _stopTrigger,
            )
        ],
      ),
      body: RefreshIndicator(
        key: refreshkey,
        onRefresh: _refresh,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
              future: flTPointsApiService.getByTgId(flGroup!.tgId!),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  var flTPs = snapshot.data!.body;
                  int? itemCount = (3 + flTPs.length).toInt();
                  return ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (BuildContext context, int i) {
                      if (i == 0) return _buildGroupInfo(flGroup!);
                      if (i == 1) return _buildNotes(flGroup!);
                      if (i == 2)
                        return Divider(
                          color: Colors.grey,
                          height: 10,
                          thickness: 1,
                          indent: 25,
                          endIndent: 25,
                        );
                      return _buildTrackingPointsList(
                          FlTrackingPoint.fromJson(flTPs[i - 3]));
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Snapshot error\n${snapshot.error}');
                }
                return Text('outside the if');
              }),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    final service = Provider.of<FlTGroupsApiService>(context, listen: false);
    refreshkey.currentState?.show(atTop: true);
    try {
      final flGroupResp = await service.getById(flGroup!.tgId!);

      setState(
        () {
          flGroup = FlGroup.fromJson(flGroupResp.body[0]);
          print(flGroup!.toJson().toString());
        },
      );
      return Future.value();
    } catch (err) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error ${err.toString()}')));
    }
  }

  void _stopTrigger() async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text('Cancel'),
      onPressed: () {
        navigatorKey.currentState!.pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text('Stop Workout'),
      onPressed: () async {
        try {
          final flTGroupsApiService =
              Provider.of<FlTGroupsApiService>(context, listen: false);
          await flTGroupsApiService.stop(widget.flGroup!.tgId!);
          navigatorKey.currentState!.pop();
          widget.updateParentClb();
        } catch (err) {
          final c = ScaffoldMessenger.of(context);
          c.removeCurrentSnackBar();
          c.showSnackBar(SnackBar(content: Text(err.toString())));
          await _refresh();
          navigatorKey.currentState!.pop();
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Are you sure you want to stop this workout?'),
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

  _buildGroupInfo(FlGroup flGroup) {
    String date = '';
    String startTime = '';
    String? endTime;

    String title = 'Date: ';
    String subtitle = 'Start Time: ';
    String trailing = '';

    if (flGroup.endTime != null) {
      endTime = DateFormat('H:m')
          .format(DateTime.fromMillisecondsSinceEpoch(flGroup.endTime!));

      trailing = 'Ended at: $endTime';
    }

    startTime = DateFormat('H:m')
        .format(DateTime.fromMillisecondsSinceEpoch(flGroup.startTime!));
    subtitle += startTime;

    date = DateFormat('yMd')
        .format(DateTime.fromMillisecondsSinceEpoch(flGroup.startTime!));
    title += date;

    return Card(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: Text(trailing),
            ),
            if (endTime == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: _stopTrigger,
                    child: Text('End Workout'),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  _buildNotes(FlGroup flGroup) {
    String title = 'Notes';
    String subtitle = flGroup.notes!;

    return Card(
        child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                // edit button for the fl-group notes
                onPressed: () {
                  final formKey = GlobalKey<FormState>();
                  String? notes;
                  // set up the buttons
                  Widget cancelButton = TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      navigatorKey.currentState!.pop();
                    },
                  );
                  Widget continueButton = TextButton(
                    child: Text('Save'),
                    onPressed: () async {
                      formKey.currentState!.save();
                      try {
                        final service = Provider.of<FlTGroupsApiService>(
                          context,
                          listen: false,
                        );

                        final update =
                            FlGroup(tgId: flGroup.tgId!, notes: notes!);
                        print(update.toJson().toString());
                        final res = await service.updateGroup(update);
                        print(res.body);
                        navigatorKey.currentState!.pop();
                        await _refresh();
                      } catch (err) {
                        final c = ScaffoldMessenger.of(context);
                        c.removeCurrentSnackBar();
                        c.showSnackBar(SnackBar(content: Text(err.toString())));
                        navigatorKey.currentState!.pop();
                      }
                    },
                  );
                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text('Notes'),
                    content: Form(
                      key: formKey,
                      child: flFormField(context,
                          saveClb: (String? value) => notes = value!),
                    ),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );
                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                child: Text('Edit'),
              ),
            ],
          )
        ],
      ),
    ));
  }

  _buildTrackingPointsList(FlTrackingPoint flTrackingPoint) {
    final flTypesApiService =
        Provider.of<FlTypesApiService>(context, listen: false);
    return FutureBuilder(
      future: flTypesApiService.getById(flTrackingPoint.tpTypeId!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) return Text('Snapshot error ${snapshot.error}');
        if (!snapshot.hasData) return Text('Snapshot empty');

        FlType? flType = FlType.fromJson(snapshot.data!.body[0]);
        // String title = '${flTrackingPoint.tpNr}. ${flType.tpName!}';
        String title = '${flType.tpName!}';
        String subtitle = 'Description ${flType.description}';
        String dataString = 'default';
        if (flTrackingPoint.notes != null) {
          subtitle += '\nNotes: ${flTrackingPoint.notes!}';
        }

        if (flTrackingPoint.data != null) {
          // For set data
          if (flType.dataType == 'sets') {
            // subtitle += '\n\nSets:';
            dataString = 'Sets:';
            for (var dataJson in flTrackingPoint.data) {
              FlSet data = FlSet.fromJson(dataJson);
              if (dataJson != flTrackingPoint.data[0])
                dataString += (data.isDropset == 'true') ? '->' : ' | ';
              dataString +=
                  '${data.reps}x${data.value}${flType.measurmentUnit}';
            }
          } else if (flType.dataType == 'single-value') {
            SingleValue sv = SingleValue.fromJson(flTrackingPoint.data);
            dataString = 'Single Value: ';
            dataString += '${sv.value} ${flType.measurmentUnit} ';
          }
        }

        return Card(
          child: Center(
            child: Column(
              children: [
                ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // set up the buttons
                      Widget cancelButton = TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          navigatorKey.currentState!.pop();
                        },
                      );
                      Widget continueButton = TextButton(
                        child: Text('Delete exercise'),
                        onPressed: () async {
                          final service = Provider.of<FlTPointsApiService>(
                              context,
                              listen: false);
                          try {
                            await service
                                .deleteTrackingPoint(flTrackingPoint.tpId!);
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Deleted')));
                            await _refresh();
                            navigatorKey.currentState!.pop();
                          } catch (err) {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(err.toString())));
                          }
                        },
                      );
                      // set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text(
                            'Are you sure you want to delete this exercise?'),
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
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          dataString,
                        ),
                      ),
                      if (flType.dataType == 'sets')
                        IconButton(
                          icon: Icon(Icons.library_add),
                          onPressed: () {
                            _buildPopupSetForm(flTrackingPoint.tpId!, flType);
                          },
                        ),
                      IconButton(
                        icon: Icon(Icons.create),
                        onPressed: () {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(toBeImplemented);
                          // TODO: create a modal dialougue box
                          // IF set data, need to make some flow for editing sets
                          //  maybe fropdown selector for which set to edit
                          //  in the modal add button to navigate to editing the type.
                          // A different class probs
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildPopupSetForm(String tpId, FlType flType) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // set up the buttons
        return AlertDialog(
          title: Text('Add a set'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FlSetForm(
                flGroup: flGroup!,
                flType: flType,
                parentRefeshTrigger: _refresh,
                flTpId: tpId,
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                navigatorKey.currentState!.pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class FlSetForm extends StatefulWidget {
  FlSetForm({
    Key? key,
    required this.flGroup,
    required this.flType,
    required this.parentRefeshTrigger,
    required this.flTpId,
  }) : super(key: key);
  final FlGroup flGroup;
  final FlType flType;
  final String flTpId;
  final Function parentRefeshTrigger;

  @override
  _FlSetFormState createState() => _FlSetFormState();
}

class _FlSetFormState extends State<FlSetForm> {
  final formKey = new GlobalKey<FormState>();
  String? _reps;
  String? _resistance;
  bool _isDropsetBool = false;

  _buildRepsField() {
    return flFormField(
      context,
      label: 'Reps',
      saveClb: (value) => _reps = value,
      validateClb: numberValidator,
    );
  }

  _buildValueField() {
    return flFormField(
      context,
      label: 'Value in ${widget.flType.measurmentUnit}',
      saveClb: (value) => _resistance = value,
      validateClb: numberValidator,
    );
  }

  _buildIsDropsetCheckBox() {
    return CheckboxListTile(
      value: _isDropsetBool,
      title: Text('Dropset'),
      onChanged: (value) {
        setState(() {
          _isDropsetBool = value!;
        });
      },
    );
  }

  _buildSaveButton() {
    return flFormButton(
      context,
      formKey,
      label: 'Save',
      onPressed: () async {
        if (!formKey.currentState!.validate()) return;
        formKey.currentState!.save();
        try {
          final service =
              Provider.of<FlTPointsApiService>(context, listen: false);
          final setToAdd = FlSet(
              reps: _reps!,
              value: _resistance!,
              isDropset: _isDropsetBool.toString());
          print(setToAdd.toJson().toString());
          print(widget.flTpId);
          final res = await service.addSet(widget.flTpId, setToAdd);
          print(res.body.toString());
          if (res.body != 'Added') throw Error();
          navigatorKey.currentState!.pop();
          await widget.parentRefeshTrigger();
        } catch (err) {
          final c = ScaffoldMessenger.of(context);
          c.removeCurrentSnackBar();
          c.showSnackBar(SnackBar(content: Text(err.toString())));
          // await widget.parentRefeshTrigger();
          // navigatorKey.currentState!.pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildRepsField(),
            _buildValueField(),
            _buildIsDropsetCheckBox(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }
}
