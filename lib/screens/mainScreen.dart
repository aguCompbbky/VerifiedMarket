import 'package:flutter/material.dart';
import 'package:foodapp/auth/login_page.dart';
import 'package:foodapp/product_details.dart';
import 'package:foodapp/profile/profile_settings_page.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/services/api_service.dart';
import 'cart_screen.dart';
import 'package:foodapp/utils/services/cart_services.dart';

class MarketApp extends StatefulWidget {
  const MarketApp({super.key});

  @override
  State<MarketApp> createState() => _MarketAppState();
}

class _MarketAppState extends State<MarketApp> {
  final ProductApi api = ProductApi();
  late Future<List<Product>> products;

  int _selectedIndex = 0;

  String _selectedCategory = 'None'; // Başlangıçta kategori seçilmemiş
  bool _isFoodExpanded = true; // Alt kategori listesi gösterilsin mi?

  List<String> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    products = api.fetchProduct();
    _loadCategories(); // kategorileri çek
  }

  void _loadCategories() async {
    try {
      final data = await api.fetchCategories();
      setState(() {
        _categories = data;
        _isLoadingCategories = false;
      });
    } catch (e) {
      print("Kategori yüklenemedi: $e");
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    // Kategori seçildiğinde, sadece o kategoriyi filtrele
    products = api.fetchProductByCategory(
      category,
    ); // Yeni kategoriye göre veriyi al
  }

  void _toggleFoodExpansion() {
    setState(() {
      _isFoodExpanded = !_isFoodExpanded; // Alt kategorileri göster/gizle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          "Market Uygulaması",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingsPageWidget(),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,

                  MaterialPageRoute(builder: (context) => LoginPage()),

                  //MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('Profil Ayarları'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Çıkış Yap'),
                  ),
                ],
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Kategoriler',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Tüm Ürünler'),
              onTap: () {
                setState(() {
                  _selectedCategory = 'None';
                  products = api.fetchProduct();
                });
                Navigator.pop(context);
              },
            ),
            if (_isLoadingCategories)
              Center(child: CircularProgressIndicator())
            else
              ..._categories.map(
                (category) => ListTile(
                  title: Text(category),
                  onTap: () {
                    _selectCategory(
                      category,
                    ); // burada direkt Türkçe kategori ismini gönderiyoruz
                    Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
      ),

      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Hata: ${snapshot.error}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Ürün bilgisi bulunamadı.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            );
          }

          final products = snapshot.data!;

          return GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProductDetailsPage(product: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.network(
                          product.photo?.isNotEmpty == true
                              ? product.photo!
                              : "https://via.placeholder.com/150",
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.fill,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.image_not_supported,
                                size: 100,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.product ?? "Ürün Adı Yok",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: 20),

                            const SizedBox(height: 4),
                            Text(
                              product.description ?? "Açıklama bulunamadı",
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${product.price ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showQuantityDialog(product);
                                    // CartService.addToCart(product);

                                    CartService.addToCart(product);
                                  },
                                  icon: const Icon(Icons.shopping_cart),
                                ),
                              ],
                            ),
                            Text(
                              "Available: " + product.stock.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepet',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MarketApp()),
      );
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
    }
  }

  void _showQuantityDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Quantity for ${product.product}'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Artı butonu
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        if (selectedQuantity < product.stock!) {
                          selectedQuantity++; // Miktarı arttır
                        }
                      });
                    },
                  ),
                  // Seçilen miktar
                  Text('$selectedQuantity', style: TextStyle(fontSize: 30)),
                  // Eksi butonu
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (selectedQuantity > 1) {
                          selectedQuantity--; // Miktarı azalt
                        }
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pop(selectedQuantity); // Seçilen miktarı geri döndür
                CartService.addToCart(product);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((selectedQuantity) {
      if (selectedQuantity != null) {
        // Seçilen miktarı işleme
        print('Selected quantity for ${product.product}: $selectedQuantity');
      }
    });
  }
}

int selectedQuantity = 1;
