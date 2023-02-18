import 'package:mobile_sev2/domain/flag.dart';

class FlagMapper {
  List<Flag> convertGetFlagsApiRequest(Map<String, dynamic> response) {
    var flags = List<Flag>.empty(growable: true);

    var data = response['result'];
    if (data != null) {
      data.forEach((value) {
        flags.add(
          Flag(
            value['id'],
            ownerPHID: value['ownerPHID'],
            type: value['type'],
            typeName: value['type'],
            name: value['handle']['name'],
            color: value['color'],
            colorName: value['colorName'],
            fullName: value['handle']['fullName'],
            uri: value['handle']['uri'],
            note: value['note'],
            objectPHID: value['objectPHID'],
          ),
        );
      });
    }

    return flags;
  }


}
