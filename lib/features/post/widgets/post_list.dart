import 'dart:math';

import 'package:devconnect/common/common.dart';
import 'package:devconnect/constants/appwrite_constants.dart';
import 'package:devconnect/features/post/controller/post_controller.dart';
import 'package:devconnect/features/post/widgets/post_card.dart';
import 'package:devconnect/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostsProvider).when(
          data: (posts) {
            return ref.watch(getLatestPostProvider).when(
                  data: (data) {
                    if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.postsCollection}.documents.*.create',
                    )) {
                      posts.insert(
                        0,
                        Post.fromMap(data.payload),
                      );
                    } else if (data.events.contains(
                      'databases.*.collections.${AppwriteConstants.postsCollection}.documents.*.update',
                    )) {
                      final startingPoint =
                          data.events[0].lastIndexOf('documents.');

                      final endPoint = data.events[0].lastIndexOf('.update');

                      final postId = data.events[0]
                          .substring(startingPoint + 10, endPoint);

                      var post =
                          posts.where((element) => element.id == postId).first;

                      final postIndex = posts.indexOf(post);

                      posts.removeWhere((element) => element.id == postId);

                      posts.insert(postIndex, post);

                      post = Post.fromMap(data.payload);

                      posts[postIndex] = post;
                    }

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, st) => ErrorText(error: error.toString()),
                  loading: () => ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostCard(post: post);
                    },
                  ),
                );
          },
          error: (error, st) => ErrorText(error: error.toString()),
          loading: () => Loader(),
        );
  }
}
