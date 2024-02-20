import 'package:dio/dio.dart';

class DioRequest {
  final Dio _dio = Dio();

  //构造函数
  DioRequest() {
    _dio.options = BaseOptions(
      baseUrl: 'http://192.168.213.132:81',
      connectTimeout: 10000,
      contentType: 'application/json; charset=utf-8',
      headers: {},
    );
    //请求拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.data['code'] == 1) {
          response.data = response.data['data'];
        }
        handler.next(response);
      },
    ));
  }

// get请求
  Future<Response<dynamic>> get(String path, [Map<String, dynamic>? queryParameters]) {
    return _dio.get(path, queryParameters: queryParameters);
  }

// post请求
  Future<Response<dynamic>> post(String path, [Map<String, dynamic>? data]) {
    return _dio.post(path, data: data);
  }
}
