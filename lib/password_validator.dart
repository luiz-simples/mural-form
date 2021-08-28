library mural_form;

import 'package:mural_form/string_validator.dart';
import 'package:mural_form/validator.dart';
import 'package:validators/validators.dart';

class PasswordValidator extends StringValidator {
  PasswordValidator({ String? value, isRequired }) : super(value: value, isRequired: isRequired);

  @override
  String sanitize(String? input) => isNull(input) ? "" : input!.trim();

  @override
  ValidatorMessage checkValue(String? input, bool isRequired) {
    final String password = sanitize(input);
    if (isNull(password)) return isRequired ? ValidatorMessage.REQUIRED : ValidatorMessage.NONE;
    if (password.length < 7) return ValidatorMessage.INVALID_MIN_7;
    return ValidatorMessage.NONE;
  }
}
