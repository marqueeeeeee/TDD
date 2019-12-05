
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  final List properties;

  Failure([ this.properties = const<dynamic>[]]) ;

  @override
  List<Object> get props => [properties];

}

class NegativeNumberFailure extends Failure {}


//General Failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class InvalidInputFailure extends Failure {}