import 'package:file_picker/file_picker.dart';
import 'package:mobile_sev2/data/infrastructures/files_picker_interface.dart';
import 'package:mobile_sev2/domain/file.dart' as FileDomain;

class FilesPicker implements FilesPickerInterface {
  @override
  Future<FilePickerResult?> pick(FileDomain.FileType type) async {
    var extensions = List<String>.empty(growable: true);
    if (type == FileDomain.FileType.image) {
      return await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        withData: true,
        // allowedExtensions: extensions,
      );
    } else if (type == FileDomain.FileType.video) {
      return await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.video,
        withData: true,
        // allowedExtensions: extensions,
      );
    } else {
      extensions.addAll([
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
      ]);
      return await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        withData: true,
        allowedExtensions: extensions,
      );
    }
  }

  @override
  Future<FilePickerResult?> pickAllTypes() async {
    var extensions = [
      'jpeg',
      'jpg',
      'png',
      'mpeg',
      'mp4',
      'png',
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
    ];
    return await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      withData: true,
      allowedExtensions: extensions,
    );
  }
}
