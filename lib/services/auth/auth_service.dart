import 'package:vandad_course_app/services/auth/auth_provider.dart';
import 'package:vandad_course_app/services/auth/auth_user.dart';
import 'package:vandad_course_app/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService({required this.provider});

  factory AuthService.firebase() => AuthService(
        provider: FirebaseAuthProvider(),
      );

  @override
  Future<AuthUser> createNewUser({
    required String email,
    required String password,
  }) =>
      provider.createNewUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> emailVerification() => provider.emailVerification();

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> initializeApp() => provider.initializeApp();
}
