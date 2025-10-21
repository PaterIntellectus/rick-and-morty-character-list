import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty_character_list/shared/data/api/dto.dart';

class RickAndMortyRestApiPaginationInfo {
  const RickAndMortyRestApiPaginationInfo({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  final int count;
  final int pages;
  final Uri? next;
  final Uri? prev;

  factory RickAndMortyRestApiPaginationInfo.fromJson(
    Map<String, dynamic> json,
  ) => RickAndMortyRestApiPaginationInfo(
    count: json['count'],
    pages: json['pages'],
    next: json['next'] == null ? null : Uri.tryParse(json['next']),
    prev: json['prev'] == null ? null : Uri.tryParse(json['prev']),
  );
}

class RickAndMortyRestApiPaginatedResponse<T> {
  const RickAndMortyRestApiPaginatedResponse({
    required this.info,
    required this.results,
  });

  factory RickAndMortyRestApiPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(List? json) dataParser,
  ) => RickAndMortyRestApiPaginatedResponse(
    info: RickAndMortyRestApiPaginationInfo.fromJson(json['info']),
    results: dataParser(json['results']),
  );

  final RickAndMortyRestApiPaginationInfo info;
  final T results;
}

// abstract class RickAndMortyEndpoint<T> {
//   const RickAndMortyEndpoint(this.path);

//   final String path;

//   List<T> getAll();
//   T getSingle();
//   List<T> getMultiple();
// }

abstract final class RickAndMortyRestApiClient {
  static const baseUrl = 'https://rickandmortyapi.com/api';
  static final _baseUrl = Uri.parse(baseUrl);
  static final charactersEndpoint = '/character';
  static final _httpClient = http.Client();

  // RickAndMortyRestApiClient() {
  //   final response = _httpClient.get(_baseUrl);

  //   _decodeResponseData(response.)
  // }

  static Uri _resolveEndpoint(String endpoint, {required int page}) {
    return _baseUrl.replace(
      pathSegments: [..._baseUrl.pathSegments, endpoint],
      queryParameters: {..._baseUrl.queryParameters, 'page': page.toString()},
    );
  }

  // бросает Exception в зависимости от ответа сервера
  // * по крайней мере мы представим что он так делает ;) *
  static void _handleErrorResponse(http.Response response) {
    if (200 > response.statusCode || response.statusCode > 299) {
      throw Exception('Неизвестная ошибка Рик и Морти API сервиса');
    }
  }

  static Future<RickAndMortyRestApiPaginatedResponse<List<CharacterDto>>>
  allCharactets({int page = 1}) async {
    final e = _resolveEndpoint(charactersEndpoint, page: page);

    final response = await _httpClient.get(e);

    _handleErrorResponse(response);

    return RickAndMortyRestApiPaginatedResponse.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)),
      (list) => list!.map((e) => CharacterDto.fromJson(e)).toList(),
    );
  }

  void close() => _httpClient.close();
}
