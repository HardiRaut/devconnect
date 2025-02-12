class AppwriteConstants {
  static const String databaseId = '67963c41003a0666bdce';
  static const String projectId = '67963491002fa613cc13';
  static const String apiEndpoint = 'https://cloud.appwrite.io/v1';
  static const String usersCollection = '67a727ec000df7b29a01';
  static const String postsCollection = '67a82ab0002704193f95';
  static const String imagesBucket = '67a83eba0013005219db';
  static const String notificationsCollection = '67abe0450014ad5dc316';

  static String imageUri(String fileId) {
    return '$apiEndpoint/storage/buckets/$imagesBucket/files/$fileId/view?project=$projectId&mode=admin';
  }
}
