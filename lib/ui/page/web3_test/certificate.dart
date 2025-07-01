
class Certificate {
  final int tokenId;
  final String name;
  final int readingScore;
  final int listeningScore;
  final int issueDate;
  final int expirationDate;
  final String nationalID;
  final String cidCertificate;
  final String owner;
  final bool isValid;

  Certificate({
    required this.tokenId,
    required this.name,
    required this.readingScore,
    required this.listeningScore,
    required this.issueDate,
    required this.expirationDate,
    required this.nationalID,
    required this.cidCertificate,
    required this.owner,
    required this.isValid,
  });

  // copy with
  Certificate copyWith({
    int? tokenId,
    String? name,
    int? readingScore,
    int? listeningScore,
    int? issueDate,
    int? expirationDate,
    String? nationalID,
    String? cidCertificate,
    String? owner,
    bool? isValid,
  }) {
    return Certificate(
      tokenId: tokenId ?? this.tokenId,
      name: name ?? this.name,
      readingScore: readingScore ?? this.readingScore,
      listeningScore: listeningScore ?? this.listeningScore,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
      nationalID: nationalID ?? this.nationalID,
      cidCertificate: cidCertificate ?? this.cidCertificate,
      owner: owner ?? this.owner,
      isValid: isValid ?? this.isValid,
    );
  }
  
}