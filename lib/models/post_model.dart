import 'package:flutter/foundation.dart';

import 'package:devconnect/core/enums/post_type_enum.dart';

@immutable
class Post {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imagesLinks;
  final String userId;
  final PostType postType;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentsIds;
  final String id;
  final int resharedCount;
  final String resharedBy;
  final String repliedTo;
  const Post({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imagesLinks,
    required this.userId,
    required this.postType,
    required this.createdAt,
    required this.likes,
    required this.commentsIds,
    required this.id,
    required this.resharedCount,
    required this.resharedBy,
    required this.repliedTo,
  });

  Post copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imagesLinks,
    String? userId,
    PostType? postType,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? commentsIds,
    String? id,
    int? resharedCount,
    String? resharedBy,
    String? repliedTo,
  }) {
    return Post(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imagesLinks: imagesLinks ?? this.imagesLinks,
      userId: userId ?? this.userId,
      postType: postType ?? this.postType,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentsIds: commentsIds ?? this.commentsIds,
      id: id ?? this.id,
      resharedCount: resharedCount ?? this.resharedCount,
      resharedBy: resharedBy ?? this.resharedBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    result.addAll({'link': link});
    result.addAll({'imagesLinks': imagesLinks});
    result.addAll({'userId': userId});
    result.addAll({'postType': postType.type});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'likes': likes});
    result.addAll({'commentsIds': commentsIds});
    result.addAll({'resharedCount': resharedCount});
    result.addAll({'resharedBy': resharedBy});
    result.addAll({'repliedTo': repliedTo});

    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      link: map['link'] ?? '',
      imagesLinks: List<String>.from(map['imagesLinks']),
      userId: map['userId'] ?? '',
      postType: (map['postType'] as String).toPostTypeEnum(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      likes: List<String>.from(map['likes']),
      commentsIds: List<String>.from(map['commentsIds']),
      id: map['\$id'] ?? '',
      resharedCount: map['resharedCount']?.toInt() ?? 0,
      resharedBy: map['resharedBy'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Post(text: $text, hashtags: $hashtags, link: $link, imagesLinks: $imagesLinks, userId: $userId, postType: $postType, createdAt: $createdAt, likes: $likes, commentsIds: $commentsIds, id: $id, resharedCount: $resharedCount, resharedBy: $resharedBy, repliedTo: $repliedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imagesLinks, imagesLinks) &&
        other.userId == userId &&
        other.postType == postType &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentsIds, commentsIds) &&
        other.id == id &&
        other.resharedCount == resharedCount &&
        other.resharedBy == resharedBy &&
        other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imagesLinks.hashCode ^
        userId.hashCode ^
        postType.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        commentsIds.hashCode ^
        id.hashCode ^
        resharedCount.hashCode ^
        resharedBy.hashCode ^
        repliedTo.hashCode;
  }
}
