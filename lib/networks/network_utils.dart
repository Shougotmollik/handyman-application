import 'dart:convert';
import 'dart:io';

import 'package:handyman_admin_flutter/configs.dart';
import 'package:handyman_admin_flutter/main.dart';
import 'package:handyman_admin_flutter/networks/rest_apis.dart';
import 'package:handyman_admin_flutter/screens/auth/sign_in_screen.dart';
import 'package:handyman_admin_flutter/utils/constant.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../utils/model_keys.dart';

Map<String, String> buildHeaderTokens() {
  Map<String, String> header = {};

  if (appStore.isLoggedIn) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
  }
  header.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');
  header.putIfAbsent(HttpHeaders.cacheControlHeader, () => 'no-cache');
  header.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');
  header.putIfAbsent('Access-Control-Allow-Headers', () => '*');
  header.putIfAbsent('Access-Control-Allow-Origin', () => '*');

  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$BASE_URL$endPoint');

  log('URL: ${url.toString()}');

  return url;
}

Future<Response> buildHttpResponse(String endPoint, {HttpMethod method = HttpMethod.GET, Map? request}) async {
  var headers = buildHeaderTokens();
  Uri url = buildBaseUrl(endPoint);

  Response response;

  try {
    if (method == HttpMethod.POST) {
      log('Request: ${jsonEncode(request)}');

      response = await http.post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethod.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethod.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethod.POST || method == HttpMethod.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodType: method.name,
    );

    //log('Response (${method.name}) ${response.statusCode}: ${response.body}');

    if (appStore.isLoggedIn && response.statusCode == 401) {
      return await reGenerateToken().then((value) async {
        return await buildHttpResponse(endPoint, method: method, request: request);
      }).catchError((e) {
        throw errorSomethingWentWrong;
      });
    } else {
      return response;
    }
  } on Exception catch (e) {
    log(e);
    if (!await isNetworkAvailable()) {
      throw errorInternetNotAvailable;
    } else {
      throw errorSomethingWentWrong;
    }
  }
}

Future handleResponse(Response response, [bool? avoidTokenError]) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode == 401) {
    if (!avoidTokenError.validate()) LiveStream().emit(LIVESTREAM_TOKEN, true);

    await clearPreferences();
    push(SignInScreen(), isNewTask: true);

    throw '${locale.lblTokenExpired}';
  } else if (response.statusCode == 400) {
    throw '${locale.badRequest}';
  } else if (response.statusCode == 403) {
    throw '${locale.forbidden}';
  } else if (response.statusCode == 404) {
    throw '${locale.pageNotFound}';
  } else if (response.statusCode == 429) {
    throw '${locale.tooManyRequests}';
  } else if (response.statusCode == 500) {
    throw '${locale.internalServerError}';
  } else if (response.statusCode == 502) {
    throw '${locale.badGateway}';
  } else if (response.statusCode == 503) {
    throw '${locale.serviceUnavailable}';
  } else if (response.statusCode == 504) {
    throw '${locale.gatewayTimeout}';
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    if (response.body.isJson()) {
      Map body = jsonDecode(response.body);
      if (body.containsKey('message')) {
        throw body['message'];
      } else {
        throw errorSomethingWentWrong;
      }
    } else {
      throw errorSomethingWentWrong;
    }
    /*try {
      var body = jsonDecode(response.body);
      throw parseHtmlString(body['message']);
    } on Exception catch (e) {
      log(e);
      throw errorSomethingWentWrong;
    }*/
  }
}

Future<void> reGenerateToken() async {
  log('Regenerating Token');
  Map req = {
    UserKeys.email: appStore.userEmail,
    UserKeys.password: getStringAsync(USER_PASSWORD),
  };

  return await loginUser(req).then((value) async {
    await appStore.setToken(value.data!.apiToken.validate());
  }).catchError((e) {
    throw e;
  });
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  apiPrint(
    url: multiPartRequest.url.toString(),
    headers: jsonEncode(multiPartRequest.headers),
    request: jsonEncode(multiPartRequest.fields),
    hasRequest: true,
    statusCode: response.statusCode,
    responseBody: response.body,
    methodType: "MultiPart",
  );

  //log('response : ${response.body}');

  if (response.statusCode.isSuccessful()) {
    if (response.body.isJson()) {
      onSuccess?.call(response.body);
    } else {
      onSuccess?.call(response.body);
    }
  } else {
    onError?.call(errorSomethingWentWrong);
  }
}

//region Common
enum HttpMethod { GET, POST, DELETE, PUT }
//endregion

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodType = "",
  bool hasRequest = false,
}) {
  log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  log("\u001b[93m Url: \u001B[39m $url");
  log("\u001b[93m header: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) log("\u001b[93m Request: \u001B[39m \u001b[96m$request\u001B[39m");
  log("${statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m"}");
  log('Response ($methodType) $statusCode: $responseBody');
  log("\u001B[0m");
  log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}
