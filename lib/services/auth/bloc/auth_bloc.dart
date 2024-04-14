import 'package:bloc/bloc.dart';
import 'package:vandad_course_app/services/auth/auth_provider.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_event.dart';
import 'package:vandad_course_app/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._provider)
      : super(
          const AuthStateUnitialized(isLoading: true),
        ) {
    on<AuthEventSendEmailVerification>(authEventSendEmailVerification);
    on<AuthEventInitialize>(authEventInitialize);
    on<AuthEventLogin>(authEventLogin);
    on<AuthEventLogOut>(authEventLogout);
    on<AuthEventRegister>(authEventRegister);
    on<AuthEventShouldRegister>(authEventShouldRegister);
    on<AuthEventForgotPassword>(authEventForgotPassword);
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
        const AuthStateNeedsVerification(isLoading: false),
      );
    } else {
      emit(
        AuthStateLoggedIn(user: user, isLoading: false),
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
        const AuthStateNeedsVerification(isLoading: false),
      );
    } on Exception catch (e) {
      emit(
        AuthStateRegistering(exception: e, isLoading: false),
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
        loadingText: 'Wait until login',
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
          const AuthStateNeedsVerification(isLoading: false),
        );
      } else {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );

        emit(
          AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ),
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
      const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ),
    );
  }

  Future<void> authEventForgotPassword(
    AuthEventForgotPassword event,
    Emitter emit,
  ) async {
    emit(
      const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ),
    );

    final email = event.email;

    if (email == null) {
      return;
    }

    emit(
      const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ),
    );

    bool didSentEmail;
    Exception? exception;

    try {
      await _provider.sendPasswordReset(email: email);
      didSentEmail = true;
      exception = null;
    } on Exception catch (e) {
      didSentEmail = false;
      exception = e;
    }

    emit(
      AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSentEmail,
        isLoading: false,
      ),
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
