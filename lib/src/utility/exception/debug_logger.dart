import 'dart:convert';
import 'dart:developer';

class DebugLogger {
  static void printJsonResponse({String url = 'N/A',  String tag = 'DebugLogger', required dynamic responseBody, required int statusCode}) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      String prettyJson;

      if (responseBody is List || responseBody is Map) {
        prettyJson = encoder.convert(responseBody);
      } else if (responseBody is String) {
        final decoded = jsonDecode(responseBody);
        prettyJson = encoder.convert(decoded);
      } else {
        prettyJson = 'Unsupported response body type: ${responseBody.runtimeType}';
      }
      log("----->[$tag] URL         ==> $url");
      log("----->[$tag] statusCode  ==> $statusCode");
      log("----->[$tag] body        ==> $prettyJson");
    } catch (e) {
      log("------->>[$tag] Failed to parse response body: $e");
    }
  }
}
