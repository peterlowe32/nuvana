import 'dart:convert';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start BibleForUApi Group Code

class BibleForUApiGroup {
  static String getBaseUrl() => 'https://bible4u.net/api/v1/';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer REMOVED_OPENAI_KEY',
  };
  static ListOfVersionsCall listOfVersionsCall = ListOfVersionsCall();
  static ListOfBooksCall listOfBooksCall = ListOfBooksCall();
  static ListofChaptersCall listofChaptersCall = ListofChaptersCall();
  static ListOfVersesCall listOfVersesCall = ListOfVersesCall();
}

class ListOfVersionsCall {
  Future<ApiCallResponse> call({
    String? versionsShortName = '',
  }) async {
    final baseUrl = BibleForUApiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'ListOfVersions',
      apiUrl: '${baseUrl}bibles/${versionsShortName}',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer REMOVED_OPENAI_KEY',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListOfBooksCall {
  Future<ApiCallResponse> call({
    String? versionsShortName = '',
  }) async {
    final baseUrl = BibleForUApiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'ListOfBooks',
      apiUrl: '${baseUrl}bibles/${versionsShortName}',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer REMOVED_OPENAI_KEY',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListofChaptersCall {
  Future<ApiCallResponse> call({
    String? versionsShortName = '',
    String? booksShortName = '',
  }) async {
    final baseUrl = BibleForUApiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'ListofChapters',
      apiUrl: '${baseUrl}bibles/${versionsShortName}/books/${booksShortName}',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer REMOVED_OPENAI_KEY',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListOfVersesCall {
  Future<ApiCallResponse> call({
    String? versionShortName = '',
    String? booksShortName = '',
    String? chaptersNum = '',
  }) async {
    final baseUrl = BibleForUApiGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'ListOfVerses',
      apiUrl:
          '${baseUrl}bibles/${versionShortName}/books/${booksShortName}/chapters/${chaptersNum}',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer REMOVED_OPENAI_KEY',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End BibleForUApi Group Code

/// Start getVerseoftheDay Group Code

class GetVerseoftheDayGroup {
  static String getBaseUrl() => 'https://bible-api.com/';
  static Map<String, String> headers = {};
  static GetVerseoftheDayCall getVerseoftheDayCall = GetVerseoftheDayCall();
}

class GetVerseoftheDayCall {
  Future<ApiCallResponse> call() async {
    final baseUrl = GetVerseoftheDayGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'getVerseoftheDay',
      apiUrl: '${baseUrl}john+3:16',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? ref(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.reference''',
      ));
  String? txt(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.text''',
      ));
}

/// End getVerseoftheDay Group Code

class VerseoftheDayCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'VerseoftheDay',
      apiUrl: 'https://beta.ourmanna.com/api/v1/get/?format=json&order=daily',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? verseText(dynamic response) => (getJsonField(
        response,
        r'''$["verse"]["details"]["text"]''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? verseRef(dynamic response) => (getJsonField(
        response,
        r'''$["verse"]["details"]["reference"]''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ReflectivePromptCall {
  static Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "system",
      "content": "You are a Christian spiritual guide. Given a Bible verse, write a short reflective devotional question to help users think deeply about their spiritual life."
    },
    {
      "role": "user",
      "content": "Verse: {{verseText}} — Reference: {{verseRef}}"
    }
  ]
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ReflectivePrompt',
      apiUrl: 'https://api.openai.com/v1/chat/completions',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer REMOVED_OPENAI_KEY',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? reflectivePrompt(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.choices[0].message.content''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
