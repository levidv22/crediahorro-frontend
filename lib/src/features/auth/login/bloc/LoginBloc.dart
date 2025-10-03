import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/login/bloc/LoginEvent.dart';
import 'package:crediahorro/src/features/auth/login/bloc/LoginState.dart';
import 'package:crediahorro/src/services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

//guarda los datos ingresados por teclado.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc(this.authService) : super(const LoginState()) {
    // Evento: cambio de usuario
    on<LoginUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    // Evento: cambio de contraseña
    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    // Evento: submit del login
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(status: Resource.loading()));
      try {
        await authService.login(state.username, state.password);

        // Obtener el role desde SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final role = prefs.getString('role') ?? "";

        if (role == "USUARIO") {
          emit(
            state.copyWith(
              status: Resource.success(AppRouter.prestamosclientes),
            ),
          );
        } else {
          emit(state.copyWith(status: Resource.success(AppRouter.dashboard)));
        }
      } catch (e) {
        emit(state.copyWith(status: Resource.error("Credenciales inválidas")));
      }
    });
  }
}
