enum NotificationType {
  like('like'),
  reply('reply'),
  follow('follow'),
  reshare('reshare');

  final String type;
  const NotificationType(this.type);
}

extension ConvertTweet on String {
  NotificationType toNotificationTypeEnum() {
    switch (this) {
      case 'reshare':
        return NotificationType.reshare;
      case 'follow':
        return NotificationType.follow;
      case 'reply':
        return NotificationType.reply;
      default:
        return NotificationType.like;
    }
  }
}