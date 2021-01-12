import 'dart:convert';
import 'package:flutter_online_shop/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final url =
        'https://flutter-resell-shop-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
    final oldStatus = isFavorite;
    try {
      _setFavValue(!isFavorite);

      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        throw HttpException('Could not save product to Favorite.');
      }
    } catch (error) {
      _setFavValue(oldStatus);
      throw HttpException('Could not save product to Favorite.');
    }
  }
}
