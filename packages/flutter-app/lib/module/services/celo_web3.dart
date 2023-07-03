// import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

final Web3Client client =
    Web3Client('https://alfajores-forno.celo-testnet.org', Client());

// Replace these with your actual contract ABI
// String? contractKey = dotenv.get('CONTRACT_ADDRESS');

String? privateKey = dotenv.env['PRIVATE_KEY'];
final String? contractAddress = dotenv.env['CONTRACT_ADDRESS'];

// replace with your actual contract address

class CeloWeb3Helper {
  /// Get deployed greeter contract
  Future<DeployedContract> get deployedCeloContract async {
    const String abiDirectory = 'lib/module/services/did.abi.json';
    String contractABI = await rootBundle.loadString(abiDirectory);

    final DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(contractABI, 'Chat'),
      EthereumAddress.fromHex(contractAddress!),
    );

    return contract;
  }

  final EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey ?? '');

  Future<dynamic> sendChat(String sender, String content) async {
    print(content);
    final DeployedContract contract = await deployedCeloContract;
    final ContractFunction sendMessageFunction =
        contract.function('sendMessage');
    final address = EthereumAddress.fromHex(sender);
    final response = await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: sendMessageFunction,
        parameters: <dynamic>[address, content],
      ),
      chainId: 44787,
    );

    final dynamic receipt = await awaitResponse(response);
    return receipt;
  }

  Future<dynamic> fetchMessage(String address) async {
    print('hereeeeee=====>>');
    final DeployedContract contract = await deployedCeloContract;
    final wallet = EthereumAddress.fromHex(address);
    final fetchMessagesFunction = contract.function('getMessages');
    final response = await client.call(
      contract: contract,
      function: fetchMessagesFunction,
      params: <dynamic>[wallet],
    );
    print('response ====>>>> $response');
    return response[0];
  }

  Future<dynamic> fetchMessages() async {
    final DeployedContract contract = await deployedCeloContract;
    final fetchMessagesFunction = contract.function('getAllMessages');
    final response = await client.call(
      contract: contract,
      function: fetchMessagesFunction,
      params: <dynamic>[],
    );
    print('response ====>>>> $response');
    return response[0];
  }

  Future<dynamic> awaitResponse(dynamic response) async {
    int count = 0;
    while (true) {
      final TransactionReceipt? receipt =
          await client.getTransactionReceipt(response);
      if (receipt != null) {
        print('receipt ===>> $receipt');
        return receipt.logs;
      }
      // Wait for a while before polling again
      await Future<dynamic>.delayed(const Duration(seconds: 1));

      if (count == 6) {
        return null;
      } else {
        count++;
      }
    }
  }
}
