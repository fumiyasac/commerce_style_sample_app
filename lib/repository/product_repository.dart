import 'package:commerce_style_sample_app/model/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'product_repository.g.dart';

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository();
}

class ProductRepository {
  Future<List<ProductModel>> getProducts({ required int offset, int limit = 10 }) async {
    final response = await http.get(
        Uri.parse('https://dummyjson.com/products?skip=$offset&limit=$limit'),
    );
    if (response.statusCode == 200) {
      final decode = json.decode(response.body);
      final List<dynamic> productList = decode["products"];
      return productList.map((product) => ProductModel.fromJson(product)).toList();
    } else {
      throw Exception('データの取得に失敗しました');
    }
  }
}