import 'package:flutter/material.dart';
import 'package:vandad_course_app/constants/routes.dart';
import 'package:vandad_course_app/services/auth/auth_service.dart';

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
            onPressed: () async {
              await AuthService.firebase().emailVerification();
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();

              if (!context.mounted) return;

              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Reload'),
          ),
        ],
      ),
    );
  }
}
