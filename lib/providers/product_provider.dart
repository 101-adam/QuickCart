import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  List<Product> _products = <Product>[];
  List<String> _categories = <String>[];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool isLoading = false;
  String? errorMessage;

  List<Product> get products => _products;
  List<String> get categories => ['All', ..._categories.map(_capitalizeCategory)];
  String get selectedCategory => _selectedCategory == 'all' ? 'All' : _capitalizeCategory(_selectedCategory);
  String get searchQuery => _searchQuery;

  List<Product> get filteredProducts {
    final normalizedSelection = _selectedCategory.toLowerCase();
    final source = normalizedSelection == 'all'
        ? _products
        : _products.where((product) => product.category.toLowerCase() == normalizedSelection).toList();

    if (_searchQuery.trim().isEmpty) {
      return source;
    }

    final query = _searchQuery.trim().toLowerCase();
    return source.where((product) {
      final title = product.title.toLowerCase();
      final category = product.category.toLowerCase();
      final description = product.description.toLowerCase();
      return title.contains(query) || category.contains(query) || description.contains(query);
    }).toList();
  }

  Future<void> loadInitialData() async {
    await fetchCategories();
    await fetchProducts();
  }

  Future<void> retry() async {
    errorMessage = null;
    notifyListeners();
    await loadInitialData();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await _apiService.fetchCategories();
      _categories = categories.map((category) => category.toLowerCase()).toList();
      if (_selectedCategory != 'all' &&
          !_categories.any((category) => category == _selectedCategory.toLowerCase())) {
        _selectedCategory = 'all';
      }
      notifyListeners();
    } catch (e) {
      errorMessage = _cleanError(e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final normalizedSelection = _selectedCategory.toLowerCase();
      final products = normalizedSelection == 'all'
          ? await _apiService.fetchProducts()
          : await _apiService.fetchProductsByCategory(normalizedSelection);
      _products = products;
    } catch (e) {
      errorMessage = _cleanError(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCategory(String category) async {
    final normalized = category.toLowerCase();
    if (normalized == _selectedCategory.toLowerCase()) {
      return;
    }

    _selectedCategory = normalized;
    await fetchProducts();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  static String _capitalizeCategory(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  static String _cleanError(String message) {
    final cleaned = message.replaceFirst('Exception: ', '');
    return cleaned.isEmpty ? 'Something went wrong. Please try again.' : cleaned;
  }
}
