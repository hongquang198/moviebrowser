import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchMoviesEvent extends SearchEvent {
  final String query;

  const SearchMoviesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

