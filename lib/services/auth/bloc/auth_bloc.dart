import 'package:bloc/bloc.dart';
import 'package:vandad_course_app/services/auth/auth_provider.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_event.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._provider)
      : super(
          const AuthStateLoading(),
        ) {
    on<AuthEventInitialize>(authEventInitialize);
    on<AuthEventLogin>(authEventLogin);
    on<AuthEventLogOut>(authEventLogout);
  }

  final AuthProvider _provider;

  //initialize
  Future<void> authEventInitialize(
      AuthEventInitialize event, Emitter emit) async {
    await _provider.initializeApp();

    final user = _provider.currentUser;

    if (user == null) {
      emit(
        const AuthStateLoggedOut(),
      );
    } else if (!user.isEmailVerified) {
      emit(
        const AuthStateNeedsVerification(),
      );
    } else {
      emit(
        AuthStateLoggedIn(user),
      );
    }
  }

  Future<void> authEventLogin(AuthEventLogin event, Emitter emit) async {
    emit(
      const AuthStateLoading(),
    );

    final email = event.password;
    final password = event.password;

    try {
      final user = await _provider.logIn(
        email: email,
        password: password,
      );

      emit(
        AuthStateLoggedIn(user),
      );
    } on Exception catch (error) {
      emit(
        AuthStateLoginFailure(error),
      );
    }
  }

  Future<void> authEventLogout(AuthEventLogOut event, Emitter emit) async {
    try {
      emit(
        const AuthStateLoading(),
      );

      await _provider.logOut();

      emit(
        const AuthStateLoggedOut(),
      );
    } on Exception catch (e) {
      emit(
        AuthStateLogoutFailure(e),
      );
    }
  }
}
