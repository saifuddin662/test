class AgentCashOutDisInfoRequest {
  String walletNo;

  AgentCashOutDisInfoRequest(this.walletNo);

  Map<String, dynamic> toJson() {
    return {
      "walletNo": walletNo,
    };
  }
}