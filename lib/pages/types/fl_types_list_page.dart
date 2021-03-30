import 'package:chopper/chopper.dart';
import 'package:fitness_logger_app/models/fl_type.dart';
import 'package:fitness_logger_app/pages/types/fl_create_type_page.dart';
import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:fitness_logger_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlTypesListPage extends StatefulWidget {
  @override
  _FlTypesListPageState createState() => _FlTypesListPageState();
}

class _FlTypesListPageState extends State<FlTypesListPage> {
  _updateTrigger() {
    setState(() {});
  }

  Future<void> _refresh() {
    setState(() {});
    return Future.value();
  }

  Widget _buildTypesList(context) {
    final flTypesApiService = Provider.of<FlTypesApiService>(context);
    return FutureBuilder(
      future: flTypesApiService.getAll(),
      builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final flTypes = snapshot.data!.body;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: flTypes.length,
                itemBuilder: (BuildContext context, int i) {
                  FlType flType = FlType.fromJson(flTypes[i]);
                  return Column(
                    children: [
                      FlTypeItem(
                        key: Key(flType.id!),
                        flType: flType,
                        updateTrigger: _updateTrigger,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error');
        }
        return Text('default');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: generateDrawer(),
      appBar: AppBar(
        title: Text('Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: () {
              Navigator.of(context).pushNamed('/types/create');
            },
          )
        ],
      ),
      body: _buildTypesList(context),
    );
  }
}

class FlTypeItem extends StatefulWidget {
  FlTypeItem(
      {required Key key, required this.flType, required this.updateTrigger})
      : super(key: key);
  final FlType flType;
  final updateTrigger;
  @override
  _FlTypeItemState createState() => _FlTypeItemState();
}

class _FlTypeItemState extends State<FlTypeItem> {
  _showAlertDialog(BuildContext context, FlType flType) {
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
        final flTypesApiService =
            Provider.of<FlTypesApiService>(context, listen: false);

        try {
          await flTypesApiService.delete(flType.id!);
          widget.updateTrigger();
          navigatorKey.currentState!.pop();
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
      title: Text('Are you sure?'),
      content: Text('Are you sure you want to delete ${flType.tpName}'),
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
    FlType flType = widget.flType;
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(flType.tpName!),
              subtitle: Text(flType.description!),
              trailing: Text('Unit: ${flType.measurmentUnit!}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // TextButton(
                //   child: Text('History'),
                //   onPressed: () {},
                // ),
                TextButton(
                  child: Text('Edit'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return FlCreateTypePage(flType: flType);
                        },
                      ),
                    );
                  },
                ),
                SizedBox(width: 8),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () => _showAlertDialog(context, flType),
                ),
                SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
