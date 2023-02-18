class LanguageChanged {}

class HasUnreadChat {}

class ChatRead {}

class WorkTaskUpdated {
  String? workStatus;
  String? taskName;

  WorkTaskUpdated({this.workStatus, this.taskName});
}
