import 'package:dio/dio.dart';
import 'package:commerce_style_sample_app/models/product_response.dart';

class ProductService {
  // MEMO: API非同期通信処理にPackage「dio」を利用する
  final Dio _dio;
  final String _baseUrl = 'https://dummyjson.com/products';

  // Dioに関する設定とインスタンス化をする
  ProductService() : _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
    )
  );

  // ページネーション処理を伴うプロダクト情報一覧の取得処理
  Future<ProductResponse> getProducts({int limit = 10, int skip = 0}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );
      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to load products: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
