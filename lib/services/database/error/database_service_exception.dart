part of services.database;

class DatabaseServiceException implements Exception {
  final String message;

  DatabaseServiceException(this.message);
}
