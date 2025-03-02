import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:commerce_style_sample_app/services/product_service.dart';
import 'package:commerce_style_sample_app/view_models/product_state.dart';
import 'package:commerce_style_sample_app/view_models/product_view_model.dart';

// サービスプロバイダー
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

// ビューモデルプロバイダー
final productViewModelProvider = StateNotifierProvider<ProductViewModel, ProductState>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductViewModel(productService);
});