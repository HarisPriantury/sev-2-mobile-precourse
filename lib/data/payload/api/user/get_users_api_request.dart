import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetUsersApiRequest
    implements GetUsersRequestInterface, ApiRequestInterface {
  List<String>? usernames = [];
  List<String>? emails = [];
  List<String>? names = [];
  List<String>? ids = [];
  int? limit;
  String? after;
  String? nameLike;

  GetUsersApiRequest({
    this.usernames,
    this.emails,
    this.names,
    this.ids,
    this.limit,
    this.after,
    this.nameLike,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['attachments'] = {"availability": true};

    req['constraints'] = {
      'usernames': Map<dynamic, dynamic>(),
      'emails': Map<dynamic, dynamic>(),
      'names': Map<dynamic, dynamic>(),
      'phids': Map<dynamic, dynamic>(),
      'nameLike': this.nameLike,
    };

    if (!this.usernames.isNullOrEmpty()) {
      var dataUsernames = Map<String, String>();
      var counter = 0;
      this.usernames!.asMap().forEach((key, value) {
        if (!dataUsernames.containsValue(value.toString())) {
          dataUsernames[(counter++).toString()] = value;
        }
      });
      req['constraints']['usernames'] = dataUsernames;
    }

    if (!this.emails.isNullOrEmpty()) {
      var dataEmails = Map<String, String>();
      var counter = 0;
      this.emails?.asMap().forEach((key, value) {
        if (!dataEmails.containsValue(value.toString())) {
          dataEmails[(counter++).toString()] = value;
        }
      });
      req['constraints']['emails'] = dataEmails;
    }

    if (!this.names.isNullOrEmpty()) {
      var dataNames = Map<String, String>();
      var counter = 0;
      this.names?.asMap().forEach((key, value) {
        if (!dataNames.containsValue(value.toString())) {
          dataNames[(counter++).toString()] = value;
        }
      });
      req['constraints']['names'] = dataNames;
    }

    if (!this.ids.isNullOrEmpty()) {
      var dataIds = Map<String, String>();
      var counter = 0;
      this.ids?.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['phids'] = dataIds;
    }

    if (limit != null) req['limit'] = this.limit.toString();
    if (after != null && after != "0") req['after'] = this.after;

    return req;
  }
}
