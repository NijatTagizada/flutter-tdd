// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_trivia_remote_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _NumberTriviaRemoteDataSourceImpl
    implements NumberTriviaRemoteDataSourceImpl {
  _NumberTriviaRemoteDataSourceImpl(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(number) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NumberTriviaModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '{number}?json',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NumberTriviaModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NumberTriviaModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'random?json',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NumberTriviaModel.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
