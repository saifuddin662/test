class CheckUserResponse {

  final String? userType;
  final String? userName;

  CheckUserResponse({
    this.userType,
    this.userName,
  });

  CheckUserResponse copyWith() =>
      CheckUserResponse(
        userType: userType ?? userType,
        userName: userName ?? userName,
      );

  factory CheckUserResponse.fromJson(Map<String, dynamic> json) =>
      CheckUserResponse(
          userType: json["userType"],
          userName: json["userName"]
      );
}
