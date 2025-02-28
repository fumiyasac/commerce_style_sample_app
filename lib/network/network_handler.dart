import 'package:http/http.dart' as http;

class NetworkHandler {
  Future<http.Response> getRequest(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      return response;
    } catch (error) {
      throw Exception('データの取得に失敗しました: $error');
    }
  }
}
