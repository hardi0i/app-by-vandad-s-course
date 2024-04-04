import 'package:flutter/material.dart';
import 'package:vandad_course_app/services/auth/auth_user.dart';

@immutable
abstract interface class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  const AuthStateLoggedIn(this.user);

  final AuthUser user;
}

class AuthStateLoginFailure extends AuthState {
  const AuthStateLoginFailure(this.exception);

  final Exception exception;
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogoutFailure extends AuthState {
  const AuthStateLogoutFailure(this.exception);

  final Exception exception;
}
