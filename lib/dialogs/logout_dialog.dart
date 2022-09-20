import 'package:flutter/material.dart';
import 'package:rxdart_demoapp/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(
    BuildContext context,
    ){
  return showGenericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout your account? You cannot undo this operation!',
    optionBuilder: () => {
      'cancel':false,
      'Log out': true,
    },
  ).then((value) => value  ?? false);
}

