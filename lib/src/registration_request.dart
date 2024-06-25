import 'dart:convert';

class RegistrationRequest {
  final String id;
  final String handle;
  final String did;
  final String domain;
  final String signature;

  RegistrationRequest({
    required this.id,
    required this.handle,
    required this.did,
    required this.domain,
    required this.signature,
  });

  factory RegistrationRequest.fromJson(String source) =>
      RegistrationRequest.fromMap(jsonDecode(source));

  factory RegistrationRequest.fromMap(Map<String, dynamic> map) {
    return RegistrationRequest(
      id: map['id'],
      handle: map['handle'],
      did: map['did'],
      domain: map['domain'],
      signature: map['signature'],
    );
  }

  // Converts the instance into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'handle': handle,
      'did': did,
      'domain': domain,
      'signature': signature,
    };
  }

  // Converts the instance to a JSON string
  String toJson() => jsonEncode(toMap());

  @override
  String toString() => toJson();
}
