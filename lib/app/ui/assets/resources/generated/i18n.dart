// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'messages_all.dart';

class S {
 
  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    final localization = Localizations.of<S>(context, S);
    assert(() {
      if (localization == null) {
        throw FlutterError(
            'S requested with a context that does not include S.');
      }
      return true;
    }());
    return localization!;
  }
  
  static Future<S> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new S();
    });
  }
  
  String get action_task_add_merged_task {
    return Intl.message("Merge Another Task", name: 'action_task_add_merged_task');
  }

  String get action_task_add_subtask {
    return Intl.message("Add Subtask", name: 'action_task_add_subtask');
  }

  String get action_task_delete_merged_task_subtitle {
    return Intl.message("Tasks that have been removed cannot be returned, do you want to continue?", name: 'action_task_delete_merged_task_subtitle');
  }

  String get action_task_delete_merged_task_title {
    return Intl.message("Remove Merged Task?", name: 'action_task_delete_merged_task_title');
  }

  String get action_task_delete_subtask_subtitle {
    return Intl.message("Subtasks that have been removed cannot be returned, do you want to continue?", name: 'action_task_delete_subtask_subtitle');
  }

  String get action_task_delete_subtask_title {
    return Intl.message("Remove Subtask?", name: 'action_task_delete_subtask_title');
  }

  String get action_task_empty_merged_task {
    return Intl.message("No merged task yet", name: 'action_task_empty_merged_task');
  }

  String get action_task_empty_subtask {
    return Intl.message("No subtask yet", name: 'action_task_empty_subtask');
  }

  String get action_task_selected_merged_task {
    return Intl.message("Merged Task", name: 'action_task_selected_merged_task');
  }

  String get action_task_selected_subtask {
    return Intl.message("Selected Subtask", name: 'action_task_selected_subtask');
  }

  String get add_action_add_assignee_success {
    return Intl.message("Receiver successfully added", name: 'add_action_add_assignee_success');
  }

  String get add_action_add_label {
    return Intl.message("Add Label", name: 'add_action_add_label');
  }

  String get add_action_add_label_success {
    return Intl.message("Labels successfully added", name: 'add_action_add_label_success');
  }

  String get add_action_add_receiver {
    return Intl.message("Add Receiver", name: 'add_action_add_receiver');
  }

  String get add_action_add_subsciber {
    return Intl.message("Add Subscriber", name: 'add_action_add_subsciber');
  }

  String get add_action_add_subscriber_success {
    return Intl.message("Subscribers successfully added", name: 'add_action_add_subscriber_success');
  }

  String get add_action_assign_claim {
    return Intl.message("Assign / Claim", name: 'add_action_assign_claim');
  }

  String get add_action_change_priority {
    return Intl.message("Change Priority", name: 'add_action_change_priority');
  }

  String get add_action_change_project_label {
    return Intl.message("Change Project Label", name: 'add_action_change_project_label');
  }

  String get add_action_change_status {
    return Intl.message("Change Status", name: 'add_action_change_status');
  }

  String get add_action_change_subscribers {
    return Intl.message("Change Subscribers", name: 'add_action_change_subscribers');
  }

  String get add_action_change_success_save {
    return Intl.message("Changes successfully saved", name: 'add_action_change_success_save');
  }

  String get add_action_from_task {
    return Intl.message("from task?", name: 'add_action_from_task');
  }

  String get add_action_move_on_workboard {
    return Intl.message("Move On Workboard", name: 'add_action_move_on_workboard');
  }

  String get add_action_project_label {
    return Intl.message("Project label", name: 'add_action_project_label');
  }

  String get add_action_remove_label_success {
    return Intl.message("Labels successfully deleted", name: 'add_action_remove_label_success');
  }

  String get add_action_remove_project_label {
    return Intl.message("Remove Project label", name: 'add_action_remove_project_label');
  }

  String get add_action_remove_receiver {
    return Intl.message("Remove Receiver", name: 'add_action_remove_receiver');
  }

  String get add_action_remove_subscriber_success {
    return Intl.message("Subscribers successfully deleted", name: 'add_action_remove_subscriber_success');
  }

  String get add_action_update_story_point {
    return Intl.message("Update Story Point", name: 'add_action_update_story_point');
  }

  String get already_in_use {
    return Intl.message("already in use", name: 'already_in_use');
  }

  String get app_name {
    return Intl.message("SEV-2", name: 'app_name');
  }

  String get appbar_see_all_label {
    return Intl.message("See All", name: 'appbar_see_all_label');
  }

  String get chat_attach_document_label {
    return Intl.message("File", name: 'chat_attach_document_label');
  }

  String get chat_attach_image_label {
    return Intl.message("Photo", name: 'chat_attach_image_label');
  }

  String get chat_attach_title {
    return Intl.message("Attach", name: 'chat_attach_title');
  }

  String get chat_attach_video_label {
    return Intl.message("Video", name: 'chat_attach_video_label');
  }

  String get chat_comment_box_hint {
    return Intl.message("Add Comment", name: 'chat_comment_box_hint');
  }

  String get chat_has_reported {
    return Intl.message("This message has reported for violating Sev-2 terms of use and/or user policy", name: 'chat_has_reported');
  }

  String get chat_message_box_hint {
    return Intl.message("Write your message", name: 'chat_message_box_hint');
  }

  String get chat_on_download_label {
    return Intl.message("Downloading file...", name: 'chat_on_download_label');
  }

  String get chat_upload_failed_too_large {
    return Intl.message("File size too large. Maximum size is 1 Megabyte", name: 'chat_upload_failed_too_large');
  }

  String get copy_message {
    return Intl.message("Copy", name: 'copy_message');
  }

  String get create_form_assignation_label {
    return Intl.message("Assignation", name: 'create_form_assignation_label');
  }

  String get create_form_assignee_label {
    return Intl.message("Assignee", name: 'create_form_assignee_label');
  }

  String get create_form_date_picker_alert {
    return Intl.message("Select start date and time first", name: 'create_form_date_picker_alert');
  }

  String get create_form_parent_task {
    return Intl.message("Parent Task", name: 'create_form_parent_task');
  }

  String get create_form_participants_label {
    return Intl.message("Participants", name: 'create_form_participants_label');
  }

  String get create_form_participants_select {
    return Intl.message("Select Participants", name: 'create_form_participants_select');
  }

  String get create_form_search_document_label {
    return Intl.message("Search Documents", name: 'create_form_search_document_label');
  }

  String get create_form_search_document_select {
    return Intl.message("Select Documents", name: 'create_form_search_document_select');
  }

  String get create_form_search_project_label {
    return Intl.message("Search Projects", name: 'create_form_search_project_label');
  }

  String get create_form_search_project_select {
    return Intl.message("Select Projects", name: 'create_form_search_project_select');
  }

  String get create_form_search_user_label {
    return Intl.message("Search Users", name: 'create_form_search_user_label');
  }

  String get create_form_search_user_select {
    return Intl.message("Select Users", name: 'create_form_search_user_select');
  }

  String get create_form_subscribers_select {
    return Intl.message("Select Subscribers", name: 'create_form_subscribers_select');
  }

  String get create_form_tags_select {
    return Intl.message("Select Tags", name: 'create_form_tags_select');
  }

  String get create_room_button_title {
    return Intl.message("Create Room", name: 'create_room_button_title');
  }

  String get create_room_member_label {
    return Intl.message("Member", name: 'create_room_member_label');
  }

  String get create_room_name_hint {
    return Intl.message("Write a Group Name", name: 'create_room_name_hint');
  }

  String get create_room_name_label {
    return Intl.message("Group Name", name: 'create_room_name_label');
  }

  String get create_room_title {
    return Intl.message("Create Conversation", name: 'create_room_title');
  }

  String get create_room_topic_hint {
    return Intl.message("Write a Topic", name: 'create_room_topic_hint');
  }

  String get create_room_topic_label {
    return Intl.message("Topic", name: 'create_room_topic_label');
  }

  String get daily_end_page_label {
    return Intl.message("Akhir halaman", name: 'daily_end_page_label');
  }

  String get daily_start_page_label {
    return Intl.message("Mulai Halaman", name: 'daily_start_page_label');
  }

  String get delete_account {
    return Intl.message("Delete Account", name: 'delete_account');
  }

  String get delete_account_confirmation {
    return Intl.message("Your account will be deleted permanently.", name: 'delete_account_confirmation');
  }

  String get delete_message_subtitle {
    return Intl.message("Are you sure you want to delete this message?", name: 'delete_message_subtitle');
  }

  String get detail_project_open_workboard {
    return Intl.message("Open Workboard", name: 'detail_project_open_workboard');
  }

  String get detail_subtask_create_label {
    return Intl.message("Create Sub Task", name: 'detail_subtask_create_label');
  }

  String get detail_subtask_edit_label {
    return Intl.message("Edit Sub Task", name: 'detail_subtask_edit_label');
  }

  String get detail_task_add_mockup_label {
    return Intl.message("Add Mockup", name: 'detail_task_add_mockup_label');
  }

  String get detail_task_duplicates_label {
    return Intl.message("Duplicates", name: 'detail_task_duplicates_label');
  }

  String get detail_task_edit_label {
    return Intl.message("Edit Task", name: 'detail_task_edit_label');
  }

  String get detail_task_graph_label {
    return Intl.message("Task Graph", name: 'detail_task_graph_label');
  }

  String get detail_task_merge_label {
    return Intl.message("Merge Task", name: 'detail_task_merge_label');
  }

  String get detail_task_mocks_label {
    return Intl.message("Mockups", name: 'detail_task_mocks_label');
  }

  String get embrace_empty_label {
    return Intl.message("There is no mentions yet.", name: 'embrace_empty_label');
  }

  String get empty_wiki_description {
    return Intl.message("There are no wikis has created", name: 'empty_wiki_description');
  }

  String get empty_wiki_title {
    return Intl.message("There are no wikis", name: 'empty_wiki_title');
  }

  String get error_date_selected {
    return Intl.message("Date must be selected", name: 'error_date_selected');
  }

  String get error_description_empty {
    return Intl.message("Write a task description", name: 'error_description_empty');
  }

  String get error_description_stickit_empty {
    return Intl.message("Write some description", name: 'error_description_stickit_empty');
  }

  String get error_disconnected {
    return Intl.message("Disconnected", name: 'error_disconnected');
  }

  String get error_invalid_email {
    return Intl.message("Email is invalid", name: 'error_invalid_email');
  }

  String get error_invalid_phone {
    return Intl.message("Phone Number is invalid", name: 'error_invalid_phone');
  }

  String get error_priority_selected {
    return Intl.message("Priority must be selected", name: 'error_priority_selected');
  }

  String get error_server_problem_subtitle {
    return Intl.message("Service temporarily unavailable. Try again later.", name: 'error_server_problem_subtitle');
  }

  String get error_server_problem_title {
    return Intl.message("Server Error", name: 'error_server_problem_title');
  }

  String get error_stickit_type_selected {
    return Intl.message("Type must be selected", name: 'error_stickit_type_selected');
  }

  String get error_title_empty {
    return Intl.message("Title must be filled", name: 'error_title_empty');
  }

  String get feed_empty_title {
    return Intl.message("No recent activity", name: 'feed_empty_title');
  }

  String get label_DONE {
    return Intl.message("DONE", name: 'label_DONE');
  }

  String get label_NO {
    return Intl.message("NO", name: 'label_NO');
  }

  String get label_SEND {
    return Intl.message("SEND", name: 'label_SEND');
  }

  String get label_YES {
    return Intl.message("YES", name: 'label_YES');
  }

  String get label_accessibility {
    return Intl.message("Accessibility", name: 'label_accessibility');
  }

  String get label_active_project {
    return Intl.message("Active Project", name: 'label_active_project');
  }

  String get label_add {
    return Intl.message("Add", name: 'label_add');
  }

  String get label_add_new_bug {
    return Intl.message("New Bug", name: 'label_add_new_bug');
  }

  String get label_add_new_spike {
    return Intl.message("New Spike", name: 'label_add_new_spike');
  }

  String get label_add_new_task {
    return Intl.message("New Task", name: 'label_add_new_task');
  }

  String get label_add_product {
    return Intl.message("Add Product", name: 'label_add_product');
  }

  String get label_agenda {
    return Intl.message("Agenda", name: 'label_agenda');
  }

  String get label_agreement {
    return Intl.message("By clicking Sign In you agree with", name: 'label_agreement');
  }

  String get label_all_project {
    return Intl.message("All Project", name: 'label_all_project');
  }

  String get label_and {
    return Intl.message("and", name: 'label_and');
  }

  String get label_any_blocker {
    return Intl.message("Do you have any blocker?", name: 'label_any_blocker');
  }

  String get label_appearance {
    return Intl.message("Appearance", name: 'label_appearance');
  }

  String get label_archive {
    return Intl.message("Archive", name: 'label_archive');
  }

  String get label_attachment {
    return Intl.message("Attachment", name: 'label_attachment');
  }

  String get label_back {
    return Intl.message("Back", name: 'label_back');
  }

  String get label_branch_task {
    return Intl.message("SubTask", name: 'label_branch_task');
  }

  String get label_button_next {
    return Intl.message("Next", name: 'label_button_next');
  }

  String get label_calendar {
    return Intl.message("Calendar", name: 'label_calendar');
  }

  String get label_calendar_subtitle {
    return Intl.message("List event", name: 'label_calendar_subtitle');
  }

  String get label_cancel {
    return Intl.message("Cancel", name: 'label_cancel');
  }

  String get label_chat_message {
    return Intl.message("Chat/Message", name: 'label_chat_message');
  }

  String get label_check_the_writing {
    return Intl.message("Check the writing of the workspace that you entered.", name: 'label_check_the_writing');
  }

  String get label_city {
    return Intl.message("Kota", name: 'label_city');
  }

  String get label_clear {
    return Intl.message("Clear", name: 'label_clear');
  }

  String get label_close {
    return Intl.message("Close", name: 'label_close');
  }

  String get label_column {
    return Intl.message("Column", name: 'label_column');
  }

  String get label_column_edit {
    return Intl.message("Edit Column", name: 'label_column_edit');
  }

  String get label_comment {
    return Intl.message("Comments", name: 'label_comment');
  }

  String get label_connect_room_chat {
    return Intl.message("Connecting to Chat Room ...", name: 'label_connect_room_chat');
  }

  String get label_connect_sev2_team {
    return Intl.message("Connecting to SEV-2 team ...", name: 'label_connect_sev2_team');
  }

  String get label_contribution {
    return Intl.message("Contribution", name: 'label_contribution');
  }

  String get label_create {
    return Intl.message("Create", name: 'label_create');
  }

  String get label_custom_policy {
    return Intl.message("Custom Policy", name: 'label_custom_policy');
  }

  String get label_daily_feedback_pairing {
    return Intl.message("Feedback For Pairing", name: 'label_daily_feedback_pairing');
  }

  String get label_daily_sharing_pairing {
    return Intl.message("Sharing Information From Pairing", name: 'label_daily_sharing_pairing');
  }

  String get label_daily_summary {
    return Intl.message("Short Summary Book", name: 'label_daily_summary');
  }

  String get label_daily_task {
    return Intl.message("Daily Task", name: 'label_daily_task');
  }

  String get label_dark_mode {
    return Intl.message("Dark Mode", name: 'label_dark_mode');
  }

  String get label_default_system_mode {
    return Intl.message("System Default", name: 'label_default_system_mode');
  }

  String get label_delete {
    return Intl.message("Delete", name: 'label_delete');
  }

  String get label_delete_all {
    return Intl.message("Delete All", name: 'label_delete_all');
  }

  String get label_delivery {
    return Intl.message("Pengiriman", name: 'label_delivery');
  }

  String get label_delivery_address {
    return Intl.message("Alamat Tujuan Pengiriman", name: 'label_delivery_address');
  }

  String get label_delivery_contact {
    return Intl.message("Kontak Pengiriman", name: 'label_delivery_contact');
  }

  String get label_document {
    return Intl.message("Document", name: 'label_document');
  }

  String get label_done {
    return Intl.message("Done", name: 'label_done');
  }

  String get label_edit {
    return Intl.message("Edit", name: 'label_edit');
  }

  String get label_editable_to {
    return Intl.message("Can edited by", name: 'label_editable_to');
  }

  String get label_email_sms {
    return Intl.message("E-mail & SMS", name: 'label_email_sms');
  }

  String get label_enable {
    return Intl.message("Activate", name: 'label_enable');
  }

  String get label_enter {
    return Intl.message("Enter", name: 'label_enter');
  }

  String get label_enter_column_name {
    return Intl.message("Enter column name", name: 'label_enter_column_name');
  }

  String get label_enter_public_space_sev2 {
    return Intl.message("Enter Public Space SEV-2", name: 'label_enter_public_space_sev2');
  }

  String get label_enter_to_join_room {
    return Intl.message("Enter to join this room and participate.", name: 'label_enter_to_join_room');
  }

  String get label_event {
    return Intl.message("Event", name: 'label_event');
  }

  String get label_exit_public_space {
    return Intl.message("Exit Public Space", name: 'label_exit_public_space');
  }

  String get label_faq {
    return Intl.message("FAQ(s)", name: 'label_faq');
  }

  String get label_filter {
    return Intl.message("Filter", name: 'label_filter');
  }

  String get label_found {
    return Intl.message("Found", name: 'label_found');
  }

  String get label_from {
    return Intl.message("from", name: 'label_from');
  }

  String get label_glad_to_hear {
    return Intl.message("Glad to hear from you", name: 'label_glad_to_hear');
  }

  String get label_guest {
    return Intl.message("Guest", name: 'label_guest');
  }

  String get label_have_a_workspace {
    return Intl.message("Already have a workspace?", name: 'label_have_a_workspace');
  }

  String get label_hello {
    return Intl.message("Hello", name: 'label_hello');
  }

  String get label_help_public_space {
    return Intl.message("In the public space, you can ask anything about SEV-2 to the support team, also you can share experiences using SEV-2 with fellow users.", name: 'label_help_public_space');
  }

  String get label_help_soon {
    return Intl.message("we will help you soon", name: 'label_help_soon');
  }

  String get label_here {
    return Intl.message("Here", name: 'label_here');
  }

  String get label_history {
    return Intl.message("History", name: 'label_history');
  }

  String get label_how_day {
    return Intl.message("How was your day?", name: 'label_how_day');
  }

  String get label_ic_bad {
    return Intl.message("Bad", name: 'label_ic_bad');
  }

  String get label_ic_enthusiastic {
    return Intl.message("Enthusiastic", name: 'label_ic_enthusiastic');
  }

  String get label_ic_happy {
    return Intl.message("Happy", name: 'label_ic_happy');
  }

  String get label_ic_sad {
    return Intl.message("Sad", name: 'label_ic_sad');
  }

  String get label_ic_tired {
    return Intl.message("Tired", name: 'label_ic_tired');
  }

  String get label_info {
    return Intl.message("Info", name: 'label_info');
  }

  String get label_join_with {
    return Intl.message("Join With", name: 'label_join_with');
  }

  String get label_joined_project {
    return Intl.message("Joined Project", name: 'label_joined_project');
  }

  String get label_keyword {
    return Intl.message("Keyword", name: 'label_keyword');
  }

  String get label_light_mode {
    return Intl.message("Light Mode", name: 'label_light_mode');
  }

  String get label_list_participants {
    return Intl.message("Member Joined", name: 'label_list_participants');
  }

  String get label_list_subscribers {
    return Intl.message("Subscriber", name: 'label_list_subscribers');
  }

  String get label_list_tags {
    return Intl.message("Tag", name: 'label_list_tags');
  }

  String get label_login {
    return Intl.message("Login", name: 'label_login');
  }

  String get label_logout {
    return Intl.message("Log Out", name: 'label_logout');
  }

  String get label_manage {
    return Intl.message("Manage", name: 'label_manage');
  }

  String get label_member {
    return Intl.message("Member", name: 'label_member');
  }

  String get label_milestone_name {
    return Intl.message("Milestone Name", name: 'label_milestone_name');
  }

  String get label_move {
    return Intl.message("Move", name: 'label_move');
  }

  String get label_move_ticket_to {
    return Intl.message("Move Ticket to", name: 'label_move_ticket_to');
  }

  String get label_next {
    return Intl.message("Next", name: 'label_next');
  }

  String get label_nice_day {
    return Intl.message("Have a nice day", name: 'label_nice_day');
  }

  String get label_no {
    return Intl.message("No", name: 'label_no');
  }

  String get label_no_handphone {
    return Intl.message("No HandPhone", name: 'label_no_handphone');
  }

  String get label_ok {
    return Intl.message("OK", name: 'label_ok');
  }

  String get label_on {
    return Intl.message("ON", name: 'label_on');
  }

  String get label_or {
    return Intl.message("or", name: 'label_or');
  }

  String get label_other {
    return Intl.message("Other", name: 'label_other');
  }

  String get label_outstanding_tasks {
    return Intl.message("Outstanding Tasks", name: 'label_outstanding_tasks');
  }

  String get label_parent_task {
    return Intl.message("Parent Task", name: 'label_parent_task');
  }

  String get label_participant {
    return Intl.message("Participant", name: 'label_participant');
  }

  String get label_participant_empty {
    return Intl.message("No participant", name: 'label_participant_empty');
  }

  String get label_pay_as {
    return Intl.message("You will finish payment as", name: 'label_pay_as');
  }

  String get label_pay_now {
    return Intl.message("Pay Now", name: 'label_pay_now');
  }

  String get label_payment {
    return Intl.message("Payment", name: 'label_payment');
  }

  String get label_personal_data {
    return Intl.message("Personal data", name: 'label_personal_data');
  }

  String get label_phonenumber {
    return Intl.message("Phone Number", name: 'label_phonenumber');
  }

  String get label_pin {
    return Intl.message("Pin", name: 'label_pin');
  }

  String get label_postal_code {
    return Intl.message("Kode Pos", name: 'label_postal_code');
  }

  String get label_price {
    return Intl.message("Price", name: 'label_price');
  }

  String get label_priority {
    return Intl.message("Priority", name: 'label_priority');
  }

  String get label_project {
    return Intl.message("Project", name: 'label_project');
  }

  String get label_project_name {
    return Intl.message("Project Name", name: 'label_project_name');
  }

  String get label_public_space {
    return Intl.message("Public Space", name: 'label_public_space');
  }

  String get label_public_space_sev2 {
    return Intl.message("Public Space SEV-2", name: 'label_public_space_sev2');
  }

  String get label_queries {
    return Intl.message("Queries", name: 'label_queries');
  }

  String get label_question_type {
    return Intl.message("Question type", name: 'label_question_type');
  }

  String get label_recent {
    return Intl.message("Recent", name: 'label_recent');
  }

  String get label_register {
    return Intl.message("Register", name: 'label_register');
  }

  String get label_remove {
    return Intl.message("Remove", name: 'label_remove');
  }

  String get label_rename {
    return Intl.message("Rename", name: 'label_rename');
  }

  String get label_reorder {
    return Intl.message("Reorder", name: 'label_reorder');
  }

  String get label_report {
    return Intl.message("Report", name: 'label_report');
  }

  String get label_room {
    return Intl.message("Room", name: 'label_room');
  }

  String get label_room_not_found {
    return Intl.message("Room not found", name: 'label_room_not_found');
  }

  String get label_save {
    return Intl.message("Save", name: 'label_save');
  }

  String get label_saving {
    return Intl.message("Saving..", name: 'label_saving');
  }

  String get label_search {
    return Intl.message("Search", name: 'label_search');
  }

  String get label_search_empty {
    return Intl.message("No result found", name: 'label_search_empty');
  }

  String get label_select_column {
    return Intl.message("Select Column", name: 'label_select_column');
  }

  String get label_select_one {
    return Intl.message("Select one", name: 'label_select_one');
  }

  String get label_select_project {
    return Intl.message("Select Project", name: 'label_select_project');
  }

  String get label_select_report {
    return Intl.message("Select a report conduct", name: 'label_select_report');
  }

  String get label_sev2_support {
    return Intl.message("Sev-2 Support", name: 'label_sev2_support');
  }

  String get label_shopping_summary {
    return Intl.message("Shopping Summary", name: 'label_shopping_summary');
  }

  String get label_something {
    return Intl.message("Something", name: 'label_something');
  }

  String get label_something_wrong {
    return Intl.message("Something wrong", name: 'label_something_wrong');
  }

  String get label_space {
    return Intl.message("Space", name: 'label_space');
  }

  String get label_start_interacting_in_public_space {
    return Intl.message("Start interacting with everyone in the SEV-2 Public Space room.", name: 'label_start_interacting_in_public_space');
  }

  String get label_status {
    return Intl.message("Status", name: 'label_status');
  }

  String get label_stickit {
    return Intl.message("Stick It", name: 'label_stickit');
  }

  String get label_submit {
    return Intl.message("Save", name: 'label_submit');
  }

  String get label_subscribe {
    return Intl.message("Subscribe", name: 'label_subscribe');
  }

  String get label_subscribed {
    return Intl.message("Subscribed", name: 'label_subscribed');
  }

  String get label_subscriber {
    return Intl.message("Subscribers", name: 'label_subscriber');
  }

  String get label_subscribtion_has_added {
    return Intl.message("Subscription has been added", name: 'label_subscribtion_has_added');
  }

  String get label_success_join {
    return Intl.message("Successfully Joined!", name: 'label_success_join');
  }

  String get label_summary {
    return Intl.message("Summary", name: 'label_summary');
  }

  String get label_tag {
    return Intl.message("Tags", name: 'label_tag');
  }

  String get label_thanks {
    return Intl.message("Thanks for the great contribution", name: 'label_thanks');
  }

  String get label_ticket {
    return Intl.message("Ticket", name: 'label_ticket');
  }

  String get label_ticket_project {
    return Intl.message("Ticket/Project", name: 'label_ticket_project');
  }

  String get label_title {
    return Intl.message("Title", name: 'label_title');
  }

  String get label_tos {
    return Intl.message("Terms of Service", name: 'label_tos');
  }

  String get label_total {
    return Intl.message("Total", name: 'label_total');
  }

  String get label_transfer_bank {
    return Intl.message("Transfer Bank", name: 'label_transfer_bank');
  }

  String get label_type {
    return Intl.message("Type", name: 'label_type');
  }

  String get label_typing_speed {
    return Intl.message("Typing Speed", name: 'label_typing_speed');
  }

  String get label_unreport_title {
    return Intl.message("Cancel Report", name: 'label_unreport_title');
  }

  String get label_unsubscribe {
    return Intl.message("Unsubscribe", name: 'label_unsubscribe');
  }

  String get label_update {
    return Intl.message("Update", name: 'label_update');
  }

  String get label_upload {
    return Intl.message("Upload", name: 'label_upload');
  }

  String get label_upload_attachment {
    return Intl.message("Upload attachment", name: 'label_upload_attachment');
  }

  String get label_user {
    return Intl.message("User", name: 'label_user');
  }

  String get label_username {
    return Intl.message("Username", name: 'label_username');
  }

  String get label_verified {
    return Intl.message("Verified", name: 'label_verified');
  }

  String get label_verify {
    return Intl.message("Verify", name: 'label_verify');
  }

  String get label_virtual_account {
    return Intl.message("Virtual Account", name: 'label_virtual_account');
  }

  String get label_visible_to {
    return Intl.message("Can be seen by", name: 'label_visible_to');
  }

  String get label_welcome_sev2_support {
    return Intl.message("Welcome to SEV-2 Support, we are here to help you.", name: 'label_welcome_sev2_support');
  }

  String get label_what_blocker {
    return Intl.message("Tell us what's your blocker", name: 'label_what_blocker');
  }

  String get label_what_can_help {
    return Intl.message("What can we help?", name: 'label_what_can_help');
  }

  String get label_wiki {
    return Intl.message("Wiki", name: 'label_wiki');
  }

  String get label_work_space {
    return Intl.message("Work Space", name: 'label_work_space');
  }

  String get label_workboard {
    return Intl.message("Workboard", name: 'label_workboard');
  }

  String get label_workspace {
    return Intl.message("Workspace", name: 'label_workspace');
  }

  String get label_workspace_not_found {
    return Intl.message("Workspace Not Found", name: 'label_workspace_not_found');
  }

  String get label_workspaces {
    return Intl.message("Workspaces", name: 'label_workspaces');
  }

  String get label_world {
    return Intl.message("World", name: 'label_world');
  }

  String get label_write {
    return Intl.message("Write", name: 'label_write');
  }

  String get label_write_something {
    return Intl.message("Write something here", name: 'label_write_something');
  }

  String get label_write_you_want_ask {
    return Intl.message("Write what you want to ask.", name: 'label_write_you_want_ask');
  }

  String get label_yes {
    return Intl.message("Yes", name: 'label_yes');
  }

  String get label_yesterday {
    return Intl.message("Yesterday", name: 'label_yesterday');
  }

  String get lobby_active_label {
    return Intl.message("Active", name: 'lobby_active_label');
  }

  String get lobby_add_bookmark_room {
    return Intl.message("Add to Favorite", name: 'lobby_add_bookmark_room');
  }

  String get lobby_edit_room {
    return Intl.message("Edit Room", name: 'lobby_edit_room');
  }

  String get lobby_enter_label {
    return Intl.message("ENTER", name: 'lobby_enter_label');
  }

  String get lobby_inactive_label {
    return Intl.message("Inactive", name: 'lobby_inactive_label');
  }

  String get lobby_join_label {
    return Intl.message("JOIN", name: 'lobby_join_label');
  }

  String get lobby_joining_label {
    return Intl.message("Joining", name: 'lobby_joining_label');
  }

  String get lobby_pilot_label {
    return Intl.message("PILOT", name: 'lobby_pilot_label');
  }

  String get lobby_remove_bookmark_room {
    return Intl.message("Remove from Favorite", name: 'lobby_remove_bookmark_room');
  }

  String get lobby_search_found_placeholder {
    return Intl.message("Show results from ", name: 'lobby_search_found_placeholder');
  }

  String get lobby_search_result {
    return Intl.message("Search results for ", name: 'lobby_search_result');
  }

  String get lobby_title {
    return Intl.message("Refactory Lobby", name: 'lobby_title');
  }

  String get lobby_workspace_label {
    return Intl.message("WORK SPACE", name: 'lobby_workspace_label');
  }

  String get login_as_rsp {
    return Intl.message("Login as RSP", name: 'login_as_rsp');
  }

  String get login_btn_apple_label {
    return Intl.message("Sign in with Apple", name: 'login_btn_apple_label');
  }

  String get login_btn_google_label {
    return Intl.message("Sign in with Google", name: 'login_btn_google_label');
  }

  String get login_contact_us_label {
    return Intl.message("Contact Us", name: 'login_contact_us_label');
  }

  String login_copyright_label(current) {
    return Intl.message("Copyrights © 2017 - ${current} All Rights Reserved by Refactory. Terms of Service / Privacy Policy", name: 'login_copyright_label', args: [current]);
  }

  String get login_email_not_registered {
    return Intl.message("Your Email is not Registered", name: 'login_email_not_registered');
  }

  String get login_exit_workspace_subtitle {
    return Intl.message("Are you sure you want to leave this workspace?", name: 'login_exit_workspace_subtitle');
  }

  String get login_exit_workspace_title {
    return Intl.message("Exit Workspace", name: 'login_exit_workspace_title');
  }

  String get login_forget_password {
    return Intl.message("Forgot Password?", name: 'login_forget_password');
  }

  String get login_no_account_label {
    return Intl.message("Didn't have an account?", name: 'login_no_account_label');
  }

  String get login_now_label {
    return Intl.message("Login Now", name: 'login_now_label');
  }

  String get login_password_error_label {
    return Intl.message("*Password that you entered is incorrect", name: 'login_password_error_label');
  }

  String get login_password_label {
    return Intl.message("Password", name: 'login_password_label');
  }

  String get login_register_now_label {
    return Intl.message("Register Now", name: 'login_register_now_label');
  }

  String get login_unregistered_description {
    return Intl.message("You can register via Refactory SEV-2 or contact our support team", name: 'login_unregistered_description');
  }

  String get login_unverified_subtitle {
    return Intl.message("Contact admin so that you get information regarding your account.", name: 'login_unverified_subtitle');
  }

  String get login_unverified_title {
    return Intl.message("Your account is not yet active", name: 'login_unverified_title');
  }

  String get login_username_error_label {
    return Intl.message("Email or username that you entered is not registered", name: 'login_username_error_label');
  }

  String get login_username_label {
    return Intl.message("Email/Username", name: 'login_username_label');
  }

  String get login_welcome_label {
    return Intl.message("Welcome to", name: 'login_welcome_label');
  }

  String get login_workspace_label {
    return Intl.message("Enter workspace", name: 'login_workspace_label');
  }

  String get login_workspace_not_found_label {
    return Intl.message("Workspace not found", name: 'login_workspace_not_found_label');
  }

  String get login_workspace_signed_label {
    return Intl.message("You are already logged in to this workspace, please enter another workspace", name: 'login_workspace_signed_label');
  }

  String get main_chat_tab_title {
    return Intl.message("Chat", name: 'main_chat_tab_title');
  }

  String get main_feed_tab_title {
    return Intl.message("Activity", name: 'main_feed_tab_title');
  }

  String get main_lobby_tab_title {
    return Intl.message("Lobby", name: 'main_lobby_tab_title');
  }

  String get main_notification_tab_title {
    return Intl.message("Notification", name: 'main_notification_tab_title');
  }

  String get main_profile_tab_title {
    return Intl.message("Profile", name: 'main_profile_tab_title');
  }

  String get main_project_tab_title {
    return Intl.message("Project", name: 'main_project_tab_title');
  }

  String get main_search_tab_title {
    return Intl.message("Search", name: 'main_search_tab_title');
  }

  String get main_task_tab_title {
    return Intl.message("Task", name: 'main_task_tab_title');
  }

  String get member_break_subtitle {
    return Intl.message("Break", name: 'member_break_subtitle');
  }

  String get member_in_channel_subtitle {
    return Intl.message("On Room", name: 'member_in_channel_subtitle');
  }

  String get member_in_lobby_subtitle {
    return Intl.message("In Lobby", name: 'member_in_lobby_subtitle');
  }

  String get member_unavailable_subtitle {
    return Intl.message("Not Available", name: 'member_unavailable_subtitle');
  }

  String get mentioned_you_in_label {
    return Intl.message("mentioned you in", name: 'mentioned_you_in_label');
  }

  String get milestone_active_subtitle {
    return Intl.message("Are you sure you want to activate this milestone?", name: 'milestone_active_subtitle');
  }

  String get milestone_archive_subtitle {
    return Intl.message("Are you sure you want to archive this milestone?", name: 'milestone_archive_subtitle');
  }

  String get mobile_label {
    return Intl.message("MOBILE", name: 'mobile_label');
  }

  String get no_btn_retry_label {
    return Intl.message("RETRY", name: 'no_btn_retry_label');
  }

  String get no_connection_description {
    return Intl.message("Seems your internet connection is disconnected, please reload", name: 'no_connection_description');
  }

  String get no_connection_title {
    return Intl.message("No Connection", name: 'no_connection_title');
  }

  String get notification_embrace_label {
    return Intl.message("Embrace", name: 'notification_embrace_label');
  }

  String get notification_empty_label {
    return Intl.message("Be update to date with mention, react dan reply.", name: 'notification_empty_label');
  }

  String get notification_mark_as_read_label {
    return Intl.message("Mark all as read", name: 'notification_mark_as_read_label');
  }

  String get notification_mention_label {
    return Intl.message("Mention", name: 'notification_mention_label');
  }

  String get notification_stream_label {
    return Intl.message("Stream", name: 'notification_stream_label');
  }

  String get notification_subtitle {
    return Intl.message("Notifications, Streams and Mentions", name: 'notification_subtitle');
  }

  String get notification_title {
    return Intl.message("Notification", name: 'notification_title');
  }

  String get on_board_first_description {
    return Intl.message("Be more productive anywhere with amazing new experiences with SEV-2", name: 'on_board_first_description');
  }

  String get on_board_first_title {
    return Intl.message("Productive From Anywhere With SEV-2", name: 'on_board_first_title');
  }

  String get on_board_login_btn_label {
    return Intl.message("LOGIN", name: 'on_board_login_btn_label');
  }

  String get on_board_second_description {
    return Intl.message("With the amazing features of SEV-2 that will make your collaboration with the team even more exciting", name: 'on_board_second_description');
  }

  String get on_board_second_title {
    return Intl.message("Make Your Collaboration More Fun", name: 'on_board_second_title');
  }

  String get on_board_third_description {
    return Intl.message("Meeting schedules, workflows and everything you need are now just one touch away with SEV-2", name: 'on_board_third_description');
  }

  String get on_board_third_title {
    return Intl.message("Everything In Just One Touch", name: 'on_board_third_title');
  }

  String get previous_room_placeholder_text_1 {
    return Intl.message("You were at", name: 'previous_room_placeholder_text_1');
  }

  String get previous_room_placeholder_text_2 {
    return Intl.message("before back to lobby", name: 'previous_room_placeholder_text_2');
  }

  String get privacy_policy {
    return Intl.message("Privacy Policy", name: 'privacy_policy');
  }

  String get profile_birth_date {
    return Intl.message("Birth Date", name: 'profile_birth_date');
  }

  String get profile_birth_place {
    return Intl.message("Birth Place", name: 'profile_birth_place');
  }

  String get profile_customer_service_label {
    return Intl.message("Contact Us", name: 'profile_customer_service_label');
  }

  String get profile_disturb_label {
    return Intl.message("Don't Disturb", name: 'profile_disturb_label');
  }

  String get profile_duolingo_url {
    return Intl.message("Duolingo", name: 'profile_duolingo_url');
  }

  String get profile_edit_label {
    return Intl.message("Edit Profile", name: 'profile_edit_label');
  }

  String get profile_github_url {
    return Intl.message("Github", name: 'profile_github_url');
  }

  String get profile_hackerrank_url {
    return Intl.message("Hackerrank", name: 'profile_hackerrank_url');
  }

  String get profile_hiring_title {
    return Intl.message("HIRING PARTNER", name: 'profile_hiring_title');
  }

  String get profile_hiring_total_hired {
    return Intl.message("Total Hired", name: 'profile_hiring_total_hired');
  }

  String get profile_hiring_total_job_posting {
    return Intl.message("Active Job Vacancies", name: 'profile_hiring_total_job_posting');
  }

  String get profile_join_date_label {
    return Intl.message("Join date", name: 'profile_join_date_label');
  }

  String get profile_linkedin_url {
    return Intl.message("LinkedIn", name: 'profile_linkedin_url');
  }

  String get profile_logout_dialog_subtitle {
    return Intl.message("Are you sure you want to leave? If so, press \"Log out\" to proceed.", name: 'profile_logout_dialog_subtitle');
  }

  String get profile_logout_dialog_title {
    return Intl.message("Logging out?", name: 'profile_logout_dialog_title');
  }

  String get profile_logout_label {
    return Intl.message("Log Out", name: 'profile_logout_label');
  }

  String get profile_logout_title {
    return Intl.message("Are you sure want to exit?", name: 'profile_logout_title');
  }

  String get profile_profile_display_name_label {
    return Intl.message("Display Name", name: 'profile_profile_display_name_label');
  }

  String get profile_profile_email_label {
    return Intl.message("Email", name: 'profile_profile_email_label');
  }

  String get profile_profile_info_title {
    return Intl.message("PROFILE INFO", name: 'profile_profile_info_title');
  }

  String get profile_profile_name_label {
    return Intl.message("Name", name: 'profile_profile_name_label');
  }

  String get profile_profile_phone_label {
    return Intl.message("Phone/WA", name: 'profile_profile_phone_label');
  }

  String get profile_profile_second_phone_label {
    return Intl.message("Phone/WA 2", name: 'profile_profile_second_phone_label');
  }

  String get profile_project_info_label {
    return Intl.message("PROJECT INFO", name: 'profile_project_info_label');
  }

  String get profile_project_joined_label {
    return Intl.message("Project joined", name: 'profile_project_joined_label');
  }

  String get profile_project_title {
    return Intl.message("PROJECT", name: 'profile_project_title');
  }

  String get profile_project_total_finished_story_point {
    return Intl.message("Total Finished Story Point", name: 'profile_project_total_finished_story_point');
  }

  String get profile_project_total_project {
    return Intl.message("Total Ongoing Project", name: 'profile_project_total_project');
  }

  String get profile_project_total_remaining_deposit {
    return Intl.message("Remaining Story Point Deposit", name: 'profile_project_total_remaining_deposit');
  }

  String get profile_project_total_story_point {
    return Intl.message("Total Ongoing Story Point", name: 'profile_project_total_story_point');
  }

  String get profile_room_bookmark_label {
    return Intl.message("Room Bookmark", name: 'profile_room_bookmark_label');
  }

  String get profile_set_status_label {
    return Intl.message("Set Status", name: 'profile_set_status_label');
  }

  String get profile_set_time_label {
    return Intl.message("Set Time", name: 'profile_set_time_label');
  }

  String get profile_setting_label {
    return Intl.message("Setting", name: 'profile_setting_label');
  }

  String get profile_stackoverflow_url {
    return Intl.message("StackOverflow", name: 'profile_stackoverflow_url');
  }

  String get profile_status_bathroom_label {
    return Intl.message("Bathroom", name: 'profile_status_bathroom_label');
  }

  String get profile_status_description_label {
    return Intl.message("DESCRIPTION", name: 'profile_status_description_label');
  }

  String get profile_status_description_placeholder {
    return Intl.message("Describe your activities", name: 'profile_status_description_placeholder');
  }

  String get profile_status_family_label {
    return Intl.message("Family Thing", name: 'profile_status_family_label');
  }

  String get profile_status_lunch_label {
    return Intl.message("Lunch", name: 'profile_status_lunch_label');
  }

  String get profile_status_me_time_label {
    return Intl.message("Me Time!", name: 'profile_status_me_time_label');
  }

  String get profile_status_other_label {
    return Intl.message("Other", name: 'profile_status_other_label');
  }

  String get profile_status_placeholder {
    return Intl.message("What's Your Status", name: 'profile_status_placeholder');
  }

  String get profile_status_praying_label {
    return Intl.message("Praying", name: 'profile_status_praying_label');
  }

  String get profile_status_time_clear_label {
    return Intl.message("REMOVE AFTER", name: 'profile_status_time_clear_label');
  }

  String get profile_story_point_finished_label {
    return Intl.message("Finished Story Point", name: 'profile_story_point_finished_label');
  }

  String get profile_story_point_income_label {
    return Intl.message("Total Income", name: 'profile_story_point_income_label');
  }

  String get profile_story_point_title {
    return Intl.message("Story Point", name: 'profile_story_point_title');
  }

  String get profile_story_point_withdrawable_label {
    return Intl.message("Total Redeemable Income", name: 'profile_story_point_withdrawable_label');
  }

  String get profile_subscription_expires_label {
    return Intl.message("Expires Date", name: 'profile_subscription_expires_label');
  }

  String get profile_subscription_info_title {
    return Intl.message("SUBSCRIPTION", name: 'profile_subscription_info_title');
  }

  String get profile_subscription_status_label {
    return Intl.message("Subscription Status", name: 'profile_subscription_status_label');
  }

  String get profile_subtitle {
    return Intl.message("User information detail", name: 'profile_subtitle');
  }

  String get profile_team_label {
    return Intl.message("Team", name: 'profile_team_label');
  }

  String get profile_time1_label {
    return Intl.message("30 Minutes", name: 'profile_time1_label');
  }

  String get profile_time2_label {
    return Intl.message("1 Hour", name: 'profile_time2_label');
  }

  String get profile_time3_label {
    return Intl.message("4 Hours", name: 'profile_time3_label');
  }

  String get profile_time4_label {
    return Intl.message("All Day", name: 'profile_time4_label');
  }

  String get profile_time5_label {
    return Intl.message("Not Clear", name: 'profile_time5_label');
  }

  String get profile_work_info_joined_date_label {
    return Intl.message("Joined Data", name: 'profile_work_info_joined_date_label');
  }

  String get profile_work_info_occupation_label {
    return Intl.message("Occupation", name: 'profile_work_info_occupation_label');
  }

  String get profile_work_info_title {
    return Intl.message("JOB INFO", name: 'profile_work_info_title');
  }

  String get profile_your_status_label {
    return Intl.message("Your current Status", name: 'profile_your_status_label');
  }

  String get project_active_subtitle {
    return Intl.message("Are you sure you want to activate this project?", name: 'project_active_subtitle');
  }

  String get project_archive_label {
    return Intl.message("Archive", name: 'project_archive_label');
  }

  String get project_archive_subtitle {
    return Intl.message("Are you sure you want to archive this project?", name: 'project_archive_subtitle');
  }

  String get project_created_successfully {
    return Intl.message("Project created successfully", name: 'project_created_successfully');
  }

  String get project_description_hint {
    return Intl.message("Enter description", name: 'project_description_hint');
  }

  String get project_edit_label {
    return Intl.message("Edit Project", name: 'project_edit_label');
  }

  String get project_kanban_view {
    return Intl.message("Kanban View", name: 'project_kanban_view');
  }

  String get project_list_view {
    return Intl.message("List View", name: 'project_list_view');
  }

  String get project_member_edit_label {
    return Intl.message("Edit Member", name: 'project_member_edit_label');
  }

  String project_milestone_day_left(day) {
    return Intl.message("${day} day(s) left", name: 'project_milestone_day_left', args: [day]);
  }

  String get project_milestone_end {
    return Intl.message("Has Ended", name: 'project_milestone_end');
  }

  String get project_milestone_label {
    return Intl.message("Milestone", name: 'project_milestone_label');
  }

  String get project_name_hint {
    return Intl.message("Project name", name: 'project_name_hint');
  }

  String get project_sub_project_label {
    return Intl.message("Subproject", name: 'project_sub_project_label');
  }

  String get project_subtitle {
    return Intl.message("List of ongoing projects", name: 'project_subtitle');
  }

  String get query_delete_subtitle {
    return Intl.message("Deleted queries cannot be returned, do you want to continue?", name: 'query_delete_subtitle');
  }

  String get query_delete_title {
    return Intl.message("Delete Query?", name: 'query_delete_title');
  }

  String get query_global_label {
    return Intl.message("Global Queries", name: 'query_global_label');
  }

  String get query_personal_label {
    return Intl.message("Personal Queries", name: 'query_personal_label');
  }

  String get query_title {
    return Intl.message("Queries", name: 'query_title');
  }

  String get refactory_name {
    return Intl.message("Refactory", name: 'refactory_name');
  }

  String get register_account_success_subtitle {
    return Intl.message("Congratulations! Your account has been created successfully.\nAdmin will carry out the verification process immediately.", name: 'register_account_success_subtitle');
  }

  String get register_account_success_title {
    return Intl.message("Your Account Has Been Created", name: 'register_account_success_title');
  }

  String get register_email_label {
    return Intl.message("E-mail", name: 'register_email_label');
  }

  String get register_full_name_label {
    return Intl.message("Full Name", name: 'register_full_name_label');
  }

  String get register_has_account_label {
    return Intl.message("Have an account?", name: 'register_has_account_label');
  }

  String get register_join_suite_label {
    return Intl.message("Join with SEV-2", name: 'register_join_suite_label');
  }

  String get register_login_now_label {
    return Intl.message("Login now", name: 'register_login_now_label');
  }

  String get register_password_confirmation_error_label {
    return Intl.message("*Password must be the same", name: 'register_password_confirmation_error_label');
  }

  String get register_password_confirmation_label {
    return Intl.message("Password Confirmation", name: 'register_password_confirmation_label');
  }

  String get register_password_label {
    return Intl.message("Password", name: 'register_password_label');
  }

  String get register_password_validation_label {
    return Intl.message("*Password must consist of 8 characters", name: 'register_password_validation_label');
  }

  String get register_username_label {
    return Intl.message("Username", name: 'register_username_label');
  }

  String get reminder_open_ticket_placeholder_text_1 {
    return Intl.message("Today you have", name: 'reminder_open_ticket_placeholder_text_1');
  }

  String get reminder_open_ticket_placeholder_text_2 {
    return Intl.message("Open at", name: 'reminder_open_ticket_placeholder_text_2');
  }

  String get report_option_harassment {
    return Intl.message("Gangguan", name: 'report_option_harassment');
  }

  String get report_option_nudity {
    return Intl.message("Ketelanjangan", name: 'report_option_nudity');
  }

  String get report_option_other {
    return Intl.message("Lainnya", name: 'report_option_other');
  }

  String get report_option_spam {
    return Intl.message("Spam", name: 'report_option_spam');
  }

  String get report_this_message {
    return Intl.message("Report this message", name: 'report_this_message');
  }

  String get report_unhide_message {
    return Intl.message("Unhide this message", name: 'report_unhide_message');
  }

  String get restore {
    return Intl.message("Restore", name: 'restore');
  }

  String get restoreRoom {
    return Intl.message("Kembalikan Room", name: 'restoreRoom');
  }

  String get role_email_unverified {
    return Intl.message("Email Unverified", name: 'role_email_unverified');
  }

  String get role_reported_user {
    return Intl.message("Reported", name: 'role_reported_user');
  }

  String get role_unapproved {
    return Intl.message("Unapproved", name: 'role_unapproved');
  }

  String get role_user_disabled {
    return Intl.message("Disabled", name: 'role_user_disabled');
  }

  String get room_calendar_all_day {
    return Intl.message("All Day", name: 'room_calendar_all_day');
  }

  String get room_calendar_choose_date {
    return Intl.message("Set Date", name: 'room_calendar_choose_date');
  }

  String get room_calendar_choose_time {
    return Intl.message("Set Time", name: 'room_calendar_choose_time');
  }

  String get room_calendar_enddate {
    return Intl.message("End Date", name: 'room_calendar_enddate');
  }

  String get room_calendar_label {
    return Intl.message("Calendar", name: 'room_calendar_label');
  }

  String get room_calendar_startdate {
    return Intl.message("Start Date", name: 'room_calendar_startdate');
  }

  String get room_create_event_label {
    return Intl.message("Create Event", name: 'room_create_event_label');
  }

  String get room_delete_conversation_subtitle {
    return Intl.message("Are you sure you want to delete this room?", name: 'room_delete_conversation_subtitle');
  }

  String get room_delete_conversation_title {
    return Intl.message("Delete Room?", name: 'room_delete_conversation_title');
  }

  String get room_delete_message_title {
    return Intl.message("Delete Message", name: 'room_delete_message_title');
  }

  String get room_detail_add_action {
    return Intl.message("Add Action", name: 'room_detail_add_action');
  }

  String get room_detail_add_member_label {
    return Intl.message("Add member", name: 'room_detail_add_member_label');
  }

  String get room_detail_assigned_label {
    return Intl.message("Assigned to", name: 'room_detail_assigned_label');
  }

  String get room_detail_attended_by_label {
    return Intl.message("Attended by", name: 'room_detail_attended_by_label');
  }

  String get room_detail_attended_label {
    return Intl.message("Joined", name: 'room_detail_attended_label');
  }

  String get room_detail_authored_by_label {
    return Intl.message("Created by", name: 'room_detail_authored_by_label');
  }

  String get room_detail_comment_hint {
    return Intl.message("Write Something", name: 'room_detail_comment_hint');
  }

  String get room_detail_declined_label {
    return Intl.message("Declined", name: 'room_detail_declined_label');
  }

  String get room_detail_description_label {
    return Intl.message("Description", name: 'room_detail_description_label');
  }

  String get room_detail_detail_empty_subtitle {
    return Intl.message("No data available for this section.", name: 'room_detail_detail_empty_subtitle');
  }

  String get room_detail_detail_empty_title {
    return Intl.message("Data is Empty", name: 'room_detail_detail_empty_title');
  }

  String get room_detail_download_label {
    return Intl.message("Download", name: 'room_detail_download_label');
  }

  String get room_detail_file_uploader_label {
    return Intl.message("Uploader", name: 'room_detail_file_uploader_label');
  }

  String get room_detail_files_title {
    return Intl.message("Files", name: 'room_detail_files_title');
  }

  String get room_detail_information_label {
    return Intl.message("Information", name: 'room_detail_information_label');
  }

  String get room_detail_invited_by_label {
    return Intl.message("Invited", name: 'room_detail_invited_by_label');
  }

  String get room_detail_label {
    return Intl.message("More", name: 'room_detail_label');
  }

  String get room_detail_links_title {
    return Intl.message("Links", name: 'room_detail_links_title');
  }

  String get room_detail_media_title {
    return Intl.message("Media", name: 'room_detail_media_title');
  }

  String get room_detail_member_title {
    return Intl.message("Participant", name: 'room_detail_member_title');
  }

  String get room_detail_open_file_label {
    return Intl.message("Open File", name: 'room_detail_open_file_label');
  }

  String get room_detail_recent_activities {
    return Intl.message("Recent activities", name: 'room_detail_recent_activities');
  }

  String get room_detail_seen_by_label {
    return Intl.message("Seen by", name: 'room_detail_seen_by_label');
  }

  String get room_detail_tags_label {
    return Intl.message("Tags", name: 'room_detail_tags_label');
  }

  String get room_detail_upload_label {
    return Intl.message("Upload File", name: 'room_detail_upload_label');
  }

  String get room_detail_written_by_label {
    return Intl.message("Authored by", name: 'room_detail_written_by_label');
  }

  String get room_empty_calendar_description {
    return Intl.message("There are no events in the room you are following", name: 'room_empty_calendar_description');
  }

  String get room_empty_calendar_title {
    return Intl.message("There is no Events", name: 'room_empty_calendar_title');
  }

  String get room_empty_file_description {
    return Intl.message("There are no files in the room you are following", name: 'room_empty_file_description');
  }

  String get room_empty_file_title {
    return Intl.message("There is no Files", name: 'room_empty_file_title');
  }

  String get room_empty_stickit_description {
    return Intl.message("There are no stickits in the room you are following", name: 'room_empty_stickit_description');
  }

  String get room_empty_stickit_title {
    return Intl.message("There is no Stickits", name: 'room_empty_stickit_title');
  }

  String get room_empty_task_description {
    return Intl.message("There are no tasks in the room you are following", name: 'room_empty_task_description');
  }

  String get room_empty_task_title {
    return Intl.message("There is no Tasks", name: 'room_empty_task_title');
  }

  String get room_hosted_by_label {
    return Intl.message("Host", name: 'room_hosted_by_label');
  }

  String get room_member_label {
    return Intl.message("Member", name: 'room_member_label');
  }

  String get room_search_conversation {
    return Intl.message("Search conversation", name: 'room_search_conversation');
  }

  String get room_subtitle {
    return Intl.message("Connect with all members", name: 'room_subtitle');
  }

  String get rooms_document_label {
    return Intl.message("Document", name: 'rooms_document_label');
  }

  String get rooms_empty_title {
    return Intl.message("You haven't joined any group chat yet", name: 'rooms_empty_title');
  }

  String get rooms_leave_group_label {
    return Intl.message("Delete Chat", name: 'rooms_leave_group_label');
  }

  String get rooms_member_label {
    return Intl.message("Member", name: 'rooms_member_label');
  }

  String get rooms_pin_chat_label {
    return Intl.message("Pin Chat", name: 'rooms_pin_chat_label');
  }

  String get rooms_start_chat {
    return Intl.message("Start new conversation!", name: 'rooms_start_chat');
  }

  String get search_advance_label {
    return Intl.message("Advanced Search", name: 'search_advance_label');
  }

  String get search_choose_group_user_label {
    return Intl.message("Select group or user", name: 'search_choose_group_user_label');
  }

  String get search_choose_room {
    return Intl.message("Select room", name: 'search_choose_room');
  }

  String get search_data_not_found_description {
    return Intl.message("Try to use other keyword", name: 'search_data_not_found_description');
  }

  String get search_data_not_found_title {
    return Intl.message("Data Not Found", name: 'search_data_not_found_title');
  }

  String get search_document_status_label {
    return Intl.message("Document Status", name: 'search_document_status_label');
  }

  String get search_document_type_label {
    return Intl.message("Document Type", name: 'search_document_type_label');
  }

  String get search_followed_by_label {
    return Intl.message("Followed by", name: 'search_followed_by_label');
  }

  String get search_found_placeholder {
    return Intl.message("Show results for ", name: 'search_found_placeholder');
  }

  String get search_queries_name {
    return Intl.message("Queries Name", name: 'search_queries_name');
  }

  String get search_subtitle {
    return Intl.message("Find something here", name: 'search_subtitle');
  }

  String get select_project_accessibility {
    return Intl.message("Select Project Accessibility!", name: 'select_project_accessibility');
  }

  String get setting_account_datetime {
    return Intl.message("Date and Time", name: 'setting_account_datetime');
  }

  String get setting_account_email {
    return Intl.message("Email", name: 'setting_account_email');
  }

  String get setting_account_language {
    return Intl.message("Language", name: 'setting_account_language');
  }

  String get setting_account_phone {
    return Intl.message("Phone Number", name: 'setting_account_phone');
  }

  String get setting_account_subtitle {
    return Intl.message("Date and Time, Language, Phone, E-mail", name: 'setting_account_subtitle');
  }

  String get setting_account_title {
    return Intl.message("Account", name: 'setting_account_title');
  }

  String get setting_allow_background_permission {
    return Intl.message("Allow SEV-2 run on background", name: 'setting_allow_background_permission');
  }

  String get setting_app_version {
    return Intl.message("App Version", name: 'setting_app_version');
  }

  String get setting_contact_us_subtitle {
    return Intl.message("Help, Complaints and Suggestions", name: 'setting_contact_us_subtitle');
  }

  String get setting_contact_us_title {
    return Intl.message("Contact Us", name: 'setting_contact_us_title');
  }

  String setting_copyright_label(current) {
    return Intl.message("Copyright © ${current}", name: 'setting_copyright_label', args: [current]);
  }

  String get setting_data_empty {
    return Intl.message("Data Still Empty", name: 'setting_data_empty');
  }

  String get setting_data_empty_subtitle {
    return Intl.message("No data has yet been obtained. Please try again later", name: 'setting_data_empty_subtitle');
  }

  String get setting_datetime_choose_timezone {
    return Intl.message("Choose Your Timezone", name: 'setting_datetime_choose_timezone');
  }

  String get setting_datetime_dateformat {
    return Intl.message("Date Format", name: 'setting_datetime_dateformat');
  }

  String get setting_datetime_startweek {
    return Intl.message("Set Start of Week", name: 'setting_datetime_startweek');
  }

  String get setting_datetime_timeformat {
    return Intl.message("Time Format", name: 'setting_datetime_timeformat');
  }

  String get setting_email_add_label {
    return Intl.message("Add E-mail", name: 'setting_email_add_label');
  }

  String get setting_email_address_input_label {
    return Intl.message("Insert your E-mail address", name: 'setting_email_address_input_label');
  }

  String get setting_email_address_label {
    return Intl.message("E-mail address", name: 'setting_email_address_label');
  }

  String get setting_email_delete_confirmation {
    return Intl.message("Delete E-mail?", name: 'setting_email_delete_confirmation');
  }

  String get setting_email_delete_description {
    return Intl.message("Deleted Phone E-mail cannot be reverted. Continue?", name: 'setting_email_delete_description');
  }

  String get setting_email_manage_label {
    return Intl.message("Manage E-mail", name: 'setting_email_manage_label');
  }

  String get setting_email_primary_label {
    return Intl.message("Primary Email", name: 'setting_email_primary_label');
  }

  String get setting_email_verification_subtitle {
    return Intl.message("Verify the e-mail you added.", name: 'setting_email_verification_subtitle');
  }

  String get setting_notification_subtitle {
    return Intl.message("Push notification", name: 'setting_notification_subtitle');
  }

  String get setting_notification_title {
    return Intl.message("Notification", name: 'setting_notification_title');
  }

  String get setting_phone_add_description {
    return Intl.message("Tap the three dots in the top right corner to add data.", name: 'setting_phone_add_description');
  }

  String get setting_phone_add_title {
    return Intl.message("Add Phone Number", name: 'setting_phone_add_title');
  }

  String get setting_phone_delete_confirmation {
    return Intl.message("Delete Phone Number?", name: 'setting_phone_delete_confirmation');
  }

  String get setting_phone_delete_description {
    return Intl.message("Deleted Phone Number cannot be reverted. Continue?", name: 'setting_phone_delete_description');
  }

  String get setting_set_primary_label {
    return Intl.message("Set Primary", name: 'setting_set_primary_label');
  }

  String get splash_jailbreak_warning {
    return Intl.message("The application cannot be used on a rooted device", name: 'splash_jailbreak_warning');
  }

  String get splash_screen_footer {
    return Intl.message("POWERED BY REFACTORY", name: 'splash_screen_footer');
  }

  String get status_activity_title {
    return Intl.message("Set Activity", name: 'status_activity_title');
  }

  String get status_adhoc_sentence {
    return Intl.message("Hi there. You can do adhoc tasks such as meetings, discussions or help the team If you are a manager.", name: 'status_adhoc_sentence');
  }

  String get status_adhoc_set_label {
    return Intl.message("SET ADHOC TAK", name: 'status_adhoc_set_label');
  }

  String get status_adhoc_write_label {
    return Intl.message("Write Something", name: 'status_adhoc_write_label');
  }

  String get status_back_to_lobby {
    return Intl.message("Back to Lobby", name: 'status_back_to_lobby');
  }

  String get status_for_refactory_label {
    return Intl.message("FOR REFACTORY", name: 'status_for_refactory_label');
  }

  String get status_just_mingling_label {
    return Intl.message("Just mingling", name: 'status_just_mingling_label');
  }

  String get status_recent_label {
    return Intl.message("RECENT STATUS", name: 'status_recent_label');
  }

  String get status_task_all {
    return Intl.message("All", name: 'status_task_all');
  }

  String get status_task_assigned_to {
    return Intl.message("Assigned to", name: 'status_task_assigned_to');
  }

  String get status_task_assigned_to_me {
    return Intl.message("Assigned to me", name: 'status_task_assigned_to_me');
  }

  String get status_task_available_label {
    return Intl.message("Available Tasks", name: 'status_task_available_label');
  }

  String get status_task_choose_label {
    return Intl.message("Choose Tasks", name: 'status_task_choose_label');
  }

  String get status_task_created_by_me {
    return Intl.message("Created by me", name: 'status_task_created_by_me');
  }

  String get status_task_find_label {
    return Intl.message("Search Tasks", name: 'status_task_find_label');
  }

  String get status_task_open {
    return Intl.message("Open", name: 'status_task_open');
  }

  String get status_task_opened_ticket {
    return Intl.message("Open Ticket", name: 'status_task_opened_ticket');
  }

  String get stickit_type_announcement {
    return Intl.message("Announcement", name: 'stickit_type_announcement');
  }

  String get stickit_type_mom {
    return Intl.message("Minutes of Meeting", name: 'stickit_type_mom');
  }

  String get stickit_type_pitch_idea {
    return Intl.message("Pitch an Idea", name: 'stickit_type_pitch_idea');
  }

  String get stickit_type_praise {
    return Intl.message("Praise", name: 'stickit_type_praise');
  }

  String get stream_empty_label {
    return Intl.message("There is no stream yet.", name: 'stream_empty_label');
  }

  String get subtitle_appearance {
    return Intl.message("Set the appearance of your application", name: 'subtitle_appearance');
  }

  String get subtitle_faq {
    return Intl.message("Frequently Asked Questions", name: 'subtitle_faq');
  }

  String get ticket_bug_reporter {
    return Intl.message("Bug Reported By", name: 'ticket_bug_reporter');
  }

  String get ticket_subtitle {
    return Intl.message("List of ongoing tickets", name: 'ticket_subtitle');
  }

  String get tooltip_lobby_description_1 {
    return Intl.message("Start collaborating with your coworkers by entering the room", name: 'tooltip_lobby_description_1');
  }

  String get tooltip_lobby_description_2 {
    return Intl.message("Swipe left to make changes to your status at work", name: 'tooltip_lobby_description_2');
  }

  String get tooltip_lobby_title_1 {
    return Intl.message("Enter room", name: 'tooltip_lobby_title_1');
  }

  String get tooltip_lobby_title_2 {
    return Intl.message("Set Status", name: 'tooltip_lobby_title_2');
  }

  String get tooltip_lobby_title_idle {
    return Intl.message("I'm idle", name: 'tooltip_lobby_title_idle');
  }

  String get tooltip_status_description_1 {
    return Intl.message("Tap to write down the work you are currently working on or select your task", name: 'tooltip_status_description_1');
  }

  String get tooltip_status_description_2 {
    return Intl.message("Tap to select your status when you are unavailable to work", name: 'tooltip_status_description_2');
  }

  String get tooltip_status_title_1 {
    return Intl.message("Create Status", name: 'tooltip_status_title_1');
  }

  String get tooltip_status_title_2 {
    return Intl.message("Select Status", name: 'tooltip_status_title_2');
  }

  String get tooltip_voice_description_1 {
    return Intl.message("Swipe left or right to change voice mode or send messages", name: 'tooltip_voice_description_1');
  }

  String get tooltip_voice_description_2 {
    return Intl.message("Empower your team with Chats, Tasks, Calendar, Files, Member settings via the room menu", name: 'tooltip_voice_description_2');
  }

  String get tooltip_voice_title_1 {
    return Intl.message("Swipe to change mode", name: 'tooltip_voice_title_1');
  }

  String get tooltip_voice_title_2 {
    return Intl.message("Room Menu", name: 'tooltip_voice_title_2');
  }

  String get tooltip_workspace_description_1 {
    return Intl.message("Manage your virtual office here", name: 'tooltip_workspace_description_1');
  }

  String get tooltip_workspace_description_2 {
    return Intl.message("Manage your world and workspaces here", name: 'tooltip_workspace_description_2');
  }

  String get tooltip_workspace_title_1 {
    return Intl.message("Workspace", name: 'tooltip_workspace_title_1');
  }

  String get tooltip_workspace_title_2 {
    return Intl.message("World", name: 'tooltip_workspace_title_2');
  }

  String get user_blocked_terms {
    return Intl.message("You have reported this user, that means you will also block this user during reporting process", name: 'user_blocked_terms');
  }

  String get user_list_create_group_label {
    return Intl.message("Create Group", name: 'user_list_create_group_label');
  }

  String get user_list_create_message_label {
    return Intl.message("Create New Message", name: 'user_list_create_message_label');
  }

  String user_list_start_label(username) {
    return Intl.message("Start chat with ${username} ?", name: 'user_list_start_label', args: [username]);
  }

  String get user_reporting_terms {
    return Intl.message("By reporting a user, reporter account will also blocks reported user", name: 'user_reporting_terms');
  }

  String get user_undo_report_terms {
    return Intl.message("Unblock user will also cancel on progress report", name: 'user_undo_report_terms');
  }

  String get voice_room_members_label {
    return Intl.message("See Members", name: 'voice_room_members_label');
  }

  String get voice_room_saving_mode {
    return Intl.message("Saving Mode", name: 'voice_room_saving_mode');
  }


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
			Locale("en", ""),
			Locale("id", ""),

    ];
  }

  LocaleListResolutionCallback listResolution({Locale? fallback}) {
    return (List<Locale>? locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale? fallback}) {
    return (Locale? locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale? locale, Locale? fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool isSupported(Locale? locale) =>
    locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

// ignore_for_file: unnecessary_brace_in_string_interps
