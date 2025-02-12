import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:devconnect/common/loading_page.dart';
import 'package:devconnect/core/utils.dart';
import 'package:devconnect/features/auth/controller/auth_controller.dart';
import 'package:devconnect/features/post/controller/post_controller.dart';
import 'package:devconnect/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePostView(),
      );
  const CreatePostView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePosViewState();
}

class _CreatePosViewState extends ConsumerState<CreatePostView> {
  final postTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    postTextController.dispose();
    super.dispose();
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {
      if (images.isEmpty) {
        showSnackBar(context, 'No images selected');
      } else {
        showSnackBar(context, 'Images selected');
      }
    });
  }

  void sharePost() {
    ref.read(postControllerProvider.notifier).sharePost(
          postText: postTextController.text,
          images: images,
          repliedTo: '',
          context: context,
          repliedToUserId: '',
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(currentUser.profilePic),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: TextField(
                            controller: postTextController,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            decoration: InputDecoration(
                              hintText: 'What\'s on your mind?',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 22,
                                  color: Pallete.greyColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((image) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Image.file(image));
                        }).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: GestureDetector(
                onTap: onPickImages,
                child: Icon(Icons.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: IconButton(
                icon: Icon(Icons.gif_box),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: IconButton(
                icon: Icon(Icons.emoji_emotions),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
