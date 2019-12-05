import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kiwi_sample/core/util/input_converter.dart';
import 'package:kiwi_sample/domain/usecases/get_concrete_number_trivia.dart';
import 'package:kiwi_sample/domain/usecases/get_random_number_trivia.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE =
    "The number must be a positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomTrivia getRandomTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomTrivia random,
      @required this.inputConverter})
      : assert(concrete != null),
        assert(random != null),
        getConcreteNumberTrivia = concrete,
        getRandomTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (number) async* {
        yield Loading();
        final resultEither = await getConcreteNumberTrivia(Params(number: number));
        yield resultEither.fold((failure) => throw UnimplementedError(), (trivia) => Loaded(trivia: trivia));
      });
    }
  }
}
