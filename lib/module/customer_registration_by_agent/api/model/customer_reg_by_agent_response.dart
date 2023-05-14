class CustomerRegByAgentResponse {

  final int? code;
  final String? message;
  final String? data;

  CustomerRegByAgentResponse ({
    this.code,
    this.message,
    this.data,
  });

  CustomerRegByAgentResponse  copyWith() =>
      CustomerRegByAgentResponse(
        code: code ?? code,
        message: message ?? message,
        data: data ?? data,
      );

  factory  CustomerRegByAgentResponse.fromJson(Map<String, dynamic> json) =>  CustomerRegByAgentResponse(
    code: json["code"],
    message: json["message"],
    data: json["data"],
  );
}
