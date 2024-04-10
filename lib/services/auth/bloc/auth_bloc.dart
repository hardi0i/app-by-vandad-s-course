import 'package:bloc/bloc.dart';
import 'package:vandad_course_app/services/auth/auth_provider.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_event.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._provider)
      : super(
          const AuthStateUnitialized(),
        ) {
    on<AuthEventSendEmailVerification>(authEventSendEmailVerification);
    on<AuthEventInitialize>(authEventInitialize);
    on<AuthEventLogin>(authEventLogin);
    on<AuthEventLogOut>(authEventLogout);
    on<AuthEventRegister>(authEventRegister);
    on<AuthEventShouldRegister>(authEventShouldRegister);
  }

  final AuthProvider _provider;

  //initialize
  Future<void> authEventInitialize(
    AuthEventInitialize event,
    Emitter emit,
  ) async {
    await _provider.initializeApp();

    final user = _provider.currentUser;

    if (user == null) {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ),
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

  Future<void> authEventRegister(
    AuthEventRegister event,
    Emitter emit,
  ) async {
    final email = event.email;
    final password = event.password;

    try {
      await _provider.createNewUser(
        email: email,
        password: password,
      );

      await _provider.emailVerification();

      emit(
        const AuthStateNeedsVerification(),
      );
    } on Exception catch (e) {
      emit(
        AuthStateRegistering(e),
      );
    }
  }

  Future<void> authEventSendEmailVerification(
    AuthEventSendEmailVerification event,
    Emitter emit,
  ) async {
    await _provider.emailVerification();

    emit(state);
  }

  Future<void> authEventLogin(
    AuthEventLogin event,
    Emitter emit,
  ) async {
    emit(
      const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
      ),
    );

    final email = event.email;
    final password = event.password;

    try {
      final user = await _provider.logIn(
        email: email,
        password: password,
      );

      if (!user.isEmailVerified) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );

        emit(
          const AuthStateNeedsVerification(),
        );
      } else {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );

        emit(
          AuthStateLoggedIn(user),
        );
      }
    } on Exception catch (error) {
      emit(
        AuthStateLoggedOut(
          exception: error,
          isLoading: false,
        ),
      );
    }
  }

  Future<void> authEventShouldRegister(
    AuthEventShouldRegister event,
    Emitter emit,
  ) async {
    emit(
      const AuthStateRegistering(null),
    );
  }

  Future<void> authEventLogout(
    AuthEventLogOut event,
    Emitter emit,
  ) async {
    try {
      await _provider.logOut();

      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ),
      );
    }
  }
}
