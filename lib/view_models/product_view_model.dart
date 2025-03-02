import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:commerce_style_sample_app/view_models/product_state.dart';
import 'package:commerce_style_sample_app/services/product_service.dart';

part 'product_view_model.g.dart';

// ServiceProviderを定義する
@riverpod
ProductService productService(ProductServiceRef ref) {
  return ProductService();
}

// ViewModelProviderを定義する
@riverpod
class ProductViewModel extends _$ProductViewModel {

  @override
  ProductState build() {
    // 初期状態を返す
    return ProductState.initial();
  }

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
      final productService = ref.read(productServiceProvider);
      final result = await productService.getProducts(
        limit: 10,
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
          currentSkip: state.currentSkip + 10,
          hasMoreData: state.currentSkip + 10 < result.total,
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
