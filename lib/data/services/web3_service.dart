import 'package:toeic_desktop/data/models/ui_models/certificate.dart';
import 'package:toeic_desktop/ui/page/certificates/contract_abi.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class Web3Service {
  late Web3Client client;
  late DeployedContract contract;
  late ContractFunction getAllTokensFunction;
  late ContractFunction getCertificateDetailsFunction;
  late ContractFunction isCertificateValidFunction;

  Web3Service() {
    init();
  }

  Future<void> init() async {
    client = Web3Client(Web3Constants.rpcUrl, http.Client());
    final contractAddr = EthereumAddress.fromHex(Web3Constants.contractAddress);

    contract = DeployedContract(
      ContractAbi.fromJson(Web3Constants.abi, "Certificate"),
      contractAddr,
    );

    getAllTokensFunction = contract.function("getAllTokens");
    getCertificateDetailsFunction = contract.function("getCertificateDetails");
    isCertificateValidFunction = contract.function("isCertificateValid");
  }

  Future<List<Certificate>> getCertificatesByNationalId({
    required String nationalId,
  }) async {
    try {
      final tokenIdsResult = await client.call(
        contract: contract,
        function: getAllTokensFunction,
        params: [],
      );
      final List<BigInt> tokenIds = List<BigInt>.from(tokenIdsResult.first);
      final List<Certificate> loadedCertificates = [];

      for (final tokenId in tokenIds) {
        final isValid = await isCertificateValid(tokenId);
        final certificate = await getCertificateDetails(
          nationalId: tokenId,
          isValid: isValid,
        );
        if (certificate.nationalId == nationalId) {
          loadedCertificates.add(certificate);
        } else {
          continue;
        }
      }
      return loadedCertificates;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<Certificate> getCertificateDetails({
    required BigInt nationalId,
    required bool isValid,
  }) async {
    try {
      final result = await client.call(
        contract: contract,
        function: getCertificateDetailsFunction,
        params: [nationalId],
      );
      return Certificate(
        tokenId: nationalId.toInt(),
        name: result[0].toString(),
        readingScore: (result[1] as BigInt).toInt(),
        listeningScore: (result[2] as BigInt).toInt(),
        issueDate: DateTime.fromMillisecondsSinceEpoch(
          (result[3] as BigInt).toInt() * 1000,
        ),
        expirationDate: DateTime.fromMillisecondsSinceEpoch(
          (result[4] as BigInt).toInt() * 1000,
        ),
        nationalId: result[5].toString(),
        cidCertificate: result[6].toString(),
        isValid: isValid,
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> isCertificateValid(dynamic tokenId) async {
    try {
      final result = await client.call(
        contract: contract,
        function: isCertificateValidFunction,
        params: [tokenId],
      );
      return result.first as bool;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
