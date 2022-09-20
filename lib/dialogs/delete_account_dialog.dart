import 'package:flutter/material.dart';
import 'package:rxdart_demoapp/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(
  BuildContext context,
){
  return showGenericDialog(
    context: context,
    title: 'Delete account',
    content: 'Are you sure you want to delete your account? You cannot undo this operation!',
    optionBuilder: () => {
      'cancel':false,
      'Ok': true,
    },
  ).then((value) => value  ?? false);
}

