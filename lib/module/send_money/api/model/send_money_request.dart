class SendMoneyRequest {
  SendMoneyRequest({
    required this.recipientNumber,
    required this.amount,
    required this.pin,
  });

  String recipientNumber;
  String amount;
  String pin;
}
