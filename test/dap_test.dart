import 'package:dap/dap.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final dap = Dap();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(dap.hehe, isTrue);
    });
  });
}
