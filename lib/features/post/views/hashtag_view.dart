import 'package:devconnect/common/common.dart';
import 'package:devconnect/features/post/controller/post_controller.dart';
import 'package:devconnect/features/post/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HashtagView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
        builder: (context) => HashtagView(
          hashtag: hashtag,
        ),
      );
  final String? hashtag;
  const HashtagView({super.key, required this.hashtag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('#$hashtag'),
        ),
        body: ref.watch(getPostsByHashtagProvider(hashtag!)).when(
            data: (posts) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(post: post);
                },
              );
            },
            error: (error, st) => ErrorText(error: error.toString()),
            loading: () => Loader()));
  }
}
