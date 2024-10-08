import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:inventory_app/core/utils/utils.dart';

class RepositoryException implements Exception {
  const RepositoryException({
    required this.message,
    this.exception,
    this.stackTrace,
  });

  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return "RepositoryException: $message)";
  }
}

mixin RepositoryExceptionMixin {
  Future<T> exceptionHandler<T>(
    FutureOr computation, {
    String unknownMessage = 'Repository Exception',
    Function? onErrorCallback,
  }) async {
    try {
      return await computation;
    } on AppwriteException catch (e) {
      logger.warning(e.message, e);
      onErrorCallback?.call();
      throw RepositoryException(
          message: e.message ?? 'An undefined error occurred');
    } on Exception catch (e, st) {
      logger.severe(unknownMessage, e, st);
      onErrorCallback?.call();
      throw RepositoryException(
          message: unknownMessage, exception: e, stackTrace: st);
    }
  }

  T instantExceptionHandler<T>(
    T Function() computation, {
    String unknownMessage = 'Repository Exception',
    Function? onErrorCallback,
  }) {
    try {
      return computation.call();
    } on AppwriteException catch (e) {
      logger.warning(e.message, e);
      onErrorCallback?.call();
      throw RepositoryException(
          message: e.message ?? 'An undefined error occurred');
    } on Exception catch (e, st) {
      logger.severe(unknownMessage, e, st);
      onErrorCallback?.call();
      throw RepositoryException(
          message: unknownMessage, exception: e, stackTrace: st);
    }
  }
}
