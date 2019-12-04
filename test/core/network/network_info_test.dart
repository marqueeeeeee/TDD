import 'package:kiwi_sample/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('is Connected', () {
    test(
      'should forward call to data connection checker.HasConnection',
      () async {
        //arrange
        final tHasConnectionFuture = Future.value(true);
        when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);
        //act
        final result = networkInfoImpl.isConnected;
        //assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
        
      },
    );
  });
}
