class AgentLocatorInResponse {

  List<AgentLocatorItems>? locatorItems;

  AgentLocatorInResponse({
    this.locatorItems,
  });


  AgentLocatorInResponse.fromJson(dynamic json) {
    locatorItems = <AgentLocatorItems>[];
    if(json != null) {
      json.forEach((v) {
        locatorItems!.add(AgentLocatorItems.fromJson(v));
      });
    }
  }
}

class AgentLocatorItems {
  AgentLocatorItems({
    this.agentName,
    this.agentWalletNo,
    this.latitude,
    this.longitude,
    this.distance,
  });

  String? agentName;
  String? agentWalletNo;
  dynamic latitude;
  dynamic longitude;
  dynamic distance;

  factory AgentLocatorItems.fromJson(Map<String, dynamic> json) => AgentLocatorItems(
    agentName: json["agentName"],
    agentWalletNo: json["agentWalletNo"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    distance: json["distance"],
  );
}