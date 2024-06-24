/// A money address is a Uniform Resource Name (URN) that represents a means
/// through which an individual can be payed a specific currency.
/// The URN is structured as follows:
/// `urn:<currency_code>:<curr_specific_part>`
/// More info [here](https://github.com/TBD54566975/dap?tab=readme-ov-file#money-address)
class MoneyAddress {
  final String currency;
  final String css;

  String get urn => 'urn:$currency:$css';

  MoneyAddress({required this.currency, required this.css});

  factory MoneyAddress.parse(String input) {
    if (!input.startsWith('urn:')) {
      throw FormatException('Expected urn. Got $input');
    }

    final urnless = input.substring(4);
    final delimIdx = urnless.indexOf(':');
    if (delimIdx == -1) {
      throw FormatException(
          'Invalid money address. Expected urn:[currency]:[css]. Got $input');
    }

    final nid = urnless.substring(0, delimIdx);
    final nss = urnless.substring(delimIdx + 1);

    return MoneyAddress(
      currency: nid,
      css: nss,
    );
  }

  @override
  String toString() {
    return urn;
  }
}
