import 'dart:io';

import 'package:dio/dio.dart';

// ---------------------------------------------------------------------------
// 1:1 port of Swift ShoppingListViewModel.isNetworkError(_:)
//
// Swift returns `true` only für echte Netzwerk-Probleme:
//   .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost,
//   .timedOut, .dnsLookupFailed, .cannotFindHost
// Server-Response-Probleme (z. B. badServerResponse, zeroByteResource) sind
// KEINE Offline-Fehler.
//
// In Flutter mappen wir das auf Dios `DioExceptionType` plus rohe
// SocketException (z. B. wenn Dio die Anfrage gar nicht erst aufbauen kann).
// HTTP-Statusfehler (`badResponse`, 4xx/5xx) sind explizit KEINE Offline-Fehler.
// ---------------------------------------------------------------------------

bool isNetworkError(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return true;
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return false;
      case DioExceptionType.unknown:
        // unknown kann von SocketException etc. kommen — drunter prüfen.
        final inner = error.error;
        if (inner is SocketException) return true;
        if (inner is HttpException) return true;
        return false;
    }
  }
  if (error is SocketException) return true;
  if (error is HttpException) return true;
  return false;
}
