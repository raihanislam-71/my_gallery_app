import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/network_response.dart';
import '../services/auth_controller.dart';

class NetworkCaller {
  final Logger logger;
  final AuthController authController;

  NetworkCaller({
    Logger? logger,
    AuthController? authController,
  })  : logger = logger ?? Logger(),
        authController = authController ?? AuthController();

  Future<NetworkResponse> getRequest({
    required String url,
    String? token,
  }) async {
    try {
      final String authToken = await _resolveAuthToken(token);
      final Uri uri = Uri.parse(url);
      _requestLog(url, {}, {});
      final http.Response response = await http.get(
        uri,
        headers: {
          'token': authToken,
          'Authorization': authToken,
        },
      );
      if (response.statusCode == 200) {
        _responseLog(url, response.statusCode, response.body, response.headers, true);
        final decodedBody = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedBody,
        );
      } else {
        _responseLog(url, response.statusCode, response.body, response.headers, false);
        if (response.statusCode == 401) {
          await authController.clearAccessToken();
        }
        dynamic decodedBody;
        try {
          decodedBody = jsonDecode(response.body);
        } catch (_) {}
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedBody,
          errorMessage: decodedBody is Map<String, dynamic>
              ? (decodedBody['message'] ?? decodedBody['msg'])?.toString()
              : null,
        );
      }
    } catch (e) {
      _responseLog(url, -1, null, {}, false, e);
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final String authToken = await _resolveAuthToken(token);
      final Uri uri = Uri.parse(url);
      _requestLog(url, {}, body ?? {});
      final http.Response response = await http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          'token': authToken,
          'Authorization': authToken,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _responseLog(url, response.statusCode, response.body, response.headers, true);
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        _responseLog(url, response.statusCode, response.body, response.headers, false);
        if (response.statusCode == 401) {
          await authController.clearAccessToken();
        }
        dynamic decodedBody;
        try {
          decodedBody = jsonDecode(response.body);
        } catch (_) {}
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedBody,
          errorMessage: decodedBody is Map<String, dynamic>
              ? (decodedBody['message'] ?? decodedBody['msg'])?.toString()
              : null,
        );
      }
    } catch (e) {
      _responseLog(url, -1, null, {}, false, e);
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> deleteRequest({
    required String url,
    String? token,
  }) async {
    try {
      final String authToken = await _resolveAuthToken(token);
      final Uri uri = Uri.parse(url);
      _requestLog(url, {}, {});
      final http.Response response = await http.delete(
        uri,
        headers: {
          'token': authToken,
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        _responseLog(url, response.statusCode, response.body, response.headers, true);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: jsonDecode(response.body),
        );
      }

      _responseLog(url, response.statusCode, response.body, response.headers, false);
      if (response.statusCode == 401) {
        await authController.clearAccessToken();
      }
      dynamic decodedBody;
      try {
        decodedBody = jsonDecode(response.body);
      } catch (_) {}
      return NetworkResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedBody,
        errorMessage: decodedBody is Map<String, dynamic>
            ? (decodedBody['message'] ?? decodedBody['msg'])?.toString()
            : null,
      );
    } catch (e) {
      _responseLog(url, -1, null, {}, false, e);
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> putRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final String authToken = await _resolveAuthToken(token);
      final Uri uri = Uri.parse(url);
      _requestLog(url, {}, body ?? {});
      final http.Response response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {
          'token': authToken,
          'Authorization': authToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _responseLog(url, response.statusCode, response.body, response.headers, true);
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        _responseLog(url, response.statusCode, response.body, response.headers, false);
        if (response.statusCode == 401) {
          await authController.clearAccessToken();
        }
        dynamic decodedBody;
        try {
          decodedBody = jsonDecode(response.body);
        } catch (_) {}
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedBody,
          errorMessage: decodedBody is Map<String, dynamic>
              ? (decodedBody['message'] ?? decodedBody['msg'])?.toString()
              : null,
        );
      }
    } catch (e) {
      _responseLog(url, -1, null, {}, false, e);
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<NetworkResponse> patchRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final String authToken = await _resolveAuthToken(token);
      final Uri uri = Uri.parse(url);
      _requestLog(url, {}, body ?? {});
      final http.Response response = await http.patch(
        uri,
        body: jsonEncode(body),
        headers: {
          'token': authToken,
          'Authorization': authToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _responseLog(url, response.statusCode, response.body, response.headers, true);
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        _responseLog(url, response.statusCode, response.body, response.headers, false);
        if (response.statusCode == 401) {
          await authController.clearAccessToken();
        }
        dynamic decodedBody;
        try {
          decodedBody = jsonDecode(response.body);
        } catch (_) {}
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedBody,
          errorMessage: decodedBody is Map<String, dynamic>
              ? (decodedBody['message'] ?? decodedBody['msg'])?.toString()
              : null,
        );
      }
    } catch (e) {
      _responseLog(url, -1, null, {}, false, e);
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  Future<String> _resolveAuthToken(String? token) async {
    final cachedToken = AuthController.accessToken;
    final storedToken = token ??
        (cachedToken != null && cachedToken.isNotEmpty
            ? cachedToken
            : await authController.getAccessToken());
    final normalizedToken = (storedToken ?? '').trim();
    if (normalizedToken.toLowerCase().startsWith('bearer ')) {
      return normalizedToken.substring(7).trim();
    }
    return normalizedToken;
  }

  void _requestLog(
    String url,
    Map<String, dynamic> params,
    Map<String, dynamic> body,
  ) {
    logger.i('''
      Url : $url
      Params : $params
      Body : $body
      ''');
  }

  void _responseLog(
    String url,
    int statusCode,
    dynamic responseBody,
    Map<String, dynamic> headers,
    bool isSuccess, [
    dynamic error,
  ]) {
    String message = '''
    Url : $url
    StatusCode : $statusCode
    ResponseBody : $responseBody
    Headers : $headers
    Error : $error
    ''';

    if (isSuccess) {
      logger.i(message);
    } else {
      logger.e(message);
    }
  }
}
