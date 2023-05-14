import 'dart:convert';

DeviceValidateResponse deviceValidateResponseFromJson(String str) => DeviceValidateResponse.fromJson(json.decode(str));

String deviceValidateResponseToJson(DeviceValidateResponse data) => json.encode(data.toJson());

class DeviceValidateResponse {
  DeviceValidateResponse({
    this.jwt,
    this.timeout,
    this.userLoginInfo,
  });

  final String? jwt;
  final int? timeout;
  final UserLoginInfo? userLoginInfo;

  DeviceValidateResponse copyWith({
    required String jwt,
    required int timeout,
    required UserLoginInfo userLoginInfo,
  }) =>
      DeviceValidateResponse(
        jwt: jwt ?? this.jwt,
        timeout: timeout ?? this.timeout,
        userLoginInfo: userLoginInfo ?? this.userLoginInfo,
      );

  factory DeviceValidateResponse.fromJson(Map<String, dynamic> json) => DeviceValidateResponse(
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
    required this.userName,
    required this.ekycComplete,
    required this.userStatus,
  });

  final String userName;
  final bool ekycComplete;
  final String userStatus;

  UserLoginInfo copyWith({
    required String userName,
    required bool ekycComplete,
    required String userStatus,
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
