import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class AddParticipantsApiRequest implements AddParticipantsRequestInterface, ApiRequestInterface {
  String objectIdentifier;
  List<String> participantIds;

  AddParticipantsApiRequest(this.objectIdentifier, this.participantIds);

  @override
  Map<dynamic, dynamic> encode() {
    var req = Map<dynamic, dynamic>();
    var transactions = List<Map<dynamic, dynamic>>.empty(growable: true);

    if (!this.participantIds.isNullOrEmpty()) {
      var dataIds = Map<String, String>();
      var counter = 0;
      this.participantIds.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      transactions.add({'type': 'participants.add', 'value': dataIds});
    }
    req['objectIdentifier'] = objectIdentifier;
    req['transactions'] = transactions;
    return req;
  }
}
