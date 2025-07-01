import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/capitalize_first_letter_input.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/web3_test/contract_abi.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

// Certificate model
class Certificate {
  final int tokenId;
  final String name;
  final int readingScore;
  final int listeningScore;
  final DateTime issueDate;
  final DateTime expirationDate;
  final String nationalId;
  final String cidCertificate;
  final bool isValid;

  Certificate({
    required this.tokenId,
    required this.name,
    required this.readingScore,
    required this.listeningScore,
    required this.issueDate,
    required this.expirationDate,
    required this.nationalId,
    required this.cidCertificate,
    required this.isValid,
  });

  int get totalScore => readingScore + listeningScore;

  String get scoreLevel {
    if (totalScore >= 900) return 'Gold';
    if (totalScore >= 700) return 'Blue';
    if (totalScore >= 500) return 'Green';
    if (totalScore >= 220) return 'Brown';
    return 'Orange';
  }

  Color get levelColor {
    switch (scoreLevel) {
      case 'Gold':
        return Colors.amber;
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Brown':
        return Colors.brown;
      default:
        return Colors.orange;
    }
  }
}

class Web3TestPage extends StatefulWidget {
  const Web3TestPage({super.key});

  @override
  State<Web3TestPage> createState() => _Web3TestPageState();
}

class _Web3TestPageState extends State<Web3TestPage> {
  late Web3Client _client;
  late EthereumAddress contractAddr;
  late DeployedContract contract;
  late ContractFunction getAllTokensFunction;
  late ContractFunction getCertificateDetailsFunction;
  late ContractFunction isCertificateValidFunction;
  late EthPrivateKey credentials;

  List<Certificate> certificates = [];
  List<Certificate> filteredCertificates = [];
  bool isLoading = true;
  String searchQuery = '';
  Timer? _timer;

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

    getAllTokensFunction = contract.function("getAllTokens");
    getCertificateDetailsFunction = contract.function("getCertificateDetails");
    isCertificateValidFunction = contract.function("isCertificateValid");

    await _loadAllCertificates();
  }

  Future<void> _loadAllCertificates() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Get all token IDs
      final tokenIdsResult = await _client.call(
        contract: contract,
        function: getAllTokensFunction,
        params: [],
      );

      final List<BigInt> tokenIds = List<BigInt>.from(tokenIdsResult.first);
      final List<Certificate> loadedCertificates = [];

      // Load details for each certificate
      for (final tokenId in tokenIds) {
        try {
          final detailsResult = await _client.call(
            contract: contract,
            function: getCertificateDetailsFunction,
            params: [tokenId],
          );

          final validResult = await _client.call(
            contract: contract,
            function: isCertificateValidFunction,
            params: [tokenId],
          );

          final certificate = Certificate(
            tokenId: tokenId.toInt(),
            name: detailsResult[0].toString(),
            readingScore: (detailsResult[1] as BigInt).toInt(),
            listeningScore: (detailsResult[2] as BigInt).toInt(),
            issueDate: DateTime.fromMillisecondsSinceEpoch(
              (detailsResult[3] as BigInt).toInt() * 1000,
            ),
            expirationDate: DateTime.fromMillisecondsSinceEpoch(
              (detailsResult[4] as BigInt).toInt() * 1000,
            ),
            nationalId: detailsResult[5].toString(),
            cidCertificate: detailsResult[6].toString(),
            isValid: validResult.first as bool,
          );

          loadedCertificates.add(certificate);
        } catch (e) {
          debugPrint('Error loading certificate ${tokenId.toString()}: $e');
        }
      }

      setState(() {
        certificates = loadedCertificates;
        filteredCertificates = loadedCertificates;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading certificates: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterCertificates(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredCertificates = certificates;
      } else {
        filteredCertificates = certificates.where((certificate) {
          return certificate.nationalId
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              certificate.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBackButton(),
        title: const Text("Certificates"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: TextField(
                inputFormatters: [CapitalizeFirstLetterFormatter()],
                onChanged: (value) {
                  _timer?.cancel();
                  _timer = Timer(const Duration(milliseconds: 500), () {
                    _filterCertificates(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search certificates by Nation ID Card or Name',
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                  ),
                  filled: true,
                  isDense: true,
                  fillColor: theme.cardColor,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.gray1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            const SliverToBoxAdapter(
              child: LoadingCircle(),
            )
          else if (filteredCertificates.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: 64,
                        color: theme.hintColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        searchQuery.isEmpty
                            ? 'No certificates found'
                            : 'No certificates match your search',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final certificate = filteredCertificates[index];
                  return _buildCertificateCard(certificate, theme);
                },
                childCount: filteredCertificates.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(Certificate certificate, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: certificate.isValid
              ? AppColors.gray1
              : theme.colorScheme.error.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: certificate.levelColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: certificate.levelColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    certificate.scoreLevel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: certificate.levelColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (!certificate.isValid)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Expired',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  'ID: ${certificate.tokenId}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              certificate.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'National ID: ${certificate.nationalId}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildScoreItem(
                    'Reading',
                    certificate.readingScore,
                    Icons.book_outlined,
                    theme,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildScoreItem(
                    'Listening',
                    certificate.listeningScore,
                    Icons.headphones_outlined,
                    theme,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildScoreItem(
                    'Total',
                    certificate.totalScore,
                    Icons.analytics_outlined,
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 16,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Issued: ${_formatDate(certificate.issueDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'Expires: ${_formatDate(certificate.expirationDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(
    String label,
    int score,
    IconData icon,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
