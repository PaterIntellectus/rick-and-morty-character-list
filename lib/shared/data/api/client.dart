import 'dart:convert';

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

final class RickAndMortyRestApiClient {
  static const baseUrl = 'https://rickandmortyapi.com/api';
  static final _baseUrl = Uri.parse(baseUrl);
  static final characterEndpoint = '/character';
  final _httpClient = http.Client();

  // бросает Exception в зависимости от ответа сервера
  // * по крайней мере мы представим что он так делает ;) *
  void _handleErrorResponse(http.Response response) {
    if (response.statusCode < 200 || 299 < response.statusCode) {
      throw Exception('Неизвестная ошибка Рик и Морти API сервиса');
    }
  }

  Future<RickAndMortyRestApiPaginatedResponse<List<CharacterDto>>>
  allCharacters({int page = 1}) async {
    final url = _baseUrl.replace(
      pathSegments: [..._baseUrl.pathSegments, characterEndpoint],
      queryParameters: {..._baseUrl.queryParameters, 'page': page.toString()},
    );

    final response = await _httpClient.get(url);

    _handleErrorResponse(response);

    return RickAndMortyRestApiPaginatedResponse.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)),
      (list) => list!.map((e) => CharacterDto.fromJson(e)).toList(),
    );
  }

  Future<CharacterDto> characters(List<int> ids) async {
    final response = await _httpClient.get(
      _baseUrl.replace(
        pathSegments: [
          ..._baseUrl.pathSegments,
          characterEndpoint,
          '/${ids.join(',')}',
        ],
      ),
    );

    _handleErrorResponse(response);

    return CharacterDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  void close() => _httpClient.close();
}
