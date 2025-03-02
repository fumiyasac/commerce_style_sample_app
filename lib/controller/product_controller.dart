import 'package:commerce_style_sample_app/repository/product_repository.dart';
import 'package:commerce_style_sample_app/state/product_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_controller.g.dart';

@riverpod
class ProductController extends _$ProductController {
  @override
  ProductListState build() => ProductListState(
    productList: [],
    loading: false,
    maxLoaded: false,
  );

  void loadProductList () async {
    if (state.loading || state.maxLoaded) {
      return;
    }
    state = state.copyWith(loading: true);
    // Repositoryの処理を呼び出して利用する
    final repository = ref.read(productRepositoryProvider);
    final productList = await repository.getProducts(offset: state.productList.length);
    if (productList.isEmpty) {
      state = state.copyWith(maxLoaded: true, loading: false);
    } else {
      state = state.copyWith(productList: [...state.productList, ...productList], loading: false);
    }
  }
}