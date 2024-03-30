import 'package:flutter/material.dart';
import 'package:vandad_course_app/constants/routes.dart';
import 'package:vandad_course_app/enums/menu_action.dart';
import 'package:vandad_course_app/services/auth/auth_service.dart';
import 'package:vandad_course_app/services/crud/notes_service.dart';
import 'package:vandad_course_app/utilities/dialogs/logout_dialog.dart';
import 'package:vandad_course_app/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    super.initState();

    _notesService = NotesService();
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

                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();

                    if (!mounted) return;

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;

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
                            await _notesService.deleteNote(id: note.id);
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
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
