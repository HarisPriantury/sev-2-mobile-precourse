import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';

class UpdateUserApiRequest
    implements UpdateUserRequestInterface, ApiRequestInterface {
  String objectIdentifier;
  bool? isDisabled;
  bool? isApproved;
  String? name;
  String? phone;
  String? title;
  String? icon;
  int? birthDate;
  String? birthPlace;
  String? githubUrl;
  String? stackoverflowUrl;
  String? hackerrankUrl;
  String? duolingoUrl;
  String? linkedinUrl;

  UpdateUserApiRequest(this.objectIdentifier,
      {this.isDisabled,
      this.isApproved,
      this.name,
      this.phone,
      this.title,
      this.icon,
      this.birthDate,
      this.birthPlace,
      this.githubUrl,
      this.stackoverflowUrl,
      this.hackerrankUrl,
      this.duolingoUrl,
      this.linkedinUrl});

  @override
  Map<dynamic, dynamic> encode() {
    var req = Map<dynamic, dynamic>();
    var transactions = List<Map<dynamic, dynamic>>.empty(growable: true);

    if (isDisabled != null) {
      transactions.add({'type': 'disabled', 'value': isDisabled});
    }

    if (isApproved != null) {
      transactions.add({'type': 'approved', 'value': isApproved});
    }

    if (name != null) {
      transactions.add({'type': 'realName', 'value': name});
    }

    if (phone != null) {
      transactions.add({'type': 'phoneNumber', 'value': phone});
    }

    if (title != null) {
      transactions.add({'type': 'title', 'value': title});
    }

    if (icon != null) {
      transactions.add({'type': 'icon', 'value': icon});
    }

    if (birthDate != null) {
      transactions.add({'type': 'custom.birthdate', 'value': birthDate});
    }

    if (birthPlace != null) {
      transactions.add({'type': 'custom.birthplace', 'value': birthPlace});
    }

    if (githubUrl != null) {
      transactions.add({'type': 'custom.github', 'value': githubUrl});
    }

    if (stackoverflowUrl != null) {
      transactions
          .add({'type': 'custom.stackoverflow', 'value': stackoverflowUrl});
    }

    if (hackerrankUrl != null) {
      transactions.add({'type': 'custom.hackerrank', 'value': hackerrankUrl});
    }

    if (duolingoUrl != null) {
      transactions.add({'type': 'custom.duolingo', 'value': duolingoUrl});
    }

    if (linkedinUrl != null) {
      transactions.add({'type': 'custom.linkedin', 'value': linkedinUrl});
    }

    req['objectIdentifier'] = objectIdentifier;
    req['transactions'] = transactions;

    return req;
  }
}
