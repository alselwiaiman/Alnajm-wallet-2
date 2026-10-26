/// Base class for all failure representations in the Clean Architecture
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network connection failed']) : super(message);
}

class InsufficientBalanceFailure extends Failure {
  const InsufficientBalanceFailure([String message = 'Insufficient wallet balance']) : super(message);
}

class InvalidAmountFailure extends Failure {
  const InvalidAmountFailure([String message = 'Invalid transaction amount']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed']) : super(message);
}
