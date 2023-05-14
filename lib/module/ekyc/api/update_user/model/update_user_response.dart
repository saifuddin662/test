import 'dart:convert';

UpdateUserResponse updateUserResponseFromJson(String str) => UpdateUserResponse.fromJson(json.decode(str));

String updateUserResponseToJson(UpdateUserResponse data) => json.encode(data.toJson());

class UpdateUserResponse {
  UpdateUserResponse({
    this.message,
  });

  String? message;

  UpdateUserResponse copyWith({
    String? message,
  }) =>
      UpdateUserResponse(
        message: message ?? this.message,
      );

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) => UpdateUserResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
