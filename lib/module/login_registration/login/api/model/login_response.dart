class LoginResponse {
  LoginResponse({
    this.jwt,
    this.timeout,
    this.userLoginInfo,
  });

  final String? jwt;
  final int? timeout;
  final UserLoginInfo? userLoginInfo;

  LoginResponse copyWith({
    String? jwt,
    int? timeout,
    UserLoginInfo? userLoginInfo,
  }) =>
      LoginResponse(
        jwt: jwt ?? this.jwt,
        timeout: timeout ?? this.timeout,
        userLoginInfo: userLoginInfo ?? this.userLoginInfo,
      );

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    jwt: json["jwt"],
    timeout: json["timeout"],
    userLoginInfo: UserLoginInfo.fromJson(json["userLoginInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "jwt": jwt,
    "timeout": timeout,
    "userLoginInfo": userLoginInfo!.toJson(),
  };
}

class UserLoginInfo {
  UserLoginInfo({
    this.userName,
    this.ekycComplete,
    this.userStatus,
  });

  final String? userName;
  final bool? ekycComplete;
  final String? userStatus;

  UserLoginInfo copyWith({
    String? userName,
    bool? ekycComplete,
    String? userStatus,
  }) =>
      UserLoginInfo(
        userName: userName ?? this.userName,
        ekycComplete: ekycComplete ?? this.ekycComplete,
        userStatus: userStatus ?? this.userStatus,
      );

  factory UserLoginInfo.fromJson(Map<String, dynamic> json) => UserLoginInfo(
    userName: json["userName"],
    ekycComplete: json["ekycComplete"],
    userStatus: json["userStatus"],
  );

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "ekycComplete": ekycComplete,
    "userStatus": userStatus,
  };
}
