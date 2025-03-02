import 'package:commerce_style_sample_app/model/product_model.dart';

class ProductListState {

  final List<ProductModel> productList;
  final bool loading;
  final bool maxLoaded;

  ProductListState({
    required this.productList,
    required this.loading,
    required this.maxLoaded,
  });

  ProductListState.initial({
    this.loading = false,
    this.maxLoaded = false,
  }): productList = [];

  ProductListState copyWith({
    List<ProductModel>? productList,
    bool? loading,
    bool? maxLoaded,
  }) {
    return ProductListState(
      productList: productList ?? this.productList,
      loading: loading ?? this.loading,
      maxLoaded: maxLoaded ?? this.maxLoaded,
    );
  }
}
