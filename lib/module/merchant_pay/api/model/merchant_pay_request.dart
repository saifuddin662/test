class MerchantPayRequest {

  String recipientNumber;
  String amount;
  String? txnType;
  String pin;

  MerchantPayRequest({
    required this.recipientNumber,
    required this.amount,
    this.txnType,
    required this.pin,
  });

}
