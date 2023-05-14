class TopUpAgentListResponse {
  TopUpAgentListResponse({
    this.dsrWallet,
    this.agentListList,
  });

  final String? dsrWallet;
  final List<dynamic>? agentListList;

  TopUpAgentListResponse copyWith() =>
      TopUpAgentListResponse(
        dsrWallet: dsrWallet ?? dsrWallet,
        agentListList: agentListList ?? agentListList,
      );

  factory TopUpAgentListResponse.fromJson(Map<String, dynamic> json) => TopUpAgentListResponse(
    dsrWallet: json["dsrWallet"],
    agentListList: json["agentListList"],
  );
}
