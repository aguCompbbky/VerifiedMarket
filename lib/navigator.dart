import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedCategory = 'None';
  bool _isFoodExpanded = true; // Alt kategori listesi gösterilsin mi?

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _toggleFoodExpansion() {
    setState(() {
      _isFoodExpanded = !_isFoodExpanded; // Alt kategorileri göster/gizle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('App')));
  }
}
