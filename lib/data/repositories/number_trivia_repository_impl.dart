import 'package:dartz/dartz.dart';
import 'package:kiwi_sample/core/error/exceptions.dart';
import 'package:kiwi_sample/core/error/failures.dart';
import 'package:kiwi_sample/core/platform/network_info.dart';
import 'package:kiwi_sample/data/datasources/number_trivia_local_datasource.dart';
import 'package:kiwi_sample/data/datasources/number_trivia_remote_datasource.dart';
import 'package:kiwi_sample/domain/entities/NumberTrivia.dart';
import 'package:kiwi_sample/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRespositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource remoteDatasource;
  final NumberTriviaLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  NumberTriviaRespositoryImpl(
      {@required this.remoteDatasource,
      @required this.localDatasource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDatasource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDatasource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDatasource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDatasource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
