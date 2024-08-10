import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUploader {
  final Uint8List image;
  ImageUploader({required this.image});
  Future<String?> uploadImage() async {
    try {
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef =
          FirebaseStorage.instance.ref().child('menu/$imageName.jpg');
      var uploadTask = storageRef.putData(image);
      var snapshot = await uploadTask;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
