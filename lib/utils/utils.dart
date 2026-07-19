import 'package:connectivity_plus/connectivity_plus.dart';

import '../features/common/remote/api_exceptions.dart';
import '../l10n/app_locale_holder.dart';

class Utils {
  Utils._();

  static Future<bool> haveConnection() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return !connectivityResults.contains(ConnectivityResult.none);
  }

  static String getErrorMessage(Object? error) {
    if (error is TimeoutException) return error.message;
    if (error is NoInternetException) return error.message;
    if (error is RequestCancelledException) return error.message;
    if (error is BadRequestException) return error.message;
    if (error is UnauthorizedException) return error.message;
    if (error is ForbiddenException) return error.message;
    if (error is NotFoundException) return error.message;
    if (error is ServerException) return error.message;
    if (error is UnknownException) return error.message;
    return AppLocaleHolder.l10n.unexpectedErrorOccurred;
  }

  static DateTime today() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }
}
