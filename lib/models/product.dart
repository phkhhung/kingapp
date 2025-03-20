import 'package:mongo_dart/mongo_dart.dart';

class Product {
  final String id;
  final String loaisp;
  final int gia;
  final String hinhanh;

  Product({
    required this.id,
    required this.loaisp,
    required this.gia,
    required this.hinhanh,
  });

  // 🟢 Chuyển từ MongoDB Map sang Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] != null ? map['_id'].toHexString() : '',
      loaisp: map['loaisp'] ?? '',
      gia: map['gia'] ?? 0,
      hinhanh: map['hinhanh'] ?? '',
    );
  }

  // 🟢 Chuyển từ Product object sang MongoDB Map
  Map<String, dynamic> toMap() {
    return {
      "loaisp": loaisp,
      "gia": gia,
      "hinhanh": hinhanh,
    };
  }
}
