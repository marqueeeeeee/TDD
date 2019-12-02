
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kiwi_sample/core/error/failures.dart';
import 'package:kiwi_sample/core/usecases/usecase.dart';
import 'package:kiwi_sample/domain/entities/NumberTrivia.dart';
import 'package:kiwi_sample/domain/repositories/number_trivia_repository.dart';

class GetRandomTrivia implements UseCase<NumberTrivia, NoParams> {

  final NumberTriviaRepository repository;

  GetRandomTrivia(this.repository);
  
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams param) async {
    return await repository.getRandomNumberTrivia();
  }
}
