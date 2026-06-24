class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() => '$prefix$message';
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
    : super(message ?? 'Data fetch nahi ho raha hai', 'FetchData: ');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message ?? 'Request sahi nahi hai', 'BadRequest: ');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message ?? 'Aapko login karna padega', 'Unauthorized: ');
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message]) : super(message ?? 'Yahan jane ki permission nahi hai', 'Forbidden: ');
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message ?? 'Humein yeh nahi mila', 'NotFound: ');
}

class ServerException extends AppException {
  ServerException([String? message]) : super(message ?? 'Server mein dikkat hai', 'ServerError: ');
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
    : super(message ?? 'Internet nahi chal raha hai', 'NoInternet: ');
}
