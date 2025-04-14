import 'package:flutter/material.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/services/cart_services.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.product ?? "Ürün Detayı"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.photo?.isNotEmpty == true
                    ? product.photo!
                    : "https://via.placeholder.com/300",
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.product ?? "Ürün Adı Yok",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              product.description ?? "Açıklama bulunamadı",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Fiyat: ${product.price ?? 0}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 220,),
                IconButton(
                            onPressed: () {
                              CartService.addToCart(product);
                            },
                            icon: const Icon(Icons.shopping_cart),
                          ),
              ],
            ),
             Text( "Available: " + product.stock.toString(),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                        
                      ),)
          ],
        ),
      ),
    );
  }
}
