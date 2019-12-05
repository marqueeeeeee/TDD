import 'package:kiwi_sample/core/error/failures.dart';
import 'package:kiwi_sample/core/util/input_converter.dart';
import 'package:kiwi_sample/domain/entities/NumberTrivia.dart';
import 'package:kiwi_sample/domain/usecases/get_concrete_number_trivia.dart';
import 'package:kiwi_sample/domain/usecases/get_random_number_trivia.dart';
import 'package:kiwi_sample/features/login/presentation/bloc/bloc.dart';
import 'package:kiwi_sample/features/login/presentation/bloc/number_trivia_bloc.dart';
import 'package:kiwi_sample/features/login/presentation/bloc/number_trivia_state.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomTrivia extends Mock implements GetRandomTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomTrivia mockGetRandomTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomTrivia = MockGetRandomTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomTrivia,
      inputConverter: mockInputConverter,
    );
  });

  
  test('initial state should be empty', () async {
    //assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('getTriviaForConcreteNumber', () {
    final tNumberString = "1";
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: "Test");

    void setUpMockConverterSuccess() => when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));
    void setUpMockGetConcreteNumberSuccess() => when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
    test(
      'should input converter to validate and convert string to unsigned integer',
      () async {
        //arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test('should emit [Error] when the input is invalid', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      //assert later
      final expected = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));

      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
 
    test('should get data from concrete use case', () async {
      //arrange
      setUpMockConverterSuccess();
      setUpMockGetConcreteNumberSuccess();
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () async {
      //arrange
      setUpMockConverterSuccess();
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      final expected = [ 
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia)
      ];
      expectLater(bloc.cast(), emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });


  });
}
