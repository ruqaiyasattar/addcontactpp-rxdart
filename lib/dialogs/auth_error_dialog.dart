
import 'package:flutter/material.dart';
import 'package:rxdart_demoapp/blocs/auth_bloc/auth_error.dart';
import 'package:rxdart_demoapp/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}){
  return showGenericDialog(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogText,
      optionBuilder: () => {
        'Ok': true,
      },
  );
}

