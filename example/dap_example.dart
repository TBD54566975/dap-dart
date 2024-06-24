import 'package:dap/dap.dart';

void main() {
  final dap = Dap.parse('@moegrammer/didpay.me');
  print(dap.handle); // moegrammer
  print(dap.domain); // didpay.me
  print(dap.registryDid); // did:web:didpay.me
  print(dap); // @moegrammer/didpay.me
}
