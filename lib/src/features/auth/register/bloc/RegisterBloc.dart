import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/domain/utils/Resource.dart';
import 'package:crediahorro/src/features/auth/register/bloc/RegisterEvent.dart';
import 'package:crediahorro/src/features/auth/register/bloc/RegisterState.dart';
import 'package:crediahorro/src/services/AuthService.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc(this.authService) : super(const RegisterState()) {
    on<RegisterUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<RegisterWhatsappChanged>((event, emit) {
      emit(state.copyWith(whatsapp: event.whatsapp));
    });

    on<RegisterEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<RegisterPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(status: Resource.loading()));
      try {
        await authService.register(
          state.username,
          state.password,
          state.whatsapp,
          state.email,
        );
        emit(state.copyWith(status: Resource.success("Registro exitoso")));
      } catch (e) {
        emit(state.copyWith(status: Resource.error("Error en el registro")));
      }
    });
  }
}
