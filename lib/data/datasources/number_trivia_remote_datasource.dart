import 'package:dartz/dartz.dart';
import 'package:kiwi_sample/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {

  /// Calss the http://numbersapi.com/{number} end point.
  ///
  ///Throws a [Server Exception] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  

  /// Calss the http://numbersapi.com/random end point.
  ///
  ///Throws a [Server Exception] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}