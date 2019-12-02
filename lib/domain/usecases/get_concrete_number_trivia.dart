
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kiwi_sample/core/error/failures.dart';
import 'package:kiwi_sample/core/usecases/usecase.dart';
import 'package:kiwi_sample/domain/entities/NumberTrivia.dart';
import 'package:kiwi_sample/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {

  //instance of repository
  final NumberTriviaRepository repository;

  //Inject dependecies
  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params param) async {
    return await repository.getConcreteNumberTrivia(param.number);
  }
  
}

class Params extends Equatable {
  final int number;

  Params({@required this.number}) : super([number]);
}