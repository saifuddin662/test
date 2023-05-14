import 'dart:convert';

GetAllRequestsResponse getAllRequestsResponseFromJson(String str) => GetAllRequestsResponse.fromJson(json.decode(str));

String getAllRequestsResponseToJson(GetAllRequestsResponse data) => json.encode(data.toJson());

class GetAllRequestsResponse {
  GetAllRequestsResponse({
    this.outgoingRequest,
    this.incomingRequest,
  });

  List<IngRequest>? outgoingRequest;
  List<IngRequest>? incomingRequest;

  GetAllRequestsResponse copyWith({
    List<IngRequest>? outgoingRequest,
    List<IngRequest>? incomingRequest,
  }) =>
      GetAllRequestsResponse(
        outgoingRequest: outgoingRequest ?? this.outgoingRequest,
        incomingRequest: incomingRequest ?? this.incomingRequest,
      );

  factory GetAllRequestsResponse.fromJson(Map<String, dynamic> json) => GetAllRequestsResponse(
    outgoingRequest: json["outgoingRequest"] == null ? [] : List<IngRequest>.from(json["outgoingRequest"]!.map((x) => IngRequest.fromJson(x))),
    incomingRequest: json["incomingRequest"] == null ? [] : List<IngRequest>.from(json["incomingRequest"]!.map((x) => IngRequest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "outgoingRequest": outgoingRequest == null ? [] : List<dynamic>.from(outgoingRequest!.map((x) => x.toJson())),
    "incomingRequest": incomingRequest == null ? [] : List<dynamic>.from(incomingRequest!.map((x) => x.toJson())),
  };
}

class IngRequest {
  IngRequest({
    this.transactionStatus,
    this.requestId,
    this.requesterName,
    this.requestTo,
    this.receiverName,
    this.requestDateTime,
    this.requestedAmount,
    this.requestFrom,
  });

  String? transactionStatus;
  String? requestId;
  dynamic requesterName;
  String? requestTo;
  dynamic receiverName;
  String? requestDateTime;
  int? requestedAmount;
  String? requestFrom;

  IngRequest copyWith({
    String? transactionStatus,
    String? requestId,
    dynamic requesterName,
    String? requestTo,
    dynamic receiverName,
    String? requestDateTime,
    int? requestedAmount,
    String? requestFrom,
  }) =>
      IngRequest(
        transactionStatus: transactionStatus ?? this.transactionStatus,
        requestId: requestId ?? this.requestId,
        requesterName: requesterName ?? this.requesterName,
        requestTo: requestTo ?? this.requestTo,
        receiverName: receiverName ?? this.receiverName,
        requestDateTime: requestDateTime ?? this.requestDateTime,
        requestedAmount: requestedAmount ?? this.requestedAmount,
        requestFrom: requestFrom ?? this.requestFrom,
      );

  factory IngRequest.fromJson(Map<String, dynamic> json) => IngRequest(
    transactionStatus: json["transactionStatus"],
    requestId: json["requestId"],
    requesterName: json["requesterName"],
    requestTo: json["requestTo"],
    receiverName: json["receiverName"],
    requestDateTime: json["requestDateTime"],
    requestedAmount: json["requestedAmount"],
    requestFrom: json["requestFrom"],
  );

  Map<String, dynamic> toJson() => {
    "transactionStatus": transactionStatus,
    "requestId": requestId,
    "requesterName": requesterName,
    "requestTo": requestTo,
    "receiverName": receiverName,
    "requestDateTime": requestDateTime,
    "requestedAmount": requestedAmount,
    "requestFrom": requestFrom,
  };
}
