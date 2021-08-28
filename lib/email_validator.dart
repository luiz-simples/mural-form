library mural_form;

import 'package:mural_form/string_validator.dart';
import 'package:mural_form/validator.dart';
import 'package:validators/validators.dart';

class EmailValidator extends StringValidator {
  EmailValidator({ String? value, isRequired }) : super(value: value, isRequired: isRequired);

  @override
  String sanitize(String? input) => isNull(input) ? "" : input!.toLowerCase().trim();

  @override
  ValidatorMessage checkValue(String? input , bool isRequired) {
    final String email = sanitize(input);
    if (isNull(email)) return isRequired ? ValidatorMessage.REQUIRED : ValidatorMessage.NONE;
    return isEmail(email) ? ValidatorMessage.NONE : ValidatorMessage.INVALID;
  }
}
