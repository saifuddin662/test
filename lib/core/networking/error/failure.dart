/// All failures will be caugth by this [Failure] class for ease of appearance to the user
class Failure {
  Failure(
    this.message,
  );

  final String message;

  @override
  String toString() => 'Failure(message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
