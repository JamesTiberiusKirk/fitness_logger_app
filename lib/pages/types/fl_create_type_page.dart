import 'package:fitness_logger_app/helper_funcs/validators.dart';
import 'package:fitness_logger_app/models/fl_type.dart';
import 'package:fitness_logger_app/services/fl_api.dart';
import 'package:fitness_logger_app/widgets/fl_forms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlCreateTypePage extends StatefulWidget {
  FlCreateTypePage({Key key = const Key('Type Form'), this.flType, this.parentRefresh})
      : super(key: key);
  final Function? parentRefresh;
  final FlType? flType;
  @override
  _FlCreateTypePageState createState() {
    return _FlCreateTypePageState();
  }
}

class _FlCreateTypePageState extends State<FlCreateTypePage> {
  final _formKey = GlobalKey<FormState>();

  String? _tpName;
  String? _description;
  String? _dataType;
  int? _dataTypeRadio;
  String? _measurmentUnit;

  @override
  Widget build(BuildContext context) {
    if (widget.flType != null) {
      setState(() {
        _tpName = widget.flType!.tpName;
        _description = widget.flType!.description;
        _measurmentUnit = widget.flType!.measurmentUnit;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flType == null ? 'New Type' : 'Update Type'),
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildTypeNameField(context),
                _buildDescriptionField(context),
                if (widget.flType == null) _buildDataTypeRadio(context),
                _buildMeasurmentUnitField(context),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveTpName(String? value) => _tpName = value;
  void _saveDescription(String? value) => _description = value;
  void _saveMeasurmentUnit(String? value) => _measurmentUnit = value;

  void _dataTypeChangeHandler(int? value) {
    setState(() {
      _dataTypeRadio = value;
      switch (_dataTypeRadio) {
        case 0:
          _dataType = 'sets';
          break;
        case 1:
          _dataType = 'single-value';
          break;
        default:
          throw ('error');
      }
    });
  }

  void _onPressed() async {
    final c = ScaffoldMessenger.of(context);
    if (_formKey.currentState!.validate()) {
      c.hideCurrentSnackBar();
      c.showSnackBar(SnackBar(content: Text('Updating')));
      _formKey.currentState!.save();

      FlType flType = FlType(
        tpName: _tpName,
        description: _description,
        dataType: _dataType,
        measurmentUnit: _measurmentUnit,
      );

      final flTypesApiService =
          Provider.of<FlTypesApiService>(context, listen: false);
      try {
        widget.flType == null
            ? await flTypesApiService.newType(flType)
            : await flTypesApiService.updateType(flType);
        c.hideCurrentSnackBar();
        c.showSnackBar(SnackBar(content: Text('Updated')));
        Navigator.of(context).pop();
        if (widget.parentRefresh != null) widget.parentRefresh!();
      } catch (err) {
        c.hideCurrentSnackBar();
        c.showSnackBar(SnackBar(content: Text(err.toString())));
      }
    }
  }

  Widget _buildTypeNameField(BuildContext context) {
    return flFormField(
      context,
      label: 'Type Name',
      saveClb: _saveTpName,
      validateClb: emptyValidator,
      initialValue: _tpName,
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return flFormField(context,
        label: 'Description',
        saveClb: _saveDescription,
        validateClb: emptyValidator,
        initialValue: _description);
  }

  Widget _buildDataTypeRadio(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 0,
          groupValue: _dataTypeRadio,
          onChanged: _dataTypeChangeHandler,
        ),
        Text(
          'Sets',
          style: TextStyle(fontSize: 16.0),
        ),
        Radio(
          value: 1,
          groupValue: _dataTypeRadio,
          onChanged: _dataTypeChangeHandler,
        ),
        Text(
          'Single value',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurmentUnitField(BuildContext context) {
    return flFormField(
      context,
      label: 'Measurment Unit',
      saveClb: _saveMeasurmentUnit,
      validateClb: emptyValidator,
      initialValue: _measurmentUnit,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return flFormButton(
      context,
      _formKey,
      label: widget.flType == null ? 'Add' : 'Update',
      onPressed: _onPressed,
    );
  }
}
