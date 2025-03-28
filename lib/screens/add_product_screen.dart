import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/db_helper.dart';
import '../models/product.dart';

class AddProductScreen extends StatefulWidget {
  final Function onProductAdded;

  const AddProductScreen({super.key, required this.onProductAdded});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Chọn ảnh từ thư viện hoặc camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Hiển thị menu chọn ảnh
  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Chọn từ thư viện"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Chụp ảnh mới"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  // Lưu sản phẩm
  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: '', // ID sẽ được MongoDB tự động tạo
        loaisp: _nameController.text,
        gia: int.parse(_priceController.text),
        hinhanh: _image?.path ?? '',
      );

      await MongoDatabase.addProduct(newProduct);
      widget.onProductAdded(); // Cập nhật danh sách sản phẩm

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "add_product",
      child: Scaffold(
        appBar: AppBar(title: const Text('Thêm sản phẩm mới')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hiển thị ảnh đã chọn với hiệu ứng Fade
                GestureDetector(
                  onTap: _showImagePicker,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: CircleAvatar(
                      key: ValueKey(_image?.path),
                      radius: 60,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Nhập loại sản phẩm
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Loại sản phẩm",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => value!.isEmpty ? "Không được để trống" : null,
                ),
                const SizedBox(height: 10),

                // Nhập giá sản phẩm
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Giá sản phẩm",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => value!.isEmpty ? "Không được để trống" : null,
                ),
                const SizedBox(height: 20),

                // Nút thêm sản phẩm với hiệu ứng Slide
                ElevatedButton(
                  onPressed: _saveProduct,
                  child: const Text('Thêm sản phẩm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
