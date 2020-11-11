import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(12.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
        // create: (c) => products[idx],
        value: products[idx],
        // if you are not using ctx in the create function,
        // this one makes it shorter using ChangeNotifierProvider.value
        // this should be used on single List or Grid items
        child: ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
