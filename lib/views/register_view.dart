import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vandad_course_app/services/auth/auth_exceptions.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_bloc.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_event.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_state.dart';
import 'package:vandad_course_app/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Weak password',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Email already in use',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Invalid email',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Failed to register',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Register'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter ypur email here',
              ),
            ),
            TextField(
              controller: _password,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                context.read<AuthBloc>().add(
                      AuthEventRegister(
                        email,
                        password,
                      ),
                    );
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text(
                'Already registred? Login here!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
