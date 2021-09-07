library mural_form;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mural_form/validator.dart';
import 'package:validators/validators.dart';

class DateValidator implements Validator {
  String mask;
  bool isRequired = false;

  late ValidatorStateBloc _bloc;
  late FocusNode _focus;
  late TextEditingController _controller;

  DateValidator({ int timestamp = 0, this.isRequired = false, String? extra, this.mask = 'DD/MM/YY' }) {
    String strDate = formatDate(timestamp, mask);
    _bloc = ValidatorStateBloc(timestamp, false, _check(formatDate(timestamp, mask), isRequired, extra));
    _focus = FocusNode();
    _controller = TextEditingController(text: strDate);
    _controller.addListener(() => _setValue(_controller.text));
  }

  void _setValue(String value, { String? extra }) {
    if (_bloc.state.value == null && isNull(value)) return;
    _bloc.refresh(sanitize(value), true, _check(value, isRequired, extra));
  }

  int get value => isValid ? _bloc.state.value as int : 0;

  static String formatDate(int? timestamp, String mask) {
    if (timestamp == null || timestamp == 0) return "";
    final DateTime datetime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat(mask).format(datetime);
  }

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
  int? sanitize(String? timestamp) => isNull(timestamp) ? null : int.parse(timestamp!, radix: 10);

  ValidatorMessage _check(String? input, bool isRequired, String? extra) {
    final ValidatorMessage valueMessage = checkValue(input, isRequired);
    if (!valueMessage.isEmpty || extra == null) return valueMessage;
    return checkExtra(input, isRequired, extra: extra);
  }

  @protected
  ValidatorMessage checkValue(String? input, bool isRequired) {
    if (isNull(input) && isRequired) return ValidatorMessage.REQUIRED;

    try {
      DateFormat(mask).parse(input!);
      return ValidatorMessage.NONE;
    } on FormatException {
      return ValidatorMessage.INVALID;
    }
  }

  @protected
  ValidatorMessage checkExtra(String? input, bool isRequired, { String? extra }) {
    if (isNull(input) && isRequired) return ValidatorMessage.REQUIRED;
    if (isNull(extra) && isRequired) return ValidatorMessage.NONE;
    return sanitize(input) == sanitize(extra) ? ValidatorMessage.NONE : ValidatorMessage.INVALID;
  }
}
