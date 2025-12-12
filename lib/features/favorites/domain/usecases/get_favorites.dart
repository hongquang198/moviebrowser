import 'package:dartz/dartz.dart';
import '../../../movies/domain/entities/movie.dart';
import '../repositories/favorites_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetFavorites implements UseCase<List<Movie>, NoParams> {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}

