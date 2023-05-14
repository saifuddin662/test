class TransactionFeeRequest {
  String? fromUserNumber;
  String? toUserNumber;
  String? transactionType;
  String? amount;

  TransactionFeeRequest(
    this.fromUserNumber,
    this.toUserNumber,
    this.transactionType,
    this.amount
  );
}
