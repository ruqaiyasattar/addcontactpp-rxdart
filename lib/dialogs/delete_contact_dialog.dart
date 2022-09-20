import 'package:flutter/material.dart';
import 'package:rxdart_demoapp/dialogs/generic_dialog.dart';

Future<bool> showDeleteContactDialog(
  BuildContext context,
){
  return showGenericDialog(
    context: context,
    title: 'Delete contact',
    content: 'Are you sure you want to delete this contact? You cannot undo this operation!',
    optionBuilder: () => {
      'cancel':false,
      'Ok': true,
    },
  ).then((value) => value  ?? false);
}

