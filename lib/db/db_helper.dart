import 'package:mongo_dart/mongo_dart.dart';
import '../models/product.dart';

class MongoDatabase {
  static var db, productCollection;

  static Future<void> connect() async {
    db = await Db.create("mongodb+srv://phkhhung7:phkhhung@cluster0.7fghf.mongodb.net//kingapp_db?retryWrites=true&w=majority&appName=Cluster0");
    await db.open();
    productCollection = db.collection("products");
  }

  // 🟢 Lấy danh sách sản phẩm
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      return await productCollection.find().toList();
    } catch (e) {
      print("❌ Lỗi lấy sản phẩm: $e");
      return [];
    }
  }

  // 🟢 Thêm sản phẩm mới
  static Future<void> addProduct(Product product) async {
    try {
      await productCollection.insertOne({
        'loaisp': product.loaisp,
        'gia': product.gia,
        'hinhanh': product.hinhanh,
      });
      print("✅ Thêm sản phẩm thành công");
    } catch (e) {
      print("❌ Lỗi khi thêm sản phẩm: $e");
    }
  }

  // 🟢 Xóa sản phẩm
  static Future<void> deleteProduct(String id) async {
    try {
      await productCollection.deleteOne({"_id": ObjectId.parse(id)});
      print("✅ Xóa sản phẩm thành công");
    } catch (e) {
      print("❌ Lỗi khi xóa sản phẩm: $e");
    }
  }

  // 🟢 Cập nhật sản phẩm
  static Future<void> updateProduct(Product product) async {
    try {
      await productCollection.updateOne(
        {"_id": ObjectId.parse(product.id)},
        {
          "\$set": {
            'loaisp': product.loaisp,
            'gia': product.gia,
            'hinhanh': product.hinhanh,
          }
        },
      );
      print("✅ Cập nhật sản phẩm thành công");
    } catch (e) {
      print("❌ Lỗi khi cập nhật sản phẩm: $e");
    }
  }
}
