import 'dart:convert';

CustomerRegByAgentRequest? customerRegByAgentRequest(String str) => CustomerRegByAgentRequest.fromJson(json.decode(str));

String customerRegByAgentRequestJson(CustomerRegByAgentRequest? data) => json.encode(data!.toJson());

class CustomerRegByAgentRequest {

  String name;
  String mobileNumber;
  String dob;
  String nid;

  CustomerRegByAgentRequest({
    required this.name,
    required this.mobileNumber,
    required this.dob,
    required this.nid
  });

  CustomerRegByAgentRequest copyWith({
    String? name,
    String? mobileNumber,
    String? dob,
    String? nid
  }) => CustomerRegByAgentRequest(
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      dob: dob ?? this.dob,
      nid: nid?? this.nid
  );

  factory CustomerRegByAgentRequest.fromJson(Map<String, dynamic> json) => CustomerRegByAgentRequest(
      name: json["name"],
      mobileNumber: json["mobileNumber"],
      dob: json["dob"],
      nid: json["nid"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mobileNumber": mobileNumber,
    "dob": dob,
    "nid" : nid
  };
}


