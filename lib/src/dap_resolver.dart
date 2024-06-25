import 'dart:convert';

import 'package:dap/src/dap.dart';
import 'package:dap/src/registration_request.dart';
import 'package:dap/src/money_address.dart';
import 'package:http/http.dart' as http;
import 'package:web5/web5.dart';

class DapResolver {
  http.Client client;
  DidResolver didResolver;

  DapResolver(this.didResolver, {http.Client? client})
      : client = client ?? http.Client();

  Future<List<MoneyAddress>> getMoneyAddresses(Dap dap) async {
    throw UnimplementedError();
  }

  Future<DapResolutionResult> resolve(Dap dap) async {
    final registryDidResolution = await didResolver.resolveDid(dap.registryDid);
    if (registryDidResolution.hasError()) {
      throw DapResolutionException(
          'Failed to resolve registry DID: ${registryDidResolution.didResolutionMetadata.error}');
    }

    final registryServices = registryDidResolution.didDocument!.service ?? [];
    final dapRegistryService = registryServices.firstWhere(
      (service) => service.type == 'DAPRegistry',
      orElse: () => throw DapResolutionException(
          'Registry DID does not have a DAPRegistry service'),
    );

    if (dapRegistryService.serviceEndpoint.isEmpty) {
      throw DapResolutionException(
          'DAPRegistry service does not have a service endpoint');
    }

    Uri registryEndpoint;

    try {
      registryEndpoint = Uri.parse(dapRegistryService.serviceEndpoint.first);
    } on FormatException {
      throw DapResolutionException(
          'Invalid service endpoint in DAPRegistry service');
    }

    final dereferenceUrl =
        registryEndpoint.replace(path: '/daps/${dap.handle}');

    http.Response dereferenceResponse;
    try {
      dereferenceResponse = await client.get(dereferenceUrl);
    } on Exception catch (e) {
      throw DapResolutionException('Failed to dereference DAP handle: $e');
    }

    if (dereferenceResponse.statusCode != 200) {
      throw DapResolutionException(
          'Failed to dereference DAP handle: (${dereferenceResponse.statusCode}) ${dereferenceResponse.body}');
    }

    DereferencedHandle dereferencedDap;
    try {
      dereferencedDap = DereferencedHandle.fromJson(dereferenceResponse.body);
    } on FormatException catch (e) {
      throw DapResolutionException(
          'Failed to parse dereferenced DAP handle: $e');
    }

    final dapDidResolution =
        await didResolver.resolveDid(dereferencedDap.did.uri);

    if (dapDidResolution.hasError()) {
      throw DapResolutionException(
          'Failed to resolve DAP DID: ${dapDidResolution.didResolutionMetadata.error}');
    }

    final dapDidServices = dapDidResolution.didDocument!.service ?? [];
    List<MoneyAddress> moneyAddresses = [];

    for (var service in dapDidServices) {
      if (service.type == 'MoneyAddress') {
        try {
          var address = MoneyAddress.parse(service.serviceEndpoint.first);
          moneyAddresses.add(address);
        } catch (e) {
          print(
              'Error parsing MoneyAddress for service: ${service.serviceEndpoint.first}, error: $e');
        }
      }
    }

    return DapResolutionResult(
      dap: dap,
      dapDid: dereferencedDap.did,
      dapDidDocument: dapDidResolution.didDocument!,
      registryDidDocument: registryDidResolution.didDocument!,
      registryEndpoint: registryEndpoint,
      moneyAddresses: moneyAddresses,
    );
  }
}

class DapResolutionResult {
  final Dap dap;
  final Did dapDid;
  final DidDocument dapDidDocument;
  final DidDocument registryDidDocument;
  final Uri registryEndpoint;
  final List<MoneyAddress> moneyAddresses;

  DapResolutionResult({
    required this.dap,
    required this.dapDid,
    required this.dapDidDocument,
    required this.registryDidDocument,
    required this.registryEndpoint,
    required this.moneyAddresses,
  });
}

class DapResolutionException implements Exception {
  final String message;

  DapResolutionException(this.message);

  @override
  String toString() {
    return "DapResolutionException: $message";
  }
}

/// Response from dereferencing a DAP handle from a DAP registry.
/// More info [here](https://github.com/TBD54566975/dap?tab=readme-ov-file#dap-resolution)
class DereferencedHandle {
  final Did did;
  final RegistrationRequest proof;

  DereferencedHandle({required this.did, required this.proof});

  // Factory constructor to create an instance from a JSON string
  factory DereferencedHandle.fromJson(String source) =>
      DereferencedHandle.fromMap(jsonDecode(source));

  // Factory constructor to create an instance from a map
  factory DereferencedHandle.fromMap(Map<String, dynamic> map) {
    return DereferencedHandle(
      did: Did.parse(map['did']),
      proof: RegistrationRequest.fromMap(map['proof']),
    );
  }

  // Converts the instance into a map
  Map<String, dynamic> toMap() {
    return {
      'did': did.uri,
      'proof': proof.toMap(),
    };
  }

  // Converts the instance to a JSON string
  String toJson() => jsonEncode(toMap());
}
