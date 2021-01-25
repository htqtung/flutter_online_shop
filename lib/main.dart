import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail.dart';
import './screens/products_overview_screen.dart';
import './providers/auth.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // recommended way
      // use create instead of .value to instantiate a new object
      // for efficiency and avoiding bugs
      // this is different from List/Grid items where we reusing widgets
      // with existing data
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // Make sure Auth provider is written before other providers
        // that use the Auth provider
        // so that the following will rebuild when Auth provider changes
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevProducts) => Products(
            auth.token,
            auth.userId,
            prevProducts == null ? [] : prevProducts.items,
          ),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, prevOrders) => Orders(
            auth.token,
            auth.userId,
            prevOrders == null ? [] : prevOrders.orders,
          ),
          create: null,
        ),
      ],
      // MaterialApp will be rebuilt whenever auth changes
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            title: 'iShop',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.amber,
              fontFamily: 'Lato',
            ),
            home:
                auth.isAuthenticated ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            }),
      ),
    );
  }
}
