import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:devconnect/constants/constants.dart';
import 'package:devconnect/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Provider<StorageAPI> storageApiProvider = Provider((ref) {
  final storage = ref.read(appwriteStorageProvider);
  return StorageAPI(storage: storage);
});

class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageUrls = [];
    for (var file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      imageUrls.add(AppwriteConstants.imageUri(uploadedImage.$id));
    }
    return imageUrls;
  }
}
