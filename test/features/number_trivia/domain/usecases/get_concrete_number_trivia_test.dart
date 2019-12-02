
import 'package:dartz/dartz.dart';
import 'package:kiwi_sample/core/error/failures.dart';
import 'package:kiwi_sample/domain/entities/NumberTrivia.dart';
import 'package:kiwi_sample/domain/repositories/number_trivia_repository.dart';
import 'package:kiwi_sample/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test('should get trivia from repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
    //act
    final result = await usecase(Params(number: tNumber));
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}