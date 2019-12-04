import 'dart:convert';

import 'package:kiwi_sample/core/error/exceptions.dart';
import 'package:kiwi_sample/data/datasources/number_trivia_local_datasource.dart';
import 'package:kiwi_sample/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDatasourceImpl datasourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    datasourceImpl = NumberTriviaLocalDatasourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia_cache.json")));

    test('should return number trivia model from sharedPreferences when there is one in the cache', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture("trivia_cache.json"));
      //act
      final result = await datasourceImpl.getLastNumberTrivia();
      //assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });

    test('should throw CacheException when there is not a cache value', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = datasourceImpl.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test");

    test('should call shared preferences to cache the data', () async {
      //act
      datasourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJson = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJson));
    });
  });
}
