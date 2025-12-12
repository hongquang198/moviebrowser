import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/favorites_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class IsFavorite implements UseCase<bool, IsFavoriteParams> {
  final FavoritesRepository repository;

  IsFavorite(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsFavoriteParams params) async {
    return await repository.isFavorite(params.movieId);
  }
}

class IsFavoriteParams extends Equatable {
  final int movieId;

  const IsFavoriteParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

