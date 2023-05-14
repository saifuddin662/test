/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 15,January,2023.

enum Status { SUCCESS, ERROR }

class BaseResult<T> {
  BaseResult(
      {this.statusCode,
      required this.status,
      required this.data,
      required this.message,
      required this.code});

  late final int? statusCode;
  late final Status status;
  final T? data;
  late final String message;
  late final dynamic code;

  static BaseResult<T> success<T>(T? data) {
    return BaseResult(status: Status.SUCCESS, data: data, message: '', code: 0);
  }

  static BaseResult<T> error<T>(dynamic code, String message) {
    return BaseResult(
      status: Status.ERROR,
      data: null,
      code: code,
      message: message,
    );
  }
}
