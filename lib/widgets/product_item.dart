import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productItem.id);
          },
          child: Image.network(
            productItem.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // With this and by setting listen: false in the product provider above,
          // only the widget wrapped inside the Consumer will be
          // rebuilt whenever the state changes
          leading: Consumer<Product>(
            // the "child" argument is used to pass a not-changing widget into
            // the builder method so that when the widget rebuild,
            // "child" will remain unchanged -> tiny optimisation
            builder: (ctx, product, child) => IconButton(
              icon: Icon(productItem.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                productItem.toggleFavorite();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            productItem.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}