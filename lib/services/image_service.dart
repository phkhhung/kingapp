import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }

  static Future<String> saveImageToLocal(File imageFile, String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/$imageName.jpg';
    File savedFile = await imageFile.copy(path);
    return savedFile.path;
  }
}
