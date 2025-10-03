import 'package:crediahorro/src/features/admin/clients/create/bloc/ClienteFormEvent.dart';
import 'package:crediahorro/src/features/admin/clients/create/bloc/ClienteFormState.dart';
import 'package:crediahorro/src/features/admin/clients/models/cliente.dart';
import 'package:crediahorro/src/services/ClienteService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ClienteFormBloc extends Bloc<ClienteFormEvent, ClienteFormState> {
  final ClienteService clienteService;

  ClienteFormBloc(this.clienteService) : super(const ClienteFormState()) {
    // Campos cliente
    on<NombreChanged>((e, emit) => emit(state.copyWith(nombre: e.nombre)));
    on<DniChanged>((e, emit) => emit(state.copyWith(dni: e.dni)));
    on<DireccionChanged>(
      (e, emit) => emit(state.copyWith(direccion: e.direccion)),
    );
    on<WhatsappChanged>(
      (e, emit) => emit(state.copyWith(whatsapp: e.whatsapp)),
    );
    on<CorreoChanged>((e, emit) => emit(state.copyWith(correo: e.correo)));

    // Campos préstamo
    on<MontoChanged>((e, emit) => emit(state.copyWith(monto: e.monto)));
    on<TasaChanged>((e, emit) => emit(state.copyWith(tasa: e.tasa)));
    on<CuotasChanged>((e, emit) => emit(state.copyWith(cuotas: e.cuotas)));
    on<TipoCuotaChanged>((e, emit) => emit(state.copyWith(tipoCuota: e.tipo)));
    on<FechaCreacionChanged>(
      (e, emit) => emit(state.copyWith(fechaCreacion: e.fecha)),
    );
    on<FechaInicioChanged>(
      (e, emit) => emit(state.copyWith(fechaInicio: e.fecha)),
    );

    // Guardar
    on<GuardarClienteSubmitted>(_onGuardarCliente);
  }

  Future<void> _onGuardarCliente(
    GuardarClienteSubmitted event,
    Emitter<ClienteFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));
    try {
      final cliente = Cliente(
        nombre: state.nombre,
        dni: state.dni,
        direccion: state.direccion,
        telefonoWhatsapp: state.whatsapp,
        correoElectronico: state.correo,
        fechaCreacion: state.fechaCreacion != null
            ? DateFormat("yyyy-MM-dd").format(state.fechaCreacion!)
            : null,
        prestamos: [
          Prestamo(
            monto: state.monto,
            tasaInteresMensual: state.tasa,
            numeroCuotas: state.cuotas,
            tipoCuota: state.tipoCuota,
            fechaInicio: state.fechaInicio != null
                ? DateFormat("yyyy-MM-dd").format(state.fechaInicio!)
                : '',
            fechaCreacion: state.fechaCreacion != null
                ? DateFormat("yyyy-MM-dd").format(state.fechaCreacion!)
                : '',
          ),
        ],
      );

      await clienteService.crearCliente(cliente);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
