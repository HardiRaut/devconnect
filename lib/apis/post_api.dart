import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:devconnect/constants/appwrite_constants.dart';
import 'package:devconnect/core/core.dart';
import 'package:devconnect/core/providers.dart';
import 'package:devconnect/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(
      db: ref.watch(appwriteDatabaseProvider),
      realtime: ref.watch(appwriteRealtimeProvider));
});

abstract class IPostAPI {
  FutureEither<Document> sharePost(Post post);
  Future<List<Document>> getPosts();
  Stream<RealtimeMessage> getLatestPost();
  FutureEither<Document> likePost(Post post);
  FutureEither<Document> updateReshareCount(Post post);
  Future<List<Document>> getRepliesToPost(Post post);
}

class PostAPI implements IPostAPI {
  final Databases _db;
  final Realtime _realtime;
  PostAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;
  @override
  FutureEither<Document> sharePost(Post post) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollection,
        documentId: ID.unique(),
        data: post.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'An error occurred',
          st,
        ),
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
          StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<List<Document>> getPosts() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollection,
        queries: [Query.orderDesc('createdAt')]);
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestPost() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likePost(Post post) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.postsCollection,
          documentId: post.id,
          data: {
            'likes': post.likes,
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'An error occurred',
          st,
        ),
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
          StackTrace.current,
        ),
      );
    }
  }

  @override
  FutureEither<Document> updateReshareCount(Post post) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.postsCollection,
          documentId: post.id,
          data: {
            'resharedCount': post.resharedCount,
          });
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'An error occurred',
          st,
        ),
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
          StackTrace.current,
        ),
      );
    }
  }

  @override
  Future<List<Document>> getRepliesToPost(Post post) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollection,
      queries: [
        Query.equal('repliedTo', post.id),
      ],
    );
    return document.documents;
  }
}
