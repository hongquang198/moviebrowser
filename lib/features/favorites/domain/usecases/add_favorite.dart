import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/favorites_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddFavorite implements UseCase<void, AddFavoriteParams> {
  final FavoritesRepository repository;

  AddFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(AddFavoriteParams params) async {
    return await repository.addFavorite(params.movie);
  }
}

class AddFavoriteParams extends Equatable {
  final Movie movie;

  const AddFavoriteParams({required this.movie});

  @override
  List<Object> get props => [movie];
}

