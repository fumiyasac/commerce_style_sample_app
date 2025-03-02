import 'package:commerce_style_sample_app/view_models/product_state.dart';
import 'package:commerce_style_sample_app/services/product_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class ProductViewModel extends StateNotifier<ProductState> {
  final ProductService _productService;
  final int _limit = 10;

  ProductViewModel(this._productService) : super(ProductState.initial());

  Future<void> fetchProducts({bool refresh = false}) async {
    // リフレッシュの場合は状態をリセット
    if (refresh) {
      state = ProductState.initial();
    }

    // すでにロード中か、もうデータがない場合は何もしない
    if (state.isLoading || (!state.hasMoreData && !refresh)) {
      return;
    }

    // ロード中状態に更新
    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final result = await _productService.getProducts(
        limit: _limit,
        skip: state.currentSkip,
      );

      if (result.products.isEmpty) {
        // データがなければ終了フラグを立てる
        state = state.copyWith(
          isLoading: false,
          hasMoreData: false,
        );
      } else {
        // 既存のリストに追加
        final updatedProducts = [...state.products, ...result.products];

        state = state.copyWith(
          products: updatedProducts,
          isLoading: false,
          currentSkip: state.currentSkip + _limit,
          hasMoreData: state.currentSkip + _limit < result.total,
        );
      }
    } catch (e) {
      // エラー状態に更新
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }
}
