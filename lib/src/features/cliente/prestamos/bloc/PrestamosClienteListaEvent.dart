import 'package:equatable/equatable.dart';

abstract class PrestamosClienteListaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPrestamosClienteLista extends PrestamosClienteListaEvent {}

class SearchPrestamosClienteLista extends PrestamosClienteListaEvent {
  final String query;
  SearchPrestamosClienteLista(this.query);
  @override
  List<Object?> get props => [query];
}

enum SortPrestamoType { montoAsc, montoDesc, fechaAsc, fechaDesc, estado }

class SortPrestamosClienteLista extends PrestamosClienteListaEvent {
  final SortPrestamoType sortType;
  SortPrestamosClienteLista(this.sortType);
  @override
  List<Object?> get props => [sortType];
}
