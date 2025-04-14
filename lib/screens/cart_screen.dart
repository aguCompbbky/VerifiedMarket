import 'package:flutter/material.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/services/cart_services.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> cartItems = [];

  @override
void initState() {
  super.initState();
  CartService.getCartItems().then((items) {
    setState(() {
      cartItems = items;
    });
  });
}

void _purchaseItems() {
  CartService.purchaseCart(cartItems).then((_) {
    CartService.getCartItems().then((items) {
      setState(() {
        cartItems = items;
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Satın alma tamamlandı ✅")),
    );
  });
}


  @override
  Widget build(BuildContext context) {

     // toplam fiyatı hesapla
    double totalPrice = cartItems.fold(0.0, (sum, item) {
    double price = double.tryParse(item.price?.replaceAll(RegExp(r'[^\d.]'), '') ?? "0") ?? 0.0;
    return sum + price;
  });


    return Scaffold(
      appBar: AppBar(
        title: Text("Sepet"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
    IconButton(
      icon: Icon(Icons.history),
      tooltip: "Satın Alım Geçmişi",
      onPressed: () {
        Navigator.pushNamed(context, "/purchase-history");
      },
    ),
    IconButton(
  icon: Icon(Icons.delete_forever),
  tooltip: "Sepeti Temizle",
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Sepeti Temizle"),
        content: Text("Tüm ürünleri sepetten silmek istediğine emin misin?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Vazgeç")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text("Temizle")),
        ],
      ),
    );

    if (confirm == true) {
      await CartService.clearCart();
      setState(() {
        cartItems = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sepet başarıyla temizlendi 🧹")),
      );
    }
  },
),

  ],
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Sepetiniz boş 🛒"))
          : ListView.builder(
  itemCount: cartItems.length,
  itemBuilder: (context, index) {
    final item = cartItems[index];
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: Image.network(
          item.photo ?? "",
          width: 50,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.image_not_supported),
        ),
        title: Text(item.product ?? "Ürün"),
        subtitle: Text("${item.price ?? "0"}"),
        trailing: IconButton(
          icon: Icon(Icons.cancel, color: Colors.red),
          onPressed: () async {
            await CartService.removeFromCart(item.id ?? 0);
            final updatedCart = await CartService.getCartItems();
            setState(() {
              cartItems = updatedCart;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${item.product} sepetten silindi.")),
            );
          },
        ),
      ),
    );
  },
),

      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14)),
                onPressed: _purchaseItems,
                child: Text("Toplam: ₺${totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
