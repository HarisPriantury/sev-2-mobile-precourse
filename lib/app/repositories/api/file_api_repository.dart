import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/file_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/file_repository_interface.dart';
import 'package:mobile_sev2/domain/file.dart';

class FileApiRepository implements FileRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  FileMapper _mapper;

  FileApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<File>> findAll(GetFilesRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.files(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetFilesApiResponse(resp);
  }

  @override
  Future<BaseApiResponse> create(CreateFileRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.fileUpload(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertUploadFileApiResponse(resp);
  }

  @override
  Future<bool> prepare(PrepareCreateFileRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.filePrepare(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }
}
