import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vandad_course_app/constants/routes.dart';
import 'package:vandad_course_app/enums/menu_action.dart';
import 'package:vandad_course_app/services/auth/auth_service.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_bloc.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_event.dart';
import 'package:vandad_course_app/services/cloud/cloud_note.dart';
import 'package:vandad_course_app/services/cloud/firebase_cloud_storage.dart';
import 'package:vandad_course_app/utilities/dialogs/logout_dialog.dart';
import 'package:vandad_course_app/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    super.initState();

    _notesService = FirebaseCloudStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(
              context,
              createOrUpdateNoteRoute,
            ),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);

                  if (shouldLogOut && context.mounted) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;

                return NotesListView(
                  notes: allNotes,
                  onTap: (note) {
                    Navigator.pushNamed(
                      context,
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
