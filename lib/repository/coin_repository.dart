import 'dart:convert';

import 'package:cripto_app/http/http_client.dart';
import 'package:cripto_app/models/coin_model.dart';

abstract class ICoinRepository {
  Future<List<CoinModel>> getCoins();
}

class CoinRepository implements ICoinRepository {
  final IHttpClient client;

  CoinRepository({required this.client});
  @override
  Future<List<CoinModel>> getCoins() async {
    final response = await client.get(
      url:
          'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      final List data = body['data'];

      final List<CoinModel> coins =
          data.map((item) {
            return CoinModel.fromMap(item);
          }).toList();

      return coins;
    } else {
      throw Exception('Failed to fetch coins: ${response.statusCode}');
    }
  }

  Future<Map<String, String>> getImages(String ids) async {
    final response = await client.get(
      url: 'https://pro-api.coinmarketcap.com/v2/cryptocurrency/info?id=$ids',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Map<String, dynamic> data = body['data'];

      final Map<String, String> images = {};

      data.forEach((key, value) {
        images[key] = value['logo'];
      });

      return images;
    } else {
      throw Exception('Failed to fetch coins: ${response.statusCode}');
    }
  }
}
