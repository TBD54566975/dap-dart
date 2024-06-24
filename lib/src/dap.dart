/// Represents a Decentralized Agnostic Paytag (DAP).
class Dap {
  String handle;
  String domain;
  String get registryDid => 'did:web:$domain';
  String get dap => '@$handle/$domain';

  Dap({required this.handle, required this.domain});

  /// Factory function to create a Dap instance from a formatted string.
  ///
  /// The input string must be in the format `@handle/domain`, where:
  /// - `handle` is a user handle that starts with `@`.
  /// - `domain` is the domain associated with the handle.
  ///
  /// Throws a [FormatException] if the input string does not meet the required format
  /// or contains invalid characters.
  factory Dap.parse(String input) {
    if (input.isEmpty || input[0] != '@') {
      throw FormatException('Invalid DAP: Must start with "@"');
    }

    int delimIdx = input.lastIndexOf('/');
    if (delimIdx == -1) {
      throw FormatException('Invalid DAP: Must contain "/"');
    }

    String handle = input.substring(1, delimIdx);
    String domain = input.substring(delimIdx + 1);

    if (domain.isEmpty) {
      throw FormatException('Invalid DAP: Domain cannot be empty');
    }

    if (handle.length < 3 || handle.length > 30) {
      throw FormatException(
          'Invalid DAP: Handle must be between 3-30 characters');
    }

    for (int i = 0; i < handle.length; i++) {
      var c = handle.codeUnitAt(i);
      if (_isControlCharacter(c) || _isPunctuation(c)) {
        throw FormatException('Invalid character in handle at pos $i');
      }
    }

    return Dap(handle: handle, domain: domain);
  }

  @override
  String toString() {
    return dap;
  }

  /// Helper function to check if a character is a control character.
  ///
  /// Control characters are non-printable characters used to control the interpretation
  /// or display of text. In Unicode, control characters include:
  ///
  /// - ASCII control characters (U+0000 to U+001F)
  /// - Delete (U+007F)
  /// - C1 control characters (U+0080 to U+009F)
  ///
  /// References:
  /// - [Basic Latin Control Characters (C0 Controls)](https://www.unicode.org/charts/PDF/U0000.pdf)
  /// - [C1 Control Characters and Latin-1 Supplement](https://www.unicode.org/charts/PDF/U0080.pdf)
  static bool _isControlCharacter(int codeUnit) {
    return codeUnit <= 31 || (codeUnit >= 127 && codeUnit <= 159);
  }

  /// Helper function to check if a character is punctuation.
  ///
  /// Punctuation characters include various symbols that are used to separate sentences
  /// and phrases, but are not letters or digits. This function checks for characters
  /// in the following ranges:
  ///
  /// - `!` to `/` (U+0021 to U+002F)
  /// - `:` to `@` (U+003A to U+0040)
  /// - `[` to `` ` `` (U+005B to U+0060)
  /// - `{` to `~` (U+007B to U+007E)
  static bool _isPunctuation(int codeUnit) {
    return (codeUnit >= 33 && codeUnit <= 47) ||
        (codeUnit >= 58 && codeUnit <= 64) ||
        (codeUnit >= 91 && codeUnit <= 96) ||
        (codeUnit >= 123 && codeUnit <= 126);
  }
}

class DapResolver {
  /// default constructor with http client and a web5 did resolver
  /// can construct yourself for mocking purposes etc.
  /// getRegistryEndpoint() -> resolve registry did, find DAPRegistry service endpoint
  /// dereferenceHandle() -> makes GET request to registry endpoint to get DAP's DID
  /// resolveDid() -> resolve DAP's DID, get back did document
  /// getMoneyAddresses(dap) -> getRegistryEndpoint() -> dereferenceHandle() -> resolveDid() -> parse out money addresses from did document -> return list of money addrrsses
}
