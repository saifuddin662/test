enum NetworkStatus {
  success('200'),
  error('400'),
  loading('412'),
  noInternet('411'),
  sessionTimeout('401'),
  clearWallet('406'),
  otpExpired('410'),
  clearAndGotoStart('409'),
  nidAlreadyExist('111'),
  networkError('420'),
  warning('300'),
  incorrectPin('103');

  final String value;
  const NetworkStatus(this.value);

  int get cod => int.parse(value);

  factory NetworkStatus.toCode(int code) {
    for (var value in NetworkStatus.values) {
      if (value.cod == code) return value;
    }
    throw 'Unknown Status Code --> $code';
  }
}

enum HttpsStatus {
  success(200),
  error(400),
  sessionTimeout(401),
  networkError(420);

  final int code;
  const HttpsStatus(this.code);
}