library mural_form;

import 'package:flutter/widgets.dart';
import 'package:mural_form/validator.dart';
import 'package:validators/validators.dart';

class IntValidator implements Validator {
  bool isRequired = false;
  late ValidatorStateBloc _bloc;
  late FocusNode _focus;
  late TextEditingController _controller;

  IntValidator({ String? value, this.isRequired = false, String? extra }) {
    _bloc = ValidatorStateBloc(sanitize(value), false, _check(value, isRequired, extra));
    _focus = FocusNode();
    _controller = TextEditingController(text: value);
    _controller.addListener(() => _setValue(_controller.text));
  }

  void _setValue(String value, { String? extra }) {
    if (_bloc.state.value == null && isNull(value)) return;
    _bloc.refresh(sanitize(value), true, _check(value, isRequired, extra));
  }

  int? get value => _bloc.state.value;

  @override
  TextEditingController get controller => _controller;

  @override
  FocusNode get focus => _focus;

  @override
  ValidatorStateBloc get bloc => _bloc;

  @override
  bool get isDirty => _bloc.state.isDirty;

  @override
  bool get isValid => _bloc.state.error == ValidatorMessage.NONE;

  bool get isInvalid => _bloc.state.error != ValidatorMessage.NONE;

  @override
  ValidatorMessage get error => isDirty ? _bloc.state.error : ValidatorMessage.NONE;

  @override
  @protected
  void setDirty() {
    _bloc.refresh(value, true, _bloc.state.error);
  }

  @override
  void clearError() {
    _bloc.refresh(value, isDirty, ValidatorMessage.NONE);
  }

  @protected
  int? sanitize(String? val) => isNull(val) ? null : int.parse(val!, radix: 10);

  ValidatorMessage _check(String? input, bool isRequired, String? extra) {
    final ValidatorMessage valueMessage = checkValue(input, isRequired);
    if (!valueMessage.isEmpty || extra == null) return valueMessage;
    return checkExtra(input, isRequired, extra: extra);
  }

  @protected
  ValidatorMessage checkValue(String? input, bool isRequired) {
    return isNull(input) && isRequired ? ValidatorMessage.REQUIRED : ValidatorMessage.NONE;
  }

  @protected
  ValidatorMessage checkExtra(String? input, bool isRequired, { String? extra }) {
    if (isNull(input) && isRequired) return ValidatorMessage.REQUIRED;
    if (isNull(extra) && isRequired) return ValidatorMessage.NONE;
    return sanitize(input) == sanitize(extra) ? ValidatorMessage.NONE : ValidatorMessage.INVALID;
  }
}
