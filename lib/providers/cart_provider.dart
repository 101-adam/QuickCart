import 'package:flutter/material.dart';

import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final Set<String> _favorites = <String>{};

  List<CartItem> get items => _items.values.toList();

  bool isFavorite(String productId) => _favorites.contains(productId);

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void changeQuantity(String productId, int delta) {
    final item = _items[productId];
    if (item == null) return;

    final nextQty = item.quantity + delta;
    if (nextQty <= 0) {
      _items.remove(productId);
    } else {
      item.quantity = nextQty;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _items.values.fold(
      0.0,
      (total, item) => total + item.product.price * item.quantity,
    );
  }

  int get itemCount {
    return _items.values.fold(0, (count, item) => count + item.quantity);
  }
}
