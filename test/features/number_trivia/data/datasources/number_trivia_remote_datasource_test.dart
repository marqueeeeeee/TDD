import 'dart:convert';

import 'package:kiwi_sample/core/error/exceptions.dart';
import 'package:kiwi_sample/data/datasources/number_trivia_remote_datasource.dart';
import 'package:kiwi_sample/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDatasourceImpl datasource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSucces200() {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientSucces404() {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong!', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a get request on a URL with number 
            being the end point and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSucces200();
      //act
      datasource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(
        mockHttpClient.get(
          "http://numbersapi.com/$tNumber",
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTriviaModel when the response code is 200', () async {
      //arrange
      setUpMockHttpClientSucces200();
      //act
      final result = await datasource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw ServerException when the response code is not 200', () async {
      //arrange
      setUpMockHttpClientSucces404();
      //act
      final call = datasource.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });

  });

  group('getRandomTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a get request on a URL with number 
            being the end point and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSucces200();
      //act
      datasource.getRandomNumberTrivia();
      //assert
      verify(
        mockHttpClient.get(
          "http://numbersapi.com/random",
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTriviaModel when the response code is 200', () async {
      //arrange
      setUpMockHttpClientSucces200();
      //act
      final result = await datasource.getRandomNumberTrivia();
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw ServerException when the response code is not 200', () async {
      //arrange
      setUpMockHttpClientSucces404();
      //act
      final call = datasource.getRandomNumberTrivia();
      //assert
      expect(() => call, throwsA(TypeMatcher<ServerException>()));
    });

  });

}
