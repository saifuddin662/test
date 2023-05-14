class TransactionFeeResponse {

  final double? chargeAmount;

  TransactionFeeResponse({
    this.chargeAmount
  });

  TransactionFeeResponse copyWith() =>
      TransactionFeeResponse(
        chargeAmount: chargeAmount ?? chargeAmount,
      );

  factory TransactionFeeResponse.fromJson(Map<String, dynamic> json) =>
      TransactionFeeResponse(
          chargeAmount: json["chargeAmount"]
      );
}
