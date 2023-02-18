import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/file/create_file_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/file_repository_interface.dart';
import 'package:mobile_sev2/domain/file.dart';

class FileDBRepository implements FileRepository {
  Box<File> _box;

  FileDBRepository(this._box);

  @override
  Future<BaseApiResponse> create(CreateFileRequestInterface request) {
    var params = request as CreateFileDBRequest;
    _box.put(params.file.id, params.file);

    return Future.value(BaseApiResponse(params.file.id));
  }

  @override
  Future<List<File>> findAll(GetFilesRequestInterface params) {
    var files = _box.values.toList();
    return Future.value(files);
  }

  @override
  Future<bool> prepare(PrepareCreateFileRequestInterface request) {
    throw UnimplementedError();
  }
}
