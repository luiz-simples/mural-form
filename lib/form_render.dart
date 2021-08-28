library mural_form;

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:mural_form/mural_form.dart';

class FormRender<Form> extends StatefulWidget {
  final Form Function(BuildContext context) create;
  final Widget Function(BuildContext context, Form form) child;

  const FormRender({
    required this.create,
    required this.child
  });

  @override
  State<FormRender<Form>> createState() => _FormRenderState<Form>();
}

class _FormRenderState<Form> extends State<FormRender<Form>> {
  late Form _form;
  late StreamSubscription _subscription;

  MuralForm get _validator => _form as MuralForm;


  @override
  void initState() {
    super.initState();
    _form = widget.create(context);
    _subscription = _validator.bloc.stream.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _subscription.cancel();
    _validator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => (
    widget.child(context, _form)
  );
}
