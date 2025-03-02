import 'package:dio/dio.dart';
import 'package:commerce_style_sample_app/models/product_response.dart';

class ProductService {

  final Dio _dio;
  final String _baseUrl = 'https://dummyjson.com/products';

  ProductService() : _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
    )
  );

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
