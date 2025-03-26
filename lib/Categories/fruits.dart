import 'package:flutter/material.dart';

class FruitsPage extends StatelessWidget {
  const FruitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fruits')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Apple'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: 'Apple'),
                ),
              );
            },
          ),
          // Other Products can be added here
        ],
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final String product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$product Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Image.asset('assets\fruitselma.jpg'), // Ürün resmi
            SizedBox(height: 16.0),
            Text(
              '$product - Apple',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Details about the apple product...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              'Price: \$1.99',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 16.0),
            Text('Also show component information:'),
            Text('Component: Fresh Apple, Origin: USA'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Satın alma işlemi burada yapılabilir
                print('Product bought');
              },
              child: Text('Buy Now'),
            ),
          ],
        ),
      ),
    );
  }
}
