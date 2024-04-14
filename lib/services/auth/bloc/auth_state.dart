import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vandad_course_app/services/auth/auth_user.dart';

@immutable
abstract interface class AuthState {
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });

  final bool isLoading;
  final String? loadingText;
}

class AuthStateUnitialized extends AuthState {
  const AuthStateUnitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  const AuthStateRegistering({
    required this.exception,
    required bool isLoading,
  }) : super(isLoading: isLoading);

  final Exception? exception;
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);

  final AuthUser user;
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(
          isLoading: isLoading,
        );

  final Exception? exception;
  final bool hasSentEmail;
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  final Exception? exception;

  @override
  List<Object?> get props => [
        exception,
        isLoading,
      ];
}
