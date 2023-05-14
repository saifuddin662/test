class UpdateAgentLocatorRequest {

  String agentName;
  String agentWalletNo;
  dynamic latitude;
  dynamic longitude;

  UpdateAgentLocatorRequest({
    required this.agentName,
    required this.agentWalletNo,
    required this.latitude,
    required this.longitude,
  });

  UpdateAgentLocatorRequest copyWith({
    String? agentName,
    String? agentWalletNo,
    dynamic latitude,
    dynamic longitude
  }) => UpdateAgentLocatorRequest(
    agentName: agentName ?? this.agentName,
    agentWalletNo: agentWalletNo ?? this.agentWalletNo,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
  );

  factory UpdateAgentLocatorRequest.fromJson(Map<String, dynamic> json) => UpdateAgentLocatorRequest(
    agentName: json["agentName"],
    agentWalletNo: json["agentWalletNo"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "agentName": agentName,
    "agentWalletNo": agentWalletNo,
    "latitude": latitude,
    "longitude": longitude,
  };
}


