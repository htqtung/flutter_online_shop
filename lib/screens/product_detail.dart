import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  // final String productName;
  //
  // ProductDetailScreen(this.productName);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final productItem =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(productItem.title),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(productItem.imageUrl, fit: BoxFit.cover),
          ),
          SizedBox(height: 8),
          Text(
            '\$${productItem.price}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            width: double.infinity,
            child: Text(
              productItem.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          SizedBox(height: 24),
          RaisedButton(
            child: Text('Add to cart'),
            onPressed: () {
              Provider.of<Cart>(context, listen: false).addItem(
                productItem.id,
                productItem.price,
                productItem.title,
              );
            },
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
        ],
      )),
    );
  }
}
