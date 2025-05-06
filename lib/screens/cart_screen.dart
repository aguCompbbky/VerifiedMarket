import 'package:flutter/material.dart';
import 'package:foodapp/screens/mainScreen.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/services/cart_services.dart';
import 'package:foodapp/utils/services/connection.dart';
import 'package:foodapp/utils/services/wallet_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem?> cartItems = [];

  @override
  void initState() {
    super.initState();
    CartService.getCartItems().then((items) {
      setState(() {
        cartItems = items;
      });
    });
  }

  // _purchaseItems fonksiyonu
  void _purchaseItems(BuildContext context) async {
    final filteredCartItems = cartItems.whereType<CartItem>().toList();

    // Toplam fiyat hesaplanıyor
    double totalPrice = filteredCartItems.fold(0.0, (sum, item) {
      double price =
          double.tryParse(
            item!.product.price?.replaceAll(RegExp(r'[^\d.]'), '') ?? "0",
          ) ??
          0.0;
      return sum + price * item!.quantity;
    });

    // Kullanıcı bilgilerini almak
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("loggedInUserId");

    if (userId != null) {
      // WalletService nesnesi oluşturuluyor
      final walletService = WalletService();

      // Bakiye alınıyor
      double balance = await walletService.getBalance(userId);

      // Eğer yeterli bakiye varsa
      if (balance >= totalPrice) {
        // Bakiyeyi güncelle
        bool success = await walletService.updateBalance(
          userId,
          (-totalPrice),
        ); // Bakiyeyi azaltma

        if (success) {
          // CartService nesnesi oluşturuluyor
          final cartService = CartService();

          // Satın alma işlemi yapılıyor
          await cartService.purchaseCart(filteredCartItems, context);

          // Satın alma işlemi tamamlandı
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Satın alma tamamlandı ✅")));

          // Sepeti temizleyelim
          await CartService.clearCart();

          // Sepet güncelleniyor
          CartService.getCartItems().then((items) {
            setState(() {
              cartItems = items;
            });
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Bakiye güncellenirken hata oluştu.")),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Yetersiz bakiye!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Toplam fiyat hesabı
    double totalPrice = cartItems.fold(0.0, (sum, item) {
      double price =
          double.tryParse(
            item!.product.price?.replaceAll(RegExp(r'[^\d.]'), '') ?? "0",
          ) ??
          0.0;
      return sum + price * item!.quantity;
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
                builder:
                    (_) => AlertDialog(
                      title: Text("Sepeti Temizle"),
                      content: Text(
                        "Tüm ürünleri sepetten silmek istediğine emin misin?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Vazgeç"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Temizle"),
                        ),
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
      body:
          cartItems.isEmpty
              ? Center(child: Text("Sepetiniz boş 🛒"))
              : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: ListTile(
                      leading: Image.network(
                        item!.product.photo ?? "",
                        width: 50,
                        errorBuilder:
                            (_, __, ___) => Icon(Icons.image_not_supported),
                      ),
                      title: Text(item.product.product ?? "Ürün"),
                      subtitle: Text(
                        "${item.product.price ?? "0"} x ${item.quantity}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Artı butonu
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              await CartService.addToCart(item.product);
                              final updatedCart =
                                  await CartService.getCartItems();
                              setState(() {
                                cartItems = updatedCart;
                              });
                            },
                          ),

                          // Eksi butonu
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () async {
                              await CartService.decreaseQuantity(
                                item.product.id ?? 0,
                              );
                              final updatedCart =
                                  await CartService.getCartItems();
                              setState(() {
                                cartItems = updatedCart;
                              });
                            },
                          ),

                          // Silme butonu
                          IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () async {
                              await CartService.removeFromCart(
                                item.product.id ?? 0,
                              );
                              final updatedCart =
                                  await CartService.getCartItems();
                              setState(() {
                                cartItems = updatedCart;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar:
          cartItems.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _purchaseItems(context),
                  child: Text(
                    "Toplam: ₺${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
              : SizedBox.shrink(),
    );
  }
}
