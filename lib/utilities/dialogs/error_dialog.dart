import 'package:flutter/material.dart';
import 'package:vandad_course_app/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String text,
}) {
  return showGenericDialog<void>(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
