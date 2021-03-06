import 'package:fitness_logger_app/models/fl_tracking_point.dart';
import 'package:fitness_logger_app/models/fl_type.dart';
import 'package:fitness_logger_app/pages/types/fl_create_type_page.dart';
import 'package:fitness_logger_app/router_generator.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:fitness_logger_app/widgets/fl_forms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlTrackingPointFormPage extends StatefulWidget {
  FlTrackingPointFormPage(
      {Key key = const Key('Point Form'),
      required this.tgId,
      required this.parentRefreshTrigger})
      : super(key: key);
  final String tgId;
  final parentRefreshTrigger;

  @override
  _FlTrackingPointFormPageState createState() =>
      _FlTrackingPointFormPageState();
}

class _FlTrackingPointFormPageState extends State<FlTrackingPointFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _chosenType;
  String? _notes;
  List<FlType>? flTypes = [];
  FlType? activeFlType;
  bool isSingleValue = false;
  String? _singleValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Tracking Point'),
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: _buildForm(),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {});
    return Future.value();
  }

  _buildForm() {
    return Form(
      key: _formKey,
      // child: Expanded(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: _buildTypeDropdown(),
          ),
          if (activeFlType != null)
            Align(
              alignment: Alignment.topLeft,
              child: _buildActiveFlTypeInfoText(),
            ),
          if (isSingleValue) _buildSingleValueField(),
          Align(
            alignment: Alignment.topLeft,
            child: _buildAddTypeButton(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: _buildNotesField(context),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildSubmitButton(),
            ),
          ),
        ],
      ),
      // ),
    );
  }

  _buildActiveFlTypeInfoText() {
    String toDisplay = '';
    toDisplay = 'Description: ${activeFlType!.description!}\n';
    toDisplay += 'Measurment Unit: ${activeFlType!.measurmentUnit!}\n';
    toDisplay += 'Data Type: ${activeFlType!.dataType!}\n';
    return Text(toDisplay);
  }

  _buildTypeDropdown() {
    // Get tptype list
    // build map of tpTypeId and user readable text tpName
    // build and return the dropdown list

    final service = Provider.of<FlTypesApiService>(context);

    return FutureBuilder(
      future: service.getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error ${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        List<DropdownMenuItem<String>> itemList = [];
        for (var typeJson in snapshot.data.body) {
          FlType type = FlType.fromJson(typeJson);
          flTypes!.add(type);
          itemList.add(
            DropdownMenuItem<String>(
              value: type.id!,
              child: Text(type.tpName!),
            ),
          );
        }

        return DropdownButton<String>(
          value: _chosenType,
          style: TextStyle(color: Colors.black),
          items: itemList,
          hint: Text(
            'Please choose an tracking point type',
          ),
          onChanged: (value) {
            setState(() {
              _chosenType = value;
              // FlType? type;
              flTypes!.forEach((element) {
                if (element.id == value) {
                  activeFlType = element;
                }
              });
              if (activeFlType != null)
                isSingleValue = activeFlType!.dataType == 'single-value';
            });
          },
        );
      },
    );
  }

  _buildSingleValueField() {
    return flFormField(
      context,
      label: 'Single Value',
      saveClb: (String? value) => _singleValue = value,
    );
  }

  _buildAddTypeButton() {
    // Push create type page
    return ElevatedButton(
      onPressed: () {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return FlCreateTypePage(
                parentRefresh: _refresh,
              );
            },
          ),
        );
      },
      child: Text('Add new type'),
    );
  }

  _buildNotesField(BuildContext context) {
    // just a simple text field
    return flFormField(
      context,
      label: 'Notes',
      saveClb: (String? value) => _notes = value,
    );
  }

  _buildSubmitButton() {
    // make api call to the server with type FlTrackingPoint
    return ElevatedButton(
      onPressed: () async {
        _formKey.currentState!.save();

        if (_chosenType == null) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Please chose a type')));
          return;
        }

        final service =
            Provider.of<FlTPointsApiService>(context, listen: false);

        dynamic sv = [];
        if (isSingleValue && _singleValue != null)
          sv = SingleValue(value: _singleValue!);

        FlTrackingPoint flTp = FlTrackingPoint(
          tgId: widget.tgId,
          tpTypeId: _chosenType,
          notes: _notes,
          data: sv,
        );
        try {
          await service.createTrackingPoint(flTp);
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Updating')));
          navigatorKey.currentState!.pop();
          widget.parentRefreshTrigger();
        } catch (err) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(err.toString())));
        }
      },
      child: Text('Start excersise'),
    );
  }
}
