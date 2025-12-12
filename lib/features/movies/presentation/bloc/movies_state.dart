import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final bool isOffline;

  const MoviesLoaded({
    required this.movies,
    this.hasReachedMax = false,
    this.isOffline = false,
  });

  MoviesLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    bool? isOffline,
  }) {
    return MoviesLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax, isOffline];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);

  @override
  List<Object> get props => [message];
}

