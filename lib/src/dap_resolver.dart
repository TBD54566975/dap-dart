import 'package:dap/dap.dart';
import 'package:http/http.dart' as http;
import 'package:web5/web5.dart';

class DapResolver {
  http.Client client;
  DidResolver didResolver;

  DapResolver(this.didResolver, {http.Client? client})
      : client = client ?? http.Client();

  Future<void> getMoneyAddresses(Dap dap) async {}

  /// can construct yourself for mocking purposes etc.
  /// getRegistryEndpoint() -> resolve registry did, find DAPRegistry service endpoint
  /// dereferenceHandle() -> makes GET request to registry endpoint to get DAP's DID
  /// resolveDid() -> resolve DAP's DID, get back did document
  /// getMoneyAddresses(dap) -> getRegistryEndpoint() -> dereferenceHandle() -> resolveDid() -> parse out money addresses from did document -> return list of money addrrsses
}
