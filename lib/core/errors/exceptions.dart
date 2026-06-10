/// Custom exceptions for the Task Manager application
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when data is not found
class NotFoundException extends AppException {
  NotFoundException(super.message);
}

/// Exception thrown for invalid input
class ValidationException extends AppException {
  ValidationException(super.message);
}

/// Exception thrown when database operation fails
class DatabaseException extends AppException {
  DatabaseException(super.message);
}

/// Exception thrown for unexpected errors
class UnexpectedException extends AppException {
  UnexpectedException(super.message);
}
