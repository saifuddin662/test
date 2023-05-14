class RegisterRequest {
  String msisdn;
  String userType;

  RegisterRequest(this.msisdn, this.userType);

  Map<String, dynamic> toJson() {
    return {
      "msisdn": msisdn,
      "userType": userType,
    };
  }
}