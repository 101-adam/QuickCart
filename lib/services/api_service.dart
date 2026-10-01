import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    final response = await _getJson('/products');
    final List<dynamic> decoded = jsonDecode(response.body);
    return decoded.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<String>> fetchCategories() async {
    final response = await _getJson('/products/categories');
    final List<dynamic> decoded = jsonDecode(response.body);
    return decoded.map((item) => item.toString()).toList();
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final encodedCategory = Uri.encodeComponent(category.toLowerCase());
    final response = await _getJson('/products/category/$encodedCategory');
    final List<dynamic> decoded = jsonDecode(response.body);
    return decoded.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<http.Response> _getJson(String path) async {
    final uri = Uri.parse('$_baseUrl$path');

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      }
      throw Exception('Unable to load data right now.');
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('The server returned an invalid response.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (_) {
      throw Exception('Something went wrong. Please try again.');
    }
  }
}
