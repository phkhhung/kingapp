import 'package:mongo_dart/mongo_dart.dart';

class Product {
  String id;
  String loaisp;
  int gia;
  String hinhanh;

  Product({
    required this.id,
    required this.loaisp,
    required this.gia,
    required this.hinhanh,
  });

  // Chuyển từ MongoDB Map sang Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] != null ? (map['_id'] as ObjectId).oid : '',  //
      loaisp: map['loaisp'] ?? '',
      gia: map['gia'] ?? 0,
      hinhanh: map['hinhanh'] ?? '',
    );
  }

  // ✅ Chuyển từ Product sang MongoDB Map
  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) '_id': ObjectId.fromHexString(id),  // ✅ Đảm bảo id hợp lệ
      'loaisp': loaisp,
      'gia': gia,
      'hinhanh': hinhanh,
    };
  }
}
