class AppException<E extends Exception> implements Exception {
  final String message;
  final String userError;
  final String details;
  final StackTrace stackTrace;
  final Object _orginalError;

  E get orginalError => _orginalError as E;

  const AppException(
    this.message, {
    this.details,
    this.stackTrace,
    this.userError = 'Unknow Error occured',
    Object orginalError,
  }) : _orginalError = orginalError;

  @override
  String toString() {
    return 'AppException(message: $message, userError: $userError, details: $details, stackTrace: $stackTrace, _orginalError: $_orginalError)';
  }
}
