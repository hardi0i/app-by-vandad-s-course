import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_bloc.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_event.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_state.dart';
import 'package:vandad_course_app/utilities/dialogs/error_dialog.dart';
import 'package:vandad_course_app/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          _controller.clear();

          await showPasswordResetSentDialog(context);

          if (state.exception != null && context.mounted) {
            await showErrorDialog(
              context: context,
              text: 'We could not process your request',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'If you forgot your password simply enter your email',
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Your email adress...',
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;

                  context.read<AuthBloc>().add(
                        AuthEventForgotPassword(
                          email: email,
                        ),
                      );
                },
                child: const Text(
                  'Send me password reset link',
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text(
                  'Back to login page',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
