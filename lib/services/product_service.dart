import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:commerce_style_sample_app/models/product_response.dart';

class ProductService {
  final String baseUrl = 'https://dummyjson.com/products';

  Future<ProductResponse> getProducts({int limit = 10, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      return ProductResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
