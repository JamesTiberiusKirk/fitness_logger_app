import 'package:fitness_logger_app/services/auth_service.dart';
import 'package:fitness_logger_app/helper_funcs/validators.dart';
import 'package:fitness_logger_app/models/user.dart';
import 'package:fitness_logger_app/widgets/fl_forms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildEmailField(context),
          _buildPasswordField(context),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  void _saveEmail(String? value) => _email = value;
  void _savePassword(String? value) => _password = value;

  void _onPressed() async {
    final c = ScaffoldMessenger.of(context);
    if (_formKey.currentState!.validate()) {
      c.hideCurrentSnackBar();
      c.showSnackBar(SnackBar(content: Text('Logging in')));
      _formKey.currentState!.save();
      try {
        User user = User(_email!, _password!);
        bool loginAtt =
            await Provider.of<AuthService>(context, listen: false).login(user);

        c.hideCurrentSnackBar();
        c.showSnackBar(SnackBar(
          content: Text((loginAtt) ? 'Logged in' : 'Wrong password or email'),
        ));

        if (loginAtt) {
          Navigator.of(context).pushReplacementNamed('/home');
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

}
