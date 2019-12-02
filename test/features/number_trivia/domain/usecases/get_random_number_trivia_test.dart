
import 'package:dartz/dartz.dart';
import 'package:kiwi_sample/core/usecases/usecase.dart';
import 'package:kiwi_sample/domain/entities/NumberTrivia.dart';
import 'package:kiwi_sample/domain/repositories/number_trivia_repository.dart';
import 'package:kiwi_sample/domain/usecases/get_random_number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  GetRandomTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test('should get random trivia from repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async => Right(tNumberTrivia));
    //act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}