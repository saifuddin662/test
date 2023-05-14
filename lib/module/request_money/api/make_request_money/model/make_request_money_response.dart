import 'dart:convert';

MakeRequestMoneyResponse makeRequestMoneyResponseFromJson(String str) => MakeRequestMoneyResponse.fromJson(json.decode(str));

String makeRequestMoneyResponseToJson(MakeRequestMoneyResponse data) => json.encode(data.toJson());

class MakeRequestMoneyResponse {
  MakeRequestMoneyResponse({
    this.requestId,
    this.message,
  });

  String? requestId;
  String? message;

  MakeRequestMoneyResponse copyWith({
    String? requestId,
    String? message,
  }) =>
      MakeRequestMoneyResponse(
        requestId: requestId ?? this.requestId,
        message: message ?? this.message,
      );

  factory MakeRequestMoneyResponse.fromJson(Map<String, dynamic> json) => MakeRequestMoneyResponse(
    requestId: json["requestId"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "requestId": requestId,
    "message": message,
  };
}
