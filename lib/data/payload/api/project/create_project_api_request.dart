import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class CreateProjectApiRequest
    implements CreateProjectRequestInterface, ApiRequestInterface {
  CreateProjectApiRequest({
    this.name,
    this.description,
    this.policy,
    this.isForDev = false,
    this.membersPhid,
    this.projectPhid,
    this.objectIdentifier,
    this.parentPhid,
    this.start,
    this.end,
  });

  bool isForDev;
  List<String>? membersPhid;
  String? description, name, policy, projectPhid, objectIdentifier, parentPhid;
  int? start;
  int? end;

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    var transactions = List<Map<dynamic, dynamic>>.empty(growable: true);

    var dataMembers = Map<String, String>();
    var counter = 0;
    if (membersPhid != null) {
      this.membersPhid?.asMap().forEach((key, value) {
        if (!dataMembers.containsValue(value.toString())) {
          dataMembers[(counter++).toString()] = value;
        }
      });
      transactions.add({'type': 'members.set', 'value': dataMembers});
    }

    if (name != null) {
      transactions.add({'type': 'name', 'value': this.name});
    }
    if (description != null) {
      transactions.add({'type': 'description', 'value': this.description});
    }
    if (parentPhid != null) {
      transactions.add({'type': 'parent', 'value': this.parentPhid});
    }
    if (start != null) transactions.add({'type': 'start', 'value': this.start});
    if (end != null) transactions.add({'type': 'end', 'value': this.end});

    if (policy != null) {
      switch (policy) {
        case "Public":
          transactions.add({'type': 'view', 'value': "users"});
          transactions.add({'type': 'edit', 'value': "users"});
          transactions.add({'type': 'join', 'value': "users"});
          break;
        case "Private":
          transactions.add({'type': 'view', 'value': this.projectPhid});
          transactions.add({'type': 'edit', 'value': this.projectPhid});
          transactions.add({'type': 'join', 'value': this.projectPhid});
          break;
        default:
      }
    }
    transactions.add({'type': 'isForDev', 'value': this.isForDev});
    req['transactions'] = transactions;
    if (objectIdentifier != null) {
      req['objectIdentifier'] = objectIdentifier;
    }
    return req;
  }
}
