class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final int ratingCount;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.ratingCount,
    required this.imageUrl,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'];
    double rate = 0;
    int count = 0;

    if (ratingJson is Map) {
      final rawRate = ratingJson['rate'];
      final rawCount = ratingJson['count'];
      rate = rawRate is num ? rawRate.toDouble() : 0.0;
      count = rawCount is num ? rawCount.toInt() : 0;
    }

    return Product(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? 'Uncategorized',
      price: (json['price'] as num).toDouble(),
      rating: rate,
      ratingCount: count,
      imageUrl: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
