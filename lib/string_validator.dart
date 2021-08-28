library mural_form;

import 'package:flutter/widgets.dart';
import 'package:mural_form/validator.dart';
import 'package:validators/validators.dart';

class StringValidator implements Validator {
  bool isRequired = false;
  late ValidatorStateBloc _bloc;
  late FocusNode _focus;
  late TextEditingController _controller;

  StringValidator({ String? value, this.isRequired = false, String? extra }) {
    final String _value = sanitize(value);
    _bloc = ValidatorStateBloc(_value, false, _check(_value, isRequired, extra));
    _focus = FocusNode();
    _controller = TextEditingController(text: _value);
    _controller.addListener(defaultChangeListener);
  }

  void defaultChangeListener() {
    setValue(_controller.text);
  }

  void setValue(String value, { String? extra }) {
    if (_bloc.state.value == value) return;
    if (isNull(_bloc.state.value) && isNull(value)) return;

    final String _value = sanitize(value);
    final ValidatorMessage error = _check(_value, isRequired, extra);
    _bloc.refresh(_value, isDirty, error);
  }

  String get value => _controller.text;

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
  void setDirty() {
    _bloc.refresh(value, true, _bloc.state.error);
  }

  @override
  void clearError() {
    _bloc.refresh(value, isDirty, ValidatorMessage.NONE);
  }

  @protected
  String sanitize(String? input) => isNull(input) ? "" : input!.trim();

  ValidatorMessage _check(String? input, bool isRequired, String? extra) {
    final ValidatorMessage valueMessage = checkValue(input, isRequired);
    if (!valueMessage.isEmpty || extra == null) return valueMessage;
    return checkExtra(input, isRequired, extra: extra);
  }

  @protected
  ValidatorMessage checkValue(String? input, bool isRequired) {
    final String value = sanitize(input);
    return isNull(value) && isRequired ? ValidatorMessage.REQUIRED : ValidatorMessage.NONE;
  }

  @protected
  ValidatorMessage checkExtra(String? input, bool isRequired, { String? extra }) {
    final String value = sanitize(input);
    if (isNull(value) && isRequired) return ValidatorMessage.REQUIRED;
    return value == sanitize(extra) ? ValidatorMessage.NONE : ValidatorMessage.UNCONFIRMED;
  }
}
