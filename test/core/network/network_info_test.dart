import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test(
      'should forward the call to Connectivity.checkConnectivity',
      () async {
        when(mockConnectivity.checkConnectivity()).thenAnswer(
          (_) async => ConnectivityResult.wifi,
        );

        final result = await networkInfoImpl.isConnected;
        verify(mockConnectivity.checkConnectivity());
        expect(result, true);
      },
    );
  });
}
