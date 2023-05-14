class PayRequestMoneyRequest {
  PayRequestMoneyRequest({
    required this.requestId,
    required this.transactionType,
    required this.pin,
  });

  String requestId;
  String transactionType;
  String pin;
}