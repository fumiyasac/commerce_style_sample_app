import 'package:commerce_style_sample_app/models/product.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool hasMoreData;
  final int currentSkip;

  ProductState({
    required this.products,
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    required this.hasMoreData,
    required this.currentSkip,
  });

  // 初期状態
  factory ProductState.initial() {
    return ProductState(
      products: [],
      isLoading: false,
      hasError: false,
      errorMessage: null,
      hasMoreData: true,
      currentSkip: 0,
    );
  }

  // 状態のコピーを作る
  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? hasMoreData,
    int? currentSkip,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }
}