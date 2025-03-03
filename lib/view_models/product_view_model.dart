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
// 👉 riverpod_generatorでの自動生成を利用して作成する
@riverpod
class ProductViewModel extends _$ProductViewModel {

  @override
  ProductState build() {
    // 最初はProductStateの初期状態を返す
    return ProductState.initial();
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    // Refreshが実行された場合はProductStateを初期状態にリセットする
    if (refresh) {
      state = ProductState.initial();
    }
    // 既にLoading中、または、追加のデータがない場合は以降の処理を実施しない
    if (state.isLoading || (!state.hasMoreData && !refresh)) {
      return;
    }
    // ProductStateをLoading中状態に更新する
    state = state.copyWith(isLoading: true, hasError: false);
    try {
      // productServiceでの処理を実行するために、productServiceProviderを利用する
      final productService = ref.read(productServiceProvider);
      final result = await productService.getProducts(
        limit: 10,
        skip: state.currentSkip,
      );

      if (result.products.isEmpty) {
        // 追加のデータがない場合は終了フラグを立てる
        state = state.copyWith(
          isLoading: false,
          hasMoreData: false,
        );
      } else {
        // 新たに取得したプロダクト一覧情報が後に来るように、既存のリストに追加する
        final updatedProducts = [...state.products, ...result.products];
        state = state.copyWith(
          products: updatedProducts,
          isLoading: false,
          currentSkip: state.currentSkip + 10,
          hasMoreData: state.currentSkip + 10 < result.total,
        );
      }
    } catch (e) {
      // データ取得処理時にエラーが発生した場合は、エラー状態に更新する
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }
}
