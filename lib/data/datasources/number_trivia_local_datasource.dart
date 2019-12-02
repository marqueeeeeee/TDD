import 'dart:async';

import 'package:kiwi_sample/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {

  ///Gets the cached [NumberTriviaModel] which was gotten the last time
  ///the user had an internet connection.
  ///
  ///Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();
  
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}