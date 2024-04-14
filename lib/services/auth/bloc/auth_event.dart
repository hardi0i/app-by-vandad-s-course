import 'package:flutter/material.dart';

@immutable
abstract interface class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogin extends AuthEvent {
  const AuthEventLogin(
    this.email,
    this.password,
  );

  final String email;
  final String password;
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent {
  const AuthEventRegister(
    this.email,
    this.password,
  );

  final String email;
  final String password;
}

class AuthEventForgotPassword extends AuthEvent {
  const AuthEventForgotPassword({this.email});

  final String? email;
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}
