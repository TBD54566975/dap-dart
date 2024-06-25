import 'package:test/test.dart';
import 'package:dap/src/money_address.dart';

class Vector {
  final String input;
  final MoneyAddress expected;
  final bool err;

  Vector({required this.input, required this.expected, required this.err});
}

void main() {
  group('MoneyAddress.parse', () {
    final testCases = [
      Vector(
        input: 'urn:usdc:eth:0x2345y7432',
        expected:
            MoneyAddress(currency: 'usdc', protocol: 'eth', pss: '0x2345y7432'),
        err: false,
      ),
      Vector(
        input: 'urn:btc:addr:m12345677axcv2345',
        expected: MoneyAddress(
            currency: 'btc', protocol: 'addr', pss: 'm12345677axcv2345'),
        err: false,
      ),
      Vector(
        input: 'urn:btc:lnurl:https://someurl.com',
        expected: MoneyAddress(
            currency: 'btc', protocol: 'lnurl', pss: 'https://someurl.com'),
        err: false,
      ),
      Vector(
        input: 'urn:btc:spaddr:sp1234abcd5678',
        expected: MoneyAddress(
            currency: 'btc', protocol: 'spaddr', pss: 'sp1234abcd5678'),
        err: false,
      ),
    ];

    for (var testCase in testCases) {
      test(testCase.input, () {
        if (testCase.err) {
          expect(
              () => MoneyAddress.parse(testCase.input), throwsFormatException);
        } else {
          final actual = MoneyAddress.parse(testCase.input);
          expect(actual.currency, testCase.expected.currency);
          expect(actual.protocol, testCase.expected.protocol);
          expect(actual.urn, testCase.input);
        }
      });
    }
  });
}
