import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/favorites_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class RemoveFavorite implements UseCase<void, RemoveFavoriteParams> {
  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFavoriteParams params) async {
    return await repository.removeFavorite(params.movieId);
  }
}

class RemoveFavoriteParams extends Equatable {
  final int movieId;

  const RemoveFavoriteParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

