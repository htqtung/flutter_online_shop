import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail.dart';
import './screens/products_overview.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // use create instead of .value to instantiate a new object
      // for efficiency and avoiding bugs
      // this is different from List/Grid items where we reusing widgets
      // with existing data
      create: (ctx) => Products(),
      child: MaterialApp(
      title: 'iShop',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.amber,
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
      }
    ),);
  }
}
