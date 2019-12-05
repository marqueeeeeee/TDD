import 'dart:convert';

import 'package:kiwi_sample/core/error/exceptions.dart';
import 'package:kiwi_sample/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

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

const BASE_URL = "http://numbersapi.com";

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl({ @required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl("$BASE_URL/$number");

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl("$BASE_URL/random");

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(url, headers: {
      'Content-Type': 'application/json'
    });

    if(response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}