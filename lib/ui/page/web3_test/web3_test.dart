import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/page/web3_test/contract_abi.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class Web3TestPage extends StatefulWidget {
  const Web3TestPage({super.key});

  @override
  State<Web3TestPage> createState() => _Web3TestPageState();
}

class _Web3TestPageState extends State<Web3TestPage> {
  late Web3Client _client;
  late EthereumAddress contractAddr;
  late DeployedContract contract;
  late ContractFunction getValueFunction;
  late EthPrivateKey credentials;
  String value = "";

  @override
  void initState() {
    super.initState();
    _initiateSetup();
  }

  Future<void> _initiateSetup() async {
    _client = Web3Client(Web3Constants.rpcUrl, http.Client());
    contractAddr = EthereumAddress.fromHex(Web3Constants.contractAddress);
    credentials = EthPrivateKey.fromHex(Web3Constants.privateKey);

    contract = DeployedContract(
      ContractAbi.fromJson(Web3Constants.abi, "Certificate"),
      contractAddr,
    );

    getValueFunction = contract.function("getCertificateDetails");

    await _getValueFromContract();
  }

  Future<void> _getValueFromContract() async {
    final result = await _client.call(
      contract: contract,
      function: getValueFunction,
      params: [BigInt.from(32)],
    );

    setState(() {
      value = result.first.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Web3 Example")),
      body: Center(
        child: Text("Contract Value: $value"),
      ),
    );
  }
}
