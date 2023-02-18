class NotificationEvent {
  String objectId;
  String authorId;
  NotificationType type;

  NotificationEvent(
    this.objectId,
    this.authorId,
    this.type,
  );
}

enum NotificationType {
  chat,
  mention,
}
