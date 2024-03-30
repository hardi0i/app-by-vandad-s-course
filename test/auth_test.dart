import 'package:test/test.dart';
import 'package:vandad_course_app/services/auth/auth_exceptions.dart';
import 'package:vandad_course_app/services/auth/auth_provider.dart';
import 'package:vandad_course_app/services/auth/auth_user.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();
      test(
        'Should not be initialized to begin with',
        () {
          expect(
            provider.isInitialized,
            false,
          );
        },
      );

      test(
        'Cannot log out if not initialized',
        () {
          expect(
            provider.logOut(),
            throwsA(
              const TypeMatcher<NotInitializedException>(),
            ),
          );
        },
      );

      test(
        'Should be able to initialized',
        () async {
          await provider.initializeApp();

          expect(
            provider.isInitialized,
            true,
          );
        },
      );

      test(
        'User should be null after initialization',
        () {
          expect(
            provider.currentUser,
            null,
          );
        },
      );

      test(
        'Should be able to initialize in less than 2 seconds',
        () async {
          await provider.initializeApp();

          expect(
            provider.isInitialized,
            true,
          );
        },
        timeout: const Timeout(
          Duration(
            seconds: 2,
          ),
        ),
      );

      test(
        'Create user should delegate to logIn function',
        () async {
          final badEmail = provider.createNewUser(
            email: 'foo@bar.com',
            password: 'anypassword',
          );

          expect(
            badEmail,
            throwsA(
              const TypeMatcher<InvalidCredentionalsAuthException>(),
            ),
          );

          final badPassword = provider.createNewUser(
            email: 'any@gmail.com',
            password: 'foobar',
          );

          expect(
            badPassword,
            throwsA(
              const TypeMatcher<InvalidCredentionalsAuthException>(),
            ),
          );

          final user = await provider.createNewUser(
            email: 'any@gmail.com',
            password: '123',
          );

          expect(
            provider.currentUser,
            user,
          );

          expect(
            user.isEmailVerified,
            false,
          );
        },
      );

      test(
        'Logged in user should be able to get verified',
        () {
          provider.emailVerification();

          final user = provider.currentUser;

          expect(
            user,
            isNotNull,
          );

          expect(
            user!.isEmailVerified,
            true,
          );
        },
      );

      test(
        'Should ba able to logOut and logIn in again',
        () async {
          await provider.logOut();
          await provider.logIn(
            email: 'user',
            password: 'password',
          );

          final user = provider.currentUser;

          expect(
            user,
            isNotNull,
          );
        },
      );
    },
  );
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  bool _isInitilized = false;

  bool get isInitialized => _isInitilized;

  @override
  Future<AuthUser> createNewUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();

    await Future.delayed(
      const Duration(seconds: 1),
    );

    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> emailVerification() async {
    if (!isInitialized) throw NotInitializedException();

    final user = _user;

    if (user == null) throw InvalidCredentionalsAuthException();

    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true,
      email: 'foo@bar.com',
    );

    _user = newUser;
  }

  @override
  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));

    _isInitilized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();

    if (email == 'foo@bar.com') throw InvalidCredentionalsAuthException();

    if (password == 'foobar') throw InvalidCredentionalsAuthException();

    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false,
      email: 'foo@bar.com',
    );

    _user = user;

    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();

    if (_user == null) throw UserNotLoggedInAuthException();

    await Future.delayed(const Duration(seconds: 1));

    _user = null;
  }
}
