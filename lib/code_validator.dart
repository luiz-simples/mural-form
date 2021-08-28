library mural_form;

import 'package:mural_form/string_validator.dart';
import 'package:mural_form/validator.dart';
import 'package:validators/validators.dart';

class CodeValidator extends StringValidator {
  @override
  String sanitize(String? input) => isNull(input) ? "" : input!.toLowerCase().trim();

  @override
  ValidatorMessage checkValue(String? input, bool isRequired) {
    final String code = sanitize(input);
    if (isNull(code)) return isRequired ? ValidatorMessage.REQUIRED : ValidatorMessage.NONE;
    return code.length >= 6 ? ValidatorMessage.NONE : ValidatorMessage.INVALID;
  }
}
