import 'package:flutter/material.dart';

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

  // copy with
  Certificate copyWith({
    int? tokenId,
    String? name,
    int? readingScore,
    int? listeningScore,
    DateTime? issueDate,
    DateTime? expirationDate,
    String? nationalId,
    String? cidCertificate,
    bool? isValid,
  }) {
    return Certificate(
      tokenId: tokenId ?? this.tokenId,
      name: name ?? this.name,
      readingScore: readingScore ?? this.readingScore,
      listeningScore: listeningScore ?? this.listeningScore,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
      nationalId: nationalId ?? this.nationalId,
      cidCertificate: cidCertificate ?? this.cidCertificate,
      isValid: isValid ?? this.isValid,
    );
  }
}
