import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vandad_course_app/services/auth/auth_exceptions.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_bloc.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_event.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_state.dart';
import 'package:vandad_course_app/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        if (state is AuthStateLoggedOut) {
          if (state.exception is InvalidCredentionalsAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Invalid credentials. Check login or password.',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Authentication error ',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here',
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
                        AuthEventLogin(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
                child: const Text('I forgot my password'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text(
                  'Not register yet? Register here!',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
