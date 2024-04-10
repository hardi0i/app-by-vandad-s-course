import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_bloc.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_event.dart';

class VerifyEmailPageView extends StatelessWidget {
  const VerifyEmailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
            'We\'ve sent you an email verification. Please open it to verify your account.',
          ),
          const Text(
            'If you haven\'t received a verification email yet, press the button below.',
          ),
          const Text('Please verify your email adress:'),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
            },
            child: const Text('Reload'),
          ),
        ],
      ),
    );
  }
}
