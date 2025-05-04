import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodapp/utils/models/address.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/models/supplyStep.dart';
import 'package:foodapp/utils/services/api_service.dart';
import 'package:foodapp/utils/services/cart_services.dart';
import 'package:http/http.dart' as http;

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  List<SupplyStep> _supplySteps = [];
  List<Address> _addresses = [];
  bool _isLoadingSteps = true;
  bool _isLoadingAddresses = true;
  ProductApi api = ProductApi();

  @override
  void initState() {
    super.initState();
    loadSupplySteps();
    loadAddresses();
  }

  Future<void> loadSupplySteps() async {
    try {
      List<SupplyStep> steps = await api.fetchSupplyStep(
        widget.product.id ?? -1,
      ); // product id ile çağır
      setState(() {
        _supplySteps = steps;
        _isLoadingSteps = false;
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _isLoadingSteps = false;
      });
    }
  }

  Future<void> loadAddresses() async {
    try {
      List<Address> addresses = await api.fetchAddresses();

      setState(() {
        _addresses = addresses;
        _isLoadingAddresses = false;
      });
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _isLoadingAddresses = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            CartService.addToCart(widget.product);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "Sepete Ekle",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.network(
                    widget.product.photo ?? "https://via.placeholder.com/150",
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Brand",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.product.product ?? "Ürün İsmi",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 6),
                  Text(
                    widget.product.price ?? "Fiyat bilgisi yok",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),
            Divider(),
            buildInfoBlock("Kategori", "${widget.product.category}"),
            buildInfoBlock("Ürün Stok Durumu", "${widget.product.stock}"),
            buildInfoBlock("Ürün Açıklaması", "${widget.product.description}"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tedarik Süreci",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _isLoadingSteps
                      ? Center(child: CircularProgressIndicator())
                      : buildSupplyChain(_supplySteps, _addresses),
                ],
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget buildInfoBlock(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(content, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget buildSupplyChain(List<SupplyStep> steps, List<Address> addresses) {
    if (steps.isEmpty) {
      return Text("Tedarik süreci bilgisi bulunamadı.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          steps.map((step) {
            // toAddress ile ownerAddress karşılaştır
            final matchedAddress = addresses.firstWhere(
              (addr) => addr.ownerAddress == step.toAddress,
              orElse: () => Address(status: -1), // eşleşmezse bilinmeyen durum
            );

            // Status'a göre renk ve metin belirle
            Color statusColor;
            String statusText;

            switch (matchedAddress.status) {
              case 2:
                statusColor = Colors.green;
                statusText = "Helal";
                break;
              case 1:
                statusColor = Colors.orange;
                statusText = "Kontrol Edilmedi";
                break;
              case 0:
                statusColor = Colors.red;
                statusText = "Geçemedi";
                break;
              default:
                statusColor = Colors.grey;
                statusText = "Bilinmiyor";
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(Icons.location_on, color: Colors.green),
                    if (step != steps.last)
                      Container(height: 40, width: 2, color: Colors.grey),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.name ?? "Konum Bilgisi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
