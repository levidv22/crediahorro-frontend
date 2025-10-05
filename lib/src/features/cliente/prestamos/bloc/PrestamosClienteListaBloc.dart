import 'package:crediahorro/src/features/cliente/prestamos/bloc/PrestamosClienteListaEvent.dart';
import 'package:crediahorro/src/features/cliente/prestamos/bloc/PrestamosClienteListaState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/services/UsuariosService.dart';

class PrestamosClienteListaBloc
    extends Bloc<PrestamosClienteListaEvent, PrestamosClienteListaState> {
  final UsuariosService usuariosService;

  PrestamosClienteListaBloc(this.usuariosService)
    : super(PrestamosClienteListaInitial()) {
    on<LoadPrestamosClienteLista>(_onLoad);
    on<SearchPrestamosClienteLista>(_onSearch);
    on<SortPrestamosClienteLista>(_onSort);
  }

  Future<void> _onLoad(
    LoadPrestamosClienteLista event,
    Emitter<PrestamosClienteListaState> emit,
  ) async {
    emit(PrestamosClienteListaLoading());
    try {
      final prestamos = await usuariosService.getMisPrestamos();
      emit(
        PrestamosClienteListaLoaded(prestamos: prestamos, filtered: prestamos),
      );
    } catch (e) {
      emit(PrestamosClienteListaError("Error al cargar préstamos: $e"));
    }
  }

  void _onSearch(
    SearchPrestamosClienteLista event,
    Emitter<PrestamosClienteListaState> emit,
  ) {
    if (state is PrestamosClienteListaLoaded) {
      final current = state as PrestamosClienteListaLoaded;
      final query = event.query.toLowerCase();

      final filtered = current.prestamos.where((p) {
        return p.estado!.toLowerCase().contains(query) ||
            p.monto.toString().contains(query) ||
            p.fechaCreacion.toLowerCase().contains(query);
      }).toList();

      emit(
        PrestamosClienteListaLoaded(
          prestamos: current.prestamos,
          filtered: filtered,
        ),
      );
    }
  }

  void _onSort(
    SortPrestamosClienteLista event,
    Emitter<PrestamosClienteListaState> emit,
  ) {
    if (state is PrestamosClienteListaLoaded) {
      final current = state as PrestamosClienteListaLoaded;
      final sorted = [...current.filtered];

      switch (event.sortType) {
        case SortPrestamoType.montoAsc:
          sorted.sort((a, b) => a.monto.compareTo(b.monto));
          break;
        case SortPrestamoType.montoDesc:
          sorted.sort((a, b) => b.monto.compareTo(a.monto));
          break;
        case SortPrestamoType.fechaAsc:
          sorted.sort((a, b) => a.fechaCreacion.compareTo(b.fechaCreacion));
          break;
        case SortPrestamoType.fechaDesc:
          sorted.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
          break;
        case SortPrestamoType.estado:
          sorted.sort((a, b) => (a.estado ?? '').compareTo(b.estado ?? ''));
          break;
      }

      emit(
        PrestamosClienteListaLoaded(
          prestamos: current.prestamos,
          filtered: sorted,
        ),
      );
    }
  }
}
