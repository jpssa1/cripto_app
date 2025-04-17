import 'package:cripto_app/http/http_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future<HttpResponse> get({required String url});
}

class HttpClient implements IHttpClient {
  final client = http.Client();
  @override
  Future<HttpResponse> get({required String url}) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'X-CMC_PRO_API_KEY': dotenv.env['COINMARKETCAP_API_KEY'] ?? '',
        'Accept': 'application/json',
      },
    );
    return HttpResponse(statusCode: response.statusCode, body: response.body);
  }
}
