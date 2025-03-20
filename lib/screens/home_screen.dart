import 'package:flutter/material.dart';
import 'dart:io';
import '../db/db_helper.dart';
import '../models/product.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';
import 'search_screen.dart'; // Import màn hình tìm kiếm

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  bool isGridView = true;
  bool isDarkMode = false;
  String _sortOption = 'Tên A-Z';

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    var data = await MongoDatabase.getProducts();
    setState(() {
      _products = data.map((item) => Product.fromMap(item)).toList();
      sortProducts(); // Áp dụng sắp xếp khi tải dữ liệu
    });
  }

  void deleteProduct(String id) async {
    await MongoDatabase.deleteProduct(id);
    loadProducts();
  }

  void updateProduct(Product updatedProduct) {
    setState(() {
      int index = _products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
    });
  }

  void sortProducts() {
    setState(() {
      if (_sortOption == 'Tên A-Z') {
        _products.sort((a, b) => a.loaisp.compareTo(b.loaisp));
      } else if (_sortOption == 'Giá') {
        _products.sort((a, b) => a.gia.compareTo(b.gia));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen(products: _products)),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortOption = value;
                sortProducts();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Tên A-Z', child: Text('Sắp xếp: Tên A-Z')),
              const PopupMenuItem(value: 'Giá', child: Text('Sắp xếp: Giá')),
            ],
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: isGridView ? buildGridView() : buildListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProductScreen(onProductAdded: loadProducts)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        var product = _products[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductScreen(product: product, onUpdate: updateProduct),
              ),
            );
          },
          child: Hero(
            tag: product.id,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: product.hinhanh.isNotEmpty
                          ? Image.file(File(product.hinhanh), width: double.infinity, fit: BoxFit.cover)
                          : const Icon(Icons.image, size: 50),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          product.loaisp,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${product.gia} VNĐ',
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(product: product, onUpdate: updateProduct),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteProduct(product.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        var product = _products[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductScreen(product: product, onUpdate: updateProduct),
              ),
            );
          },
          child: Hero(
            tag: product.id,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: product.hinhanh.isNotEmpty
                      ? Image.file(File(product.hinhanh), width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 50),
                ),
                title: Text(
                  product.loaisp,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text('${product.gia} VNĐ', style: const TextStyle(color: Colors.red)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteProduct(product.id),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
