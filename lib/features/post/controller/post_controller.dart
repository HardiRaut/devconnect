import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:devconnect/apis/post_api.dart';
import 'package:devconnect/apis/storage_api.dart';
import 'package:devconnect/core/enums/notification_type_enum.dart';
import 'package:devconnect/core/enums/post_type_enum.dart';
import 'package:devconnect/core/utils.dart';
import 'package:devconnect/features/auth/controller/auth_controller.dart';
import 'package:devconnect/features/notifications/controller/notification_controller.dart';
import 'package:devconnect/models/post_model.dart';
import 'package:devconnect/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) {
    return PostController(
      ref: ref,
      postAPI: ref.watch(postAPIProvider),
      storageAPI: ref.watch(storageApiProvider),
      notificationController:
          ref.watch(notificationControllerProvider.notifier),
    );
  },
);

final getPostsProvider = FutureProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts();
});

final getRepliesToPostProvider = FutureProvider.autoDispose.family(
  (ref, Post post) {
    final postController = ref.watch(postControllerProvider.notifier);
    return postController.getRepliesToPost(post);
  },
);

final getLatestPostProvider = StreamProvider((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPost();
});

final getPostByIdProvider = FutureProvider.family((ref, String id) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(id);
});

final getPostsByHashtagProvider = FutureProvider.family((ref, String hashtag) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostsByHashtag(hashtag);
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  final Ref _ref;
  PostController(
      {required Ref ref,
      required PostAPI postAPI,
      required StorageAPI storageAPI,
      required NotificationController notificationController})
      : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPosts();
    final posts = postList.map((post) => Post.fromMap(post.data)).toList();
    return posts;
  }

  Future<Post> getPostById(String id) async {
    final post = await _postAPI.getPostById(id);
    return Post.fromMap(post.data);
  }

  void likePost(Post post, UserModel user) async {
    List<String> likes = post.likes;

    if (post.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    post = post.copyWith(likes: likes);

    final res = await _postAPI.likePost(post);

    res.fold(
      (l) => null,
      (r) => {
        _notificationController.createNotification(
          text: '${user.name} liked your post',
          postId: post.id,
          notificationType: NotificationType.like,
          uid: post.userId,
        )
      },
    );
  }

  void resharePost(
      Post post, UserModel currentUser, BuildContext context) async {
    post = post.copyWith(
      resharedBy: currentUser.name,
      likes: [],
      commentsIds: [],
      resharedCount: post.resharedCount + 1,
    );

    final res = await _postAPI.updateReshareCount(post);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        post = post.copyWith(
          id: ID.unique(),
          resharedCount: 0,
          createdAt: DateTime.now(),
        );
        final res2 = await _postAPI.sharePost(post);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) => _notificationController.createNotification(
            text: '${currentUser.name} reshared your post',
            postId: post.id,
            notificationType: NotificationType.like,
            uid: post.userId,
          ),
        );
      },
    );
  }

  void sharePost({
    required String postText,
    required List<File> images,
    required String repliedTo,
    required BuildContext context,
    required String repliedToUserId,
  }) {
    if (postText.isEmpty) {
      showSnackBar(context, 'Post text cannot be empty');
      return;
    }
    if (images.isNotEmpty) {
      _shareImagePost(
          postText: postText,
          images: images,
          repliedTo: repliedTo,
          context: context,
          repliedToUserId: repliedToUserId);
    } else {
      _shareTextPost(
          postText: postText,
          repliedTo: repliedTo,
          context: context,
          repliedToUserId: repliedToUserId);
    }
  }

  void _shareImagePost(
      {required String postText,
      required List<File> images,
      required String repliedTo,
      required BuildContext context,
      required String repliedToUserId}) async {
    state = true;
    final hashtags = _getHashtagsFromText(postText: postText);
    String link = _getLinkForText(postText: postText);
    final imageUrls = await _storageAPI.uploadImage(images);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Post post = Post(
      text: postText,
      hashtags: hashtags,
      link: link,
      imagesLinks: imageUrls,
      userId: user.uid,
      postType: PostType.image,
      createdAt: DateTime.now(),
      likes: [],
      commentsIds: [],
      id: '',
      resharedCount: 0,
      resharedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} replied to your post',
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;

    // Share image post
  }

  void _shareTextPost(
      {required String postText,
      required String repliedTo,
      required BuildContext context,
      required String repliedToUserId}) async {
    state = true;
    final hashtags = _getHashtagsFromText(postText: postText);
    String link = _getLinkForText(postText: postText);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Post post = Post(
      text: postText,
      hashtags: hashtags,
      link: link,
      imagesLinks: [],
      userId: user.uid,
      postType: PostType.text,
      createdAt: DateTime.now(),
      likes: [],
      commentsIds: [],
      id: '',
      resharedCount: 0,
      resharedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} replied to your post',
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  String _getLinkForText({required String postText}) {
    String link = '';
    List<String> wordsInSentence = postText.split(' ');
    for (final word in wordsInSentence) {
      if (word.startsWith('http') || word.startsWith('www.')) {
        link = word;
        // Share link post
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText({required String postText}) {
    List<String> hashtags = [];
    List<String> wordsInSentence = postText.split(' ');
    for (final word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
        // Share hashtag post
      }
    }
    return hashtags;
  }

  Future<List<Post>> getRepliesToPost(Post post) async {
    final postList = await _postAPI.getRepliesToPost(post);
    final posts = postList.map((post) => Post.fromMap(post.data)).toList();
    return posts;
  }

  Future<List<Post>> getPostsByHashtag(String hashtag) async {
    final postList = await _postAPI.getPostsByHashtag(hashtag);
    final posts = postList.map((post) => Post.fromMap(post.data)).toList();
    return posts;
  }
}
