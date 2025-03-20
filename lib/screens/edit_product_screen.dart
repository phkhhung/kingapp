import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/db_helper.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onUpdate;

  const EditProductScreen({super.key, required this.product, required this.onUpdate});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.loaisp);
    _priceController = TextEditingController(text: widget.product.gia.toString());
  }

  // 🟢 Chọn ảnh từ thư viện hoặc camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // 🟢 Lưu sản phẩm sau khi chỉnh sửa
  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      String newImagePath = _imageFile?.path ?? widget.product.hinhanh;

      Product updatedProduct = Product(
        id: widget.product.id,
        loaisp: _nameController.text,
        gia: int.parse(_priceController.text),
        hinhanh: newImagePath,
      );

      await MongoDatabase.updateProduct(updatedProduct);
      widget.onUpdate(updatedProduct);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sửa sản phẩm")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🟢 Hiển thị ảnh cũ hoặc mới
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (widget.product.hinhanh.isNotEmpty
                      ? FileImage(File(widget.product.hinhanh))
                      : null),
                  child: _imageFile == null && widget.product.hinhanh.isEmpty
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // 🟢 Nhập loại sản phẩm
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Loại sản phẩm"),
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),
              const SizedBox(height: 10),

              // 🟢 Nhập giá sản phẩm
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Giá sản phẩm"),
                validator: (value) => value!.isEmpty ? "Không được để trống" : null,
              ),
              const SizedBox(height: 20),

              // 🟢 Nút lưu sản phẩm
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text("Lưu thay đổi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
