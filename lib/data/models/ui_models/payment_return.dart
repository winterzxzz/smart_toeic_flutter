class PaymentReturn {
  final String amount;
  final String appid;
  final String apptransid;
  final String bankcode;
  final String checksum;
  final String discountamount;
  final String pmcid;
  final String status;

  PaymentReturn({
    required this.amount,
    required this.appid,
    required this.apptransid,
    required this.bankcode,
    required this.checksum,
    required this.discountamount,
    required this.pmcid,
    required this.status,
  });
}
