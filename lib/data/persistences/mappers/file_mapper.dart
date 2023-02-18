import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/user.dart';

class FileMapper with DataUtil {
  late DateUtilInterface _dateUtil;

  FileMapper(this._dateUtil);

  List<File> convertGetFilesApiResponse(Map<String, dynamic> response) {
    var files = List<File>.empty(growable: true);

    var data = response['result']['data'];
    for (var file in data) {
      var f = File(
        file['phid'],
        idInt: file['id'],
        mimeType: file['fields']['mimeType'],
        fileType: getFileType(file['fields']['mimeType']),
        url: file['fields']['dataURI'],
        createdAt: _dateUtil.fromSeconds(file['fields']['dateCreated']),
        title: file['fields']['name'],
        size: file['fields']['size'],
      );

      if (file['fields']['owner'] != null) {
        f.author = User(file['fields']['owner']['phid'],
            name: file['fields']['owner']['username'],
            fullName: file['fields']['owner']['fullname'],
            avatar: file['fields']['owner']['profileImageURI']);
      }

      files.add(f);
    }
    return files;
  }

  BaseApiResponse convertUploadFileApiResponse(Map<String, dynamic> response) {
    return BaseApiResponse(response['result']);
  }
}
