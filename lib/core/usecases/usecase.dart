import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kiwi_sample/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params param);
}

class NoParams extends Equatable {}