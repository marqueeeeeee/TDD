
import 'package:dartz/dartz.dart';
import 'package:kiwi_sample/core/error/failures.dart';

class InputConverter {

  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final result = int.parse(str);

      if(result < 0) {
        throw FormatException();
      } else {
        return Right(result);
      }

    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

