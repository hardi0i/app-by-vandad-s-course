import 'package:flutter/material.dart';
import 'package:vandad_course_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) async {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'We have now sent you a password reset link. Please check your email for more information',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
