class Endpoints {
  String baseUrl;

  Endpoints(this.baseUrl);

  String login() {
    return 'auth.login';
  }

  String register() {
    return 'auth.register';
  }

  String createOrUpdateRoom() {
    return 'conpherence.edit';
  }

  String deleteRoom() {
    return 'conpherence.deletethread';
  }

  String rooms() {
    return 'conpherence.querythread';
  }

  String sendChats() {
    return 'conpherence.newtransaction';
  }

  String chats() {
    return 'conpherence.transactions';
  }

  String getMessages() {
    return 'conpherence.querytransaction';
  }

  String getParticipants() {
    return 'conpherence.participant.list';
  }

  String deleteMessage() {
    return 'conpherence.deletetransaction';
  }

  String projects() {
    return 'project.search';
  }

  String projectColumns() {
    return 'project.column.search';
  }

  String projectColumnTicket() {
    return 'project.column.maniphest';
  }

  String moveTicket() {
    return 'project.column.maniphest.move';
  }

  String editColumn() {
    return 'project.column.edit';
  }

  String reorderColumn() {
    return 'project.column.order';
  }

  String createColumn() {
    return 'project.column.create';
  }

  String createMilestone() {
    return 'project.milestone.create';
  }

  String setProjectStatus() {
    return 'project.status';
  }

  String jobs() {
    return 'job.posting.search';
  }

  String jobApplicants() {
    return 'job.applicants.list';
  }

  String tickets() {
    return 'maniphest.search';
  }

  String ticketInfo() {
    return 'maniphest.info';
  }

  String createTicket() {
    return 'maniphest.edit';
  }

  String users() {
    return 'user.search';
  }

  String editUser() {
    return 'user.edit';
  }

  String editAvatarUser() {
    return 'user.avatar';
  }

  String getUserContributions() {
    return 'user.contribution';
  }

  String profile() {
    return 'user.whoami';
  }

  String feeds() {
    return 'feed.search';
  }

  String faqs() {
    return 'ponder.question.search';
  }

  String policies() {
    return 'policy.list';
  }

  String spaces() {
    return 'space.list';
  }

  String objects() {
    return 'phid.query';
  }

  String objectTransactions() {
    return 'transaction.search';
  }

  String storyPoint() {
    return 'suite.rsp.info';
  }

  String notifications() {
    return 'suite.notifications';
  }

  String notificationsMarkAllRead() {
    return 'suite.notifications.mark_all_read';
  }

  String mentions() {
    return 'mention.search';
  }

  String suiteProfile() {
    return 'suite.profile.info';
  }

  String files() {
    return 'file.search';
  }

  String filePrepare() {
    return 'file.allocate';
  }

  String fileUpload() {
    return 'file.upload';
  }

  // lobby
  String lobbyHQ() {
    return 'lobby.room.hq';
  }

  String lobbyParticipants() {
    return 'lobby.participant.list';
  }

  String lobbyRooms() {
    return 'lobby.room.list';
  }

  String lobbyUpdateStatus() {
    return 'lobby.update.status';
  }

  String lobbyJoin() {
    return 'lobby.join';
  }

  String lobbyLeaveWork() {
    return 'lobby.leave.work';
  }

  String lobbyJoinChannel() {
    return 'lobby.join.channel';
  }

  String lobbyWorkOnTask() {
    return 'lobby.work.on.task';
  }

  String lobbyRoomFiles() {
    return 'lobby.conph.file';
  }

  String lobbyRoomCalendar() {
    return 'lobby.conph.calendar';
  }

  String lobbyRoomStickit() {
    return 'lobby.conph.stickit';
  }

  String seAsReadStcikit() {
    return 'lobby.stickit.setasread';
  }

  String createStickit() {
    return 'lobby.stickit.edit';
  }

  String createCalendar() {
    return 'calendar.event.edit';
  }

  String joinEvent() {
    return 'calendar.event.join';
  }

  String getEvents() {
    return 'calendar.event.search';
  }

  String lobbyRoomTasks() {
    return 'lobby.conph.task';
  }

  String lobbyStatus() {
    return 'lobby.status';
  }

  String reactions() {
    return 'token.query';
  }

  String giveReactions() {
    return 'token.give';
  }

  String objectReactions() {
    return 'token.given';
  }

  String restoreRoom() {
    return 'conpherence.restorethread';
  }

  // flag
  String getFlags() {
    return 'flag.query';
  }

  String createFlag() {
    return 'flag.edit';
  }

  String deleteFlag() {
    return 'flag.delete';
  }

  // auth
  String token() {
    return 'exchange-id-token/';
  }

  String sendMood() {
    return 'mood.edit';
  }

  String getMoods() {
    return 'mood.search';
  }

  String createOrUpdateProject() {
    return 'project.edit';
  }

  String getStickits() {
    return 'lobby.stickit.search';
  }

  String checkin() {
    return 'user.checkin';
  }

  String deleteAccount() {
    return 'user.destroy';
  }

  String getWikis() {
    return 'phriction.content.search';
  }
}
