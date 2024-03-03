import 'package:flutter/material.dart';
import 'package:vandad_course_app/constants/routes.dart';
import 'package:vandad_course_app/services/auth/auth_service.dart';
import 'package:vandad_course_app/views/login_view.dart';
import 'package:vandad_course_app/views/notes/new_note_view.dart';
import 'package:vandad_course_app/views/notes/notes_view.dart';
import 'package:vandad_course_app/views/register_view.dart';
import 'package:vandad_course_app/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailPageView(),
        newNoteRoute: (context) => const NewNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initializeApp(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailPageView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const Text('Loading...');
        }
      },
    );
  }
}
