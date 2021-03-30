import 'package:fitness_logger_app/models/fl_tracking_group.dart';
import 'package:fitness_logger_app/models/fl_tracking_point.dart';
import 'package:fitness_logger_app/models/fl_type.dart';
import 'package:fitness_logger_app/pages/fl_loading_page.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:fitness_logger_app/widgets/drawer.dart';
import 'package:fitness_logger_app/widgets/fl_forms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FlTrackingGroup extends StatefulWidget {
  FlTrackingGroup({required Key key, this.flGroup}) : super(key: key);
  final FlGroup? flGroup;

  @override
  _FlTrackingGroupState createState() => _FlTrackingGroupState();
}

class _FlTrackingGroupState extends State<FlTrackingGroup> {
  void _stopTrigger() async {
    // TODO: implement dialogoue box
    final flTGroupApiService =
        Provider.of<FlTGroupsApiService>(context, listen: false);
    await flTGroupApiService.stop(widget.flGroup!.tgId!);
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
        .format(DateTime.fromMillisecondsSinceEpoch(flGroup.startTime));
    subtitle += startTime;

    date = DateFormat('yMd')
        .format(DateTime.fromMillisecondsSinceEpoch(flGroup.startTime));
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
                onPressed: () {
                  // TODO: dialogue box with text field
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
        String title = flType.tpName!;
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
              Set data = Set.fromJson(dataJson);
              dataString += (data.isDropset == 'true') ? ' ->' : ' ';
              dataString +=
                  '${data.reps}x${data.value}${flType.measurmentUnit}';
              dataString += (data.isDropset == 'true') ? '' : ' | ';
            }
          } else if (flType.dataType == 'single-value') {
            SingleValue sv = SingleValue.fromJson(flTrackingPoint.data);
            print(sv.toJson().toString());
            dataString = 'Single Value:';
            dataString += '${sv.value}${flType.measurmentUnit} ';
          }
        }

        return Card(
          child: Center(
            child: Column(
              children: [
                ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(dataString),
                    if (flType.dataType == 'sets')
                      IconButton(
                        icon: Icon(Icons.library_add),
                        onPressed: () {
                          // TODO: create a modal dialougue box
                          // A different class probs
                        },
                      ),
                    IconButton(
                      icon: Icon(Icons.create),
                      onPressed: () {
                        // TODO: create a modal dialougue box
                        // IF set data, need to make some flow for editing sets
                        //  maybe fropdown selector for which set to edit
                        //  in the modal add button to navigate to editing the type.
                        // A different class probs
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _refresh() {
    setState(() {});
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    FlGroup? flGroup;
    if (widget.flGroup != null) flGroup = widget.flGroup!;

    final flTPointsApiService =
        Provider.of<FlTPointsApiService>(context, listen: false);

    return Scaffold(
      drawer: generateDrawer(),
      appBar: AppBar(
        title: Text('Workout'),
        actions: [
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: _stopTrigger,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
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
    );
  }
}
