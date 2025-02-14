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
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends ConsumerState<CreatePostView> {
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
        showSnackBar(context, '${images.length} images selected');
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
          icon: const Icon(Icons.close, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: sharePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(currentUser.profilePic),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: postTextController,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'What\'s on your mind?',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Pallete.greyColor,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map((image) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 300,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.9,
                          enlargeCenterPage: true,
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.image, color: Colors.blue, size: 28),
              onPressed: onPickImages,
            ),
            IconButton(
              icon: const Icon(Icons.gif_box, color: Colors.blue, size: 28),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.emoji_emotions, color: Colors.blue, size: 28),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}