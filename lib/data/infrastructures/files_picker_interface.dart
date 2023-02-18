import 'package:mobile_sev2/domain/file.dart';

abstract class FilesPickerInterface {
  dynamic pick(FileType type);
  dynamic pickAllTypes();
}
