import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showNewDialog({BuildContext parentContext, BuildContext context, WidgetBuilder builder}) {
  Navigator.pop(context);
  return showDialog(
    context: parentContext,
    builder: builder,
  );
}