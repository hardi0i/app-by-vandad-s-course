import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vandad_course_app/services/auth/auth_user.dart';

@immutable
abstract interface class AuthState {
  const AuthState();
}

class AuthStateUnitialized extends AuthState {
  const AuthStateUnitialized();
}

class AuthStateRegistering extends AuthState {
  const AuthStateRegistering(this.exception);

  final Exception? exception;
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn(this.user);

  final AuthUser user;
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  final Exception? exception;
  final bool isLoading;

  @override
  List<Object?> get props => [
        exception,
        isLoading,
      ];
}
