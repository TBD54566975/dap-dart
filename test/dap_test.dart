import 'package:dap/dap.dart';
import 'package:test/test.dart';

class TestVector {
  final String input;
  final Dap? expected;
  final bool err;

  TestVector({required this.input, this.expected, required this.err});
}

void main() {
  group('Dap.parse', () {
    final vectors = [
      TestVector(
        input: '@moegrammer/didpay.me',
        expected: Dap(handle: 'moegrammer', domain: 'didpay.me'),
        err: false,
      ),
      TestVector(
        input: '@moegrammer/www.linkedin.com',
        expected: Dap(handle: 'moegrammer', domain: 'www.linkedin.com'),
        err: false,
      ),
      TestVector(
        input: '@💰bags/cash.app',
        expected: Dap(handle: '💰bags', domain: 'cash.app'),
        err: false,
      ),
      TestVector(
        input: 'doodoo',
        err: true,
      ),
      TestVector(
        input: 'doo@doo@doodoo.gov',
        err: true,
      ),
      TestVector(
        input: 'doodoo@',
        err: true,
      ),
      TestVector(
        input: '@',
        err: true,
      ),
      TestVector(
        input: '@@',
        err: true,
      ),
      TestVector(
        input: '/',
        err: true,
      ),
      TestVector(
        input: '@/',
        err: true,
      ),
      TestVector(
        input: 'moegrammer@cash.app',
        err: true,
      ),
    ];

    for (var vector in vectors) {
      test(vector.input, () {
        if (vector.err) {
          expect(() => Dap.parse(vector.input), throwsFormatException);
        } else {
          final actual = Dap.parse(vector.input);
          expect(actual.handle, vector.expected!.handle);
          expect(actual.domain, vector.expected!.domain);
        }
      });
    }
  });
}
