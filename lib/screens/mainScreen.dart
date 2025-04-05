import 'package:flutter/material.dart';
import 'package:foodapp/auth/auth_screen.dart';
import 'package:foodapp/profile_settings_page.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    products = api.fetchProduct(); // Başlangıçta tüm ürünleri al
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
            MaterialPageRoute(builder: (context) => ProfileSettingsPageWidget()),
          );
        } else if (value == 'logout') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        }
      },
      itemBuilder: (BuildContext context) => [
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
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // Foods butonunun sağında bir ok simgesi olacak
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Foods'),
                  IconButton(
                    icon: Icon(
                      _isFoodExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    onPressed:
                        _toggleFoodExpansion, // Alt kategorileri göster/gizle
                  ),
                ],
              ),
              onTap: () {
                _toggleFoodExpansion(); // Foods sekmesine tıklandığında alt kategorileri göster
              },
            ),
            // Alt kategori seçenekleri
            if (_isFoodExpanded)
              Column(
                children: [
                  ListTile(
                    title: Text('Fruits'),
                    onTap: () {
                      _selectCategory('Fruits'); // Fruits kategorisini seç
                      Navigator.pop(context); // Drawer'ı kapat
                    },
                  ),
                  ListTile(
                    title: Text('Vegetables'),
                    onTap: () {
                      _selectCategory(
                        'Vegetables',
                      ); // Vegetables kategorisini seç
                      Navigator.pop(context); // Drawer'ı kapat
                    },
                  ),
                  ListTile(
                    title: Text('Meat and Fish'),
                    onTap: () {
                      _selectCategory(
                        'Meat and Fish',
                      ); // Meat and Fish kategorisini seç
                      Navigator.pop(context); // Drawer'ı kapat
                    },
                  ),
                  ListTile(
                    title: Text('Dairy Products'),
                    onTap: () {
                      _selectCategory(
                        'Dairy Products',
                      ); // Dairy Products kategorisini seç
                      Navigator.pop(context); // Drawer'ı kapat
                    },
                  ),
                  ListTile(
                    title: Text('Nuts'),
                    onTap: () {
                      _selectCategory('Nuts'); // Nuts kategorisini seç
                      Navigator.pop(context); // Drawer'ı kapat
                    },
                  ),
                ],
              ),
          ],
        ),
      ),

      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
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

          // No data state
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

          // Data available
          final products = snapshot.data!;

          return GridView.builder(
            shrinkWrap: true, // Gereksiz genişlemeyi önler
            physics: const BouncingScrollPhysics(), // Daha akıcı kaydırma
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6, // Ürün kartlarının oranını ayarla
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
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
                                onPressed: () {},
                                icon: const Icon(Icons.shopping_cart),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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

    if (index == 0) {}

    if (index == 1) {}
  }
}
