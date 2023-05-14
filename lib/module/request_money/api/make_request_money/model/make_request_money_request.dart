class MakeRequestMoneyRequest {
  MakeRequestMoneyRequest({
    required this.requesterName,
    required this.requestTo,
    required this.receiverName,
    required this.requestedAmount,
    required this.pin
  });

  String requesterName;
  String requestTo;
  String receiverName;
  String requestedAmount;
  String pin;
}