import 'package:flutter/material.dart';
import 'package:foodapp/utils/models/products.dart';
import 'package:foodapp/utils/models/supplyStep.dart';
import 'package:foodapp/utils/services/cart_services.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      backgroundColor: Colors.white,

      // Sepete Ekle butonunu sabitle
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
            // Ürün görseli ve temel bilgiler
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
                    widget.product.products ?? "Ürün İsmi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
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

            // Kategori
            buildInfoBlock("Katagori", "${widget.product.category}"),
            // Stok
            buildInfoBlock(
              "Ürün Stok Durumu",
              "${widget.product.stock}",
            ), // ! quantityIdentifier ekleyecez.
            // Açıklama
            buildInfoBlock("Ürün Açıklaması", "${widget.product.description}"),

            // Tedarik Süreci
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
                  buildSupplyChain(supplySteps),
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

  Widget buildSupplyChain(List<SupplyStep> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          steps.map((step) {
            Color statusColor;
            String statusText;

            switch (step.status) {
              case "helal":
                statusColor = Colors.green;
                statusText = "Helal";
                break;
              case "kontrol_edilmedi":
                statusColor = Colors.orange;
                statusText = "Kontrol Edilmedi";
                break;
              case "gecemedi":
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
                    Icon(
                      step.isCurrent
                          ? Icons.location_on
                          : Icons.radio_button_checked,
                      color: step.isCurrent ? Colors.green : Colors.grey,
                    ),
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
                          step.locationName,
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

  List<SupplyStep> supplySteps = [
    SupplyStep(locationName: "Çiftlik", status: "helal", isCurrent: false),
    SupplyStep(
      locationName: "Üretim Tesisi",
      status: "kontrol_edilmedi",
      isCurrent: false,
    ),
    SupplyStep(
      locationName: "Depo",
      status: "helal",
      isCurrent: true,
    ), // Şu an buradaysa
    SupplyStep(
      locationName: "Market Rafı",
      status: "kontrol_edilmedi",
      isCurrent: false,
    ),
  ];
}
