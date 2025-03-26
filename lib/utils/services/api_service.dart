import 'dart:convert';
import 'package:foodapp/utils/constants/constants.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:http/http.dart' as http;


class ProductApi {
  // Tüm ürünleri çeken fonksiyon
  Future<List<Product>> fetchProduct() async {
    final url = Uri.parse(baseUrlProduct);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Product> products = [];

        for (var item in data) {
          Product product = Product.fromJson(item);
          products.add(product);
        }

        return products;
      } else {
        throw Exception("Failed to load product");
      }
    } catch (e) {
      throw Exception("Error :  $e");
    }
  }

  // Kategoriye göre ürünleri çeken fonksiyon
  Future<List<Product>> fetchProductByCategory(String category) async {
    final url = Uri.parse(baseUrlProduct); // Base URL ile veriyi çekiyoruz

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Kategoriyi filtreleyerek sadece o kategoriye ait ürünleri döndür
        List<Product> filteredProducts =
            data
                .where((item) => item['category'] == category)
                .map<Product>((item) => Product.fromJson(item))
                .toList();

        return filteredProducts;
      } else {
        throw Exception("Failed to load products for category: $category");
      }
    } catch (e) {
      throw Exception("Error :  $e");
    }
  }
}
