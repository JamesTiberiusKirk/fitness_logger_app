import 'package:fitness_logger_app/fl_api/fl_api.dart';
import 'package:fitness_logger_app/fl_secure_storage/fl_secure_storage.dart';
import 'package:fitness_logger_app/helper_funcs/validators.dart';
import 'package:fitness_logger_app/models/user.dart';
import 'package:fitness_logger_app/widgets/fl_forms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_logger_app/fl_secure_storage/fl_secure_storage.dart';

class FlLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: FlLoginForm(),
      ),
    );
  }
}

class FlLoginForm extends StatefulWidget {
  @override
  FlLoginFormState createState() {
    return FlLoginFormState();
  }
}

class FlLoginFormState extends State<FlLoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  void _saveEmail(String? value) => _email = value;
  void _savePassword(String? value) => _password = value;

  void _onPressed() async {
    final c = ScaffoldMessenger.of(context);
    if (_formKey.currentState!.validate()) {
      c.hideCurrentSnackBar();
      c.showSnackBar(SnackBar(content: Text('Logging in')));
      _formKey.currentState!.save();
      try {
        final loginAtt =
            await Provider.of<FlAuthService>(context, listen: false)
                .login(new User(_email as String, _password as String));

        if (loginAtt.statusCode == 200) {
          storeJwt(loginAtt.body['jwt']);
        }

        c.hideCurrentSnackBar();
        c.showSnackBar(SnackBar(
          content: Text((loginAtt.statusCode == 200)
              ? 'Logged in'
              : 'Wrong password or email'),
        ));
        
        if (loginAtt.statusCode == 200){
          Navigator.of(context).pushReplacementNamed('/jwt');
        }
      } catch (err) {
        c.hideCurrentSnackBar();
        c.showSnackBar(SnackBar(content: Text(err.toString())));
        print(err.toString());
      }
    }
  }

  Widget _buildEmailField(BuildContext context) {
    return flFormField(
      context,
      label: 'Email Update',
      validateClb: emailValidator,
      saveClb: _saveEmail,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return flFormField(
      context,
      label: 'Password',
      validateClb: emptyValidator,
      saveClb: _savePassword,
      isPassword: true,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return flFormButton(
      context,
      _formKey,
      label: 'Login',
      onPressed: _onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildEmailField(context),
          _buildPasswordField(context),
          _buildSubmitButton(context),
        ],
      ),
    );
  }
}
