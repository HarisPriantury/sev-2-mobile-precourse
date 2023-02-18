import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:uuid/uuid.dart';

class PhobjectMapper {
  DateUtilInterface _dateUtil;
  Uuid _uuid;

  PhobjectMapper(this._dateUtil, this._uuid);

  List<PhObject> convertGetPhobjectsApiResponse(Map<String, dynamic> response) {
    var objects = List<PhObject>.empty(growable: true);

    var data = response['result'];
    if (data != null) {
      data.forEach((key, value) {
        objects.add(PhObject(
          value['phid'],
          uri: value['uri'],
          typeName: value['typeName'],
          type: value['type'],
          name: value['name'],
          fullName: value['fullName'],
          status: value['status'],
        ));
      });
    }
    return objects;
  }

  List<PhTransaction> convertGetPhTransactionsApiResponse(Map<String, dynamic> response) {
    var objects = List<PhTransaction>.empty(growable: true);

    var data = response['result']['data'];
    if (data != null) {
      data.forEach((value) {
        var subject = User("");
        var target = PhObject("", name: "", fullName: "");
        PhObject? oldRelation;
        PhObject? newRelation;
        String action = "";
        if (value['type'] != null) {
          if (value['type'] == "comment") {
            value['comments'].forEach((c) {
              var author = c['authors'];
              subject = User(
                c['authorPHID'],
                name: author['username'],
                fullName: author['realname'],
                avatar: author['profileImageURI'],
              );
              action = c['content']['raw'];
              if (c['removed'] == true) {
                action = "komentar dihapus oleh";
              }
            });
          } else if (value['type'] != null) {
            var author = value['authors'];
            subject = User(
              value['authorPHID'],
              name: author['username'],
              fullName: author['realname'],
              avatar: author['profileImageURI'],
            );
            if (value['fields']['operations'] != null) {
              value['fields']['operations'].forEach((c) {
                target = PhObject(c['phid']);
                var operation = c['operation'];
                if (operation == "add") {
                  action = "menambah <bold>${value['type']}</bold>:";
                } else if (operation == "remove") {
                  action = "menghapus <bold>${value['type']}</bold>:";
                }
              });
            } else {
              if (value['fields']['new'] != null && value['fields']['new'].toString() != "") {
                var nFields = value['fields']['new'];
                if (nFields is Map) {
                  if (value['fields']['old']['name'] != null && value['fields']['old']['name'].toString() != "") {
                    if (value['fields']['old']['name'].toString().startsWith('PHID')) {
                      oldRelation = PhObject(value['fields']['old']['name']);
                    }

                    if (value['fields']['new']['name'].toString().startsWith('PHID')) {
                      newRelation = PhObject(value['fields']['new']['name']);
                    }

                    action =
                        "mengedit <bold>${value['type']}</bold> dari <bold>${value['fields']['old']['name']}</bold> ke <bold>${value['fields']['new']['name']}</bold>";
                  } else {
                    if (value['fields']['new']['name'].toString().startsWith('PHID')) {
                      newRelation = PhObject(value['fields']['new']['name']);
                    }
                    action =
                        "menambahkan <bold>${value['type']}</bold>: <bold>${value['fields']['new']['name']}</bold>";
                  }
                } else {
                  if (value['fields']['old'] != null && value['fields']['old'].toString() != "") {
                    if (value['fields']['new'].toString().startsWith('PHID')) {
                      newRelation = PhObject(value['fields']['new']);
                    }

                    if (value['fields']['old'].toString().startsWith('PHID')) {
                      oldRelation = PhObject(value['fields']['old']);
                    }
                    action =
                        "mengedit <bold>${value['type']}</bold> dari <bold>${value['fields']['old']}</bold> ke <bold>${value['fields']['new']}</bold>";
                  } else {
                    if (value['fields']['new'].toString().startsWith('PHID')) {
                      newRelation = PhObject(value['fields']['new']);
                    }

                    action = "menambahkan <bold>${value['type']}</bold>: <bold>${value['fields']['new']}</bold>";
                  }
                }
              } else {
                if (value['type'] == "create") {
                  action = "membuat";
                  target = PhObject(value['objectPHID']);
                }
              }
            }
          }

          List<File> attachments = [];
          if (value['type'] == 'description' || value['type'] == 'comment') {
            List<String?> fileActions = DataUtil.getFiles(action);
            if (fileActions.isNotEmpty) {
              fileActions.forEach((m) {
                if (!m.isNullOrEmpty()) {
                  var mInt = int.parse(m!.replaceAll(RegExp(r"{F|}"), ""));
                  attachments.add(File(_uuid.v1(), idInt: mInt));
                }
              });
            }
          }

          var pht = PhTransaction(
            value['phid'],
            value['id'],
            value['objectPHID'],
            value['groupID'],
            subject,
            target,
            action,
            _dateUtil.fromSeconds(value['dateCreated']),
            _dateUtil.fromSeconds(value['dateModified']),
            type: value['type'],
            oldRelation: oldRelation,
            newRelation: newRelation,
            attachments: attachments,
          );

          objects.add(pht);
        }
      });
    }
    return objects;
  }
}
