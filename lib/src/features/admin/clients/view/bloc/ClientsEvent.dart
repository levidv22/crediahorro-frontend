import 'package:equatable/equatable.dart';

abstract class ClientsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadClients extends ClientsEvent {}

class SearchClients extends ClientsEvent {
  final String query;
  SearchClients(this.query);
  @override
  List<Object?> get props => [query];
}

enum SortType { nameAsc, nameDesc, dateAsc, dateDesc }

class SortClients extends ClientsEvent {
  final SortType sortType;
  SortClients(this.sortType);

  @override
  List<Object?> get props => [sortType];
}
