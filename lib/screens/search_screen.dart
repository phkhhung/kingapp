import 'package:flutter/material.dart';
import '../models/product.dart';

class SearchScreen extends StatefulWidget {
  final List<Product> products;
  SearchScreen({required this.products});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
  }

  void searchProduct(String value) {
    setState(() {
      query = value;
      _filteredProducts = widget.products
          .where((product) => product.loaisp.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm sản phẩm')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: searchProduct,
              decoration: const InputDecoration(
                hintText: 'Nhập tên sản phẩm...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_filteredProducts[index].loaisp));
              },
            ),
          ),
        ],
      ),
    );
  }
}
