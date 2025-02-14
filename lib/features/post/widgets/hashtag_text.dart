import 'package:devconnect/features/post/views/hashtag_view.dart';
import 'package:devconnect/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({
    super.key,
    required this.text,
  });

  bool isValidUrl(String url) {
    // Regular expression to match URLs
    final urlRegex = RegExp(
      r'^(https?:\/\/)?' // http:// or https://
      r'([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' // domain name
      r'(\/[^\s]*)?$', // path
    );

    return urlRegex.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspans = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  HashtagView.route(element),
                );
              },
          ),
        );
      } else if (isValidUrl(element)) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 18,
            ),
          ),
        );
      } else {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
      }
    });

    return RichText(
      text: TextSpan(
        children: textspans,
      ),
    );
  }
}