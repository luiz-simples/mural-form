library mural_form;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mural_form/validator.dart';

typedef VoidFieldState = void Function(ValidatorState);

class MuralForm {
  late FormBloc bloc;
  final Map<String, Validator> inputs;

  MuralForm(this.inputs) {
    bloc = FormBloc();
    inputs.forEach((String input, Validator inputValidator) => (
      inputValidator.bloc.stream.listen((_) => bloc.refresh())
    ));
  }

  bool get isDirty => inputs.values.where((Validator input) => input.isDirty).isNotEmpty;
  bool get isValid => inputs.values.where((Validator input) => !input.isValid).isEmpty;
  bool get isInvalid => inputs.values.where((Validator input) => !input.isValid).isNotEmpty;

  void setDirty() => inputs.forEach((_, Validator input) => input.setDirty());

  Future<void> closeKeyboard(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(milliseconds: 150));
  }

  void clearMessagesFields({ bool forceRefresh = false }) {
    final Iterable<Validator> fields = inputs.values.where((Validator field) => field.error.hasError);
    for (final Validator field in fields) {
      field.clearError();
    }
    if (forceRefresh) bloc.refresh();
  }

  void dispose() {
    for (final Validator field in inputs.values) {
      field.focus.dispose();
      field.controller.dispose();
      field.bloc.close();
    }
  }
}

class FormBloc extends Cubit<int> {
  FormBloc() : super(DateTime.now().microsecondsSinceEpoch);
  void refresh() => emit(DateTime.now().microsecondsSinceEpoch);
}
