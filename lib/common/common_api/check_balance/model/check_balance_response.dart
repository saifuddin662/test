class CheckBalanceResponse {
  CheckBalanceResponse({
    this.availableBalance,
    this.balance,
    this.status,
  });

  double? availableBalance;
  double? balance;
  String? status;

  factory CheckBalanceResponse.fromJson(Map<String, dynamic> json) => CheckBalanceResponse(
    availableBalance: json["availableBalance"],
    balance: json["balance"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "availableBalance": availableBalance,
    "balance": balance,
    "status": status,
  };
}
