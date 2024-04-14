import 'package:vandad_course_app/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createNewUser({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> emailVerification();

  Future<void> initializeApp();

  Future<void> sendPasswordReset({required String email});
}
