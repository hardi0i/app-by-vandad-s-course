import 'package:flutter/material.dart';
import 'package:vandad_course_app/utilities/dialogs/generic_dialog.dart';

Future<void> showCannoteShareEmptyNoteDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You canote share an empty note!',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
