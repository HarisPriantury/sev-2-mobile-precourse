class HTTPService {
  static const String _baseUrl = 'https://sev-2.com/';

  static Uri getUrl({required String endpoint}) {
    return Uri.parse(_baseUrl + endpoint);
  }

  static Map<String, String>? getHeader({String? accessToken}) {
    return {
      'x-sev-2-client-key': 'fe76412315589b55d803bbc66a1c11dc',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }
}
