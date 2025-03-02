import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:commerce_style_sample_app/models/product.dart';
import 'package:commerce_style_sample_app/providers/providers.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {

  // ScrollControllerを利用する
  // 👉 Scroll位置情報を元に次ページのデータ読み込み処理を実行するために必要
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 初回表示時のデータ取得処理
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productViewModelProvider.notifier).fetchProducts();
    });

    // Scroll処理のListener追加
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Scroll処理のListener解除
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll処理のListener処理で無限スクロールを実行するための処理
  // 👉 Scroll最下部に到達したら、プロダクト情報のfetch処理を試みる
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      // ViewModelProviderを利用する（ConsumerStatefulWidgetなのでそのまま利用可能）
      final state = ref.read(productViewModelProvider);
      // 読み込み中でない時、かつ、次のデータが存在する時にプロダクト情報のfetch処理を実行する
      if (!state.isLoading && state.hasMoreData) {
        ref.read(productViewModelProvider.notifier).fetchProducts();
      }
    }
  }

  //
  //
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productViewModelProvider);
    final products = state.products;
    return Scaffold(
      appBar: AppBar(
        title: const Text('商品リスト'),
      ),
      body: state.hasError && products.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'エラーが発生しました: ${state.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(productViewModelProvider.notifier).fetchProducts(),
              child: const Text('再試行'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          await ref.read(productViewModelProvider.notifier).fetchProducts(refresh: true);
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: products.length + (state.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == products.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return _buildProductCard(products[index]);
          },
        ),
      ),
    );
  }

  //
  //
  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.thumbnail,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${product.rating}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "No.${product.id} / Stock: ${product.stock} / Discount: ${product.discountPercentage}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}