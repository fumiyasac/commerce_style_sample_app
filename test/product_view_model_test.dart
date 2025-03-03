import 'package:commerce_style_sample_app/models/product.dart';
import 'package:commerce_style_sample_app/models/product_response.dart';
import 'package:commerce_style_sample_app/services/product_service.dart';
import 'package:commerce_style_sample_app/view_models/product_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<ProductService>()])

import 'product_view_model_test.mocks.dart';

void main() {
  group('PostalCodeProvider Tests', () {
    late ProviderContainer container;
    late MockProductService mockProductService;

    setUp(() {
      mockProductService = MockProductService();
      container = ProviderContainer(
        overrides: [
          productServiceProvider.overrideWithValue(mockProductService),
        ],
      );
      addTearDown(container.dispose);
    });

    test('should initial state should be correct', () {
      final state = container.read(productViewModelProvider);
      expect(state.products, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.hasMoreData, isTrue);
      expect(state.currentSkip, 0);
    });

    test('should fetch successfully and have next page', () async {
      final mockProductList = [
        Product(
          id: 1,
          title: "Title Example No.1",
          description: "Description Example No.1",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 2,
          title: "Title Example No.2",
          description: "Description Example No.2",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 3,
          title: "Title Example No.3",
          description: "Description Example No.3",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 4,
          title: "Title Example No.4",
          description: "Description Example No.4",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 5,
          title: "Title Example No.5",
          description: "Description Example No.5",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 6,
          title: "Title Example No.6",
          description: "Description Example No.6",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 7,
          title: "Title Example No.7",
          description: "Description Example No.7",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 8,
          title: "Title Example No.8",
          description: "Description Example No.8",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 9,
          title: "Title Example No.9",
          description: "Description Example No.9",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
        Product(
          id: 10,
          title: "Title Example No.10",
          description: "Description Example No.10",
          price: 9.99,
          discountPercentage: 7.17,
          rating: 4.94,
          stock: 5,
          thumbnail: "https://cdn.dummyjson.com/products/images/thumbnail.png"
        ),
      ];
      final mockProductResponse = ProductResponse(
          products: mockProductList,
          total: 194,
          skip: 0,
          limit: 10
      );

      when(mockProductService.getProducts(limit: 10, skip: 0)).thenAnswer(
            (_) async => mockProductResponse,
      );

      final notifier = container.read(productViewModelProvider.notifier);
      await notifier.fetchProducts();

      final state = container.read(productViewModelProvider);
      expect(state.products.length, 10);
      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.hasMoreData, isTrue);
      expect(state.currentSkip, 10);
      verify(mockProductService.getProducts(limit: 10, skip: 0)).called(1);
    });

    test('should fetch successfully and stop next fetch', () async {
      final mockProductResponse = ProductResponse(
          products: [],
          total: 194,
          skip: 0,
          limit: 10
      );

      when(mockProductService.getProducts(limit: 10, skip: 0)).thenAnswer(
            (_) async => mockProductResponse,
      );

      final notifier = container.read(productViewModelProvider.notifier);
      await notifier.fetchProducts();

      final state = container.read(productViewModelProvider);
      expect(state.products.length, 0);
      expect(state.isLoading, isFalse);
      expect(state.hasError, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.hasMoreData, isFalse);
      expect(state.currentSkip, 0);
      verify(mockProductService.getProducts(limit: 10, skip: 0)).called(1);
    });

    test('should handle error during product fetch', () async {
      const errorMessage = 'プロダクトデータの取得に失敗しました';

      when(mockProductService.getProducts(limit: 10, skip: 0)).thenThrow(
        Exception(errorMessage),
      );

      final notifier = container.read(productViewModelProvider.notifier);
      await notifier.fetchProducts();

      final state = container.read(productViewModelProvider);
      expect(state.products.length, 0);
      expect(state.isLoading, isFalse);
      expect(state.hasError, isTrue);
      expect(state.errorMessage, "Exception: プロダクトデータの取得に失敗しました");
      expect(state.hasMoreData, isTrue);
      expect(state.currentSkip, 0);
      verify(mockProductService.getProducts(limit: 10, skip: 0)).called(1);
    });
  });
}