import 'package:dap/dap.dart';
import 'package:test/test.dart';

void main() {
  group('DapResolver.resolve', () {
    test('should resolve DAP', () async {
      final dap = Dap.parse('@moegrammer/didpay.me');

      // TODO: use mocks
      final resolver = DapResolver();

      final result = await resolver.resolve(dap);

      expect(result.dap.handle, 'moegrammer');
      expect(result.dap.domain, 'didpay.me');
      expect(result.dap.registryDid, 'did:web:didpay.me');
      expect(result.moneyAddresses.length, 1);
    });
  });
}
