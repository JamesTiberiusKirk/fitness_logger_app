bool _regChecker(String reg, String value) {
  RegExp regExp = new RegExp(reg);
  return regExp.hasMatch(value);
}

String? emptyValidator(String? value) {
  if ((value as String).isEmpty) return 'Must not be empty';
  return null;
}

String? emailValidator(String? value) {
  String reg = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  if ((value as String).isEmpty) return 'Must not be empty';
  if (!_regChecker(reg, value.trim())) return 'Please enter a valid email';

  return null;
}

String? passwordValidator(String? value) {
  String reg =
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&-+=()])(?=\\S+$).{8, 20}$';
  if ((value as String).isEmpty) return 'Must not be empty';
  String errMessage =
      'Password rules: must be between 8 and 20 cahracters, least one number, upper case and lowercare letter, oen special character, no spaces';
  if (_regChecker(reg, value.trim())) return errMessage;
  return null;
}

String? numberValidator(String? value) {
  if (value!.isEmpty) return 'Cannot be empty';
  if (num.tryParse(value) == null) return 'Needs to be a number';

  return null;
}
