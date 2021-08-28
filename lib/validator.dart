library mural_form;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ValidatorMessage {
  NONE,
  INVALID,
  REQUIRED,
  UNCONFIRMED,
  INVALID_MIN_7
}

abstract class Validator {
  bool get isDirty;
  bool get isValid;
  FocusNode get focus;
  ValidatorMessage get error;
  ValidatorStateBloc get bloc;
  TextEditingController get controller;

  void setDirty();
  void clearError();
}

extension ValidatorMessageExtension on ValidatorMessage {
  bool get isEmpty => this == ValidatorMessage.NONE;
  bool get hasError => this != ValidatorMessage.NONE;
  // bool get isInvalid => this == ValidatorMessage.INVALID;
  // bool get isRequired => this == ValidatorMessage.REQUIRED;
  // bool get isUnconfirmed => this == ValidatorMessage.UNCONFIRMED;
}

class ValidatorState {
  final bool isDirty;
  final dynamic value;
  final ValidatorMessage error;
  const ValidatorState(this.value, this.isDirty, this.error);
}

class ValidatorStateBloc extends Cubit<ValidatorState> {
  ValidatorStateBloc(dynamic value, bool isDirty, ValidatorMessage error) : super(
    ValidatorState(value, isDirty, error)
  );

  void refresh(dynamic value, bool isDirty, ValidatorMessage error) {
    final bool hasChanges = state.value != value || state.error != error || state.isDirty != isDirty;
    if (hasChanges) emit(ValidatorState(value, isDirty, error));
  }
}
