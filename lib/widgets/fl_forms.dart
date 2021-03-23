import 'package:flutter/material.dart';

Widget flFormField(
  BuildContext context, {
  String? label,
  IconButton? suffixIcn,
  Function? validateClb,
  Function? saveClb,
  bool isPassword = false,
  String? initialValue,
}) {
  bool _visibility = isPassword;
  return TextFormField(
    initialValue: initialValue,
    cursorColor: TextSelectionTheme.of(context).cursorColor,
    maxLength: 255,
    obscureText: _visibility,
    validator: validateClb as String? Function(String?)?,
    onSaved: saveClb as void Function(String?)?,
    decoration: InputDecoration(
      labelText: label,
      suffixIcon: suffixIcn,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF6200EE)),
        // borderSide: BorderSide(color: ThemeData.,
      ),
    ),
  );
}

Widget flFormButton(BuildContext context, GlobalKey<FormState> _formKey,
    {required String label, Function? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed as void Function()?,
    child: Text(label),
  );
}
