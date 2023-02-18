class BaseApiResponse {
  String result;
  String? errorCode;
  String? errorResult;

  BaseApiResponse(this.result, {this.errorCode, this.errorResult});
}
