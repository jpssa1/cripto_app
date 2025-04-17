import 'package:cripto_app/http/http_client.dart';
import 'package:cripto_app/models/coin_model.dart';
import 'package:cripto_app/repository/coin_repository.dart';
import 'package:flutter/material.dart';

abstract class iCoinStore extends ChangeNotifier {
  Future<void> fetchCoins();
}

class CoinStore extends iCoinStore {
  final repository = CoinRepository(client: HttpClient());

  Map<String, String> coinImages = {};
  List<CoinModel> coins = [];
  bool isLoading = true;
  String? errorMessage;

  CoinStore() {
    fetchCoins();
  }
  @override
  Future<void> fetchCoins() async {
    try {
      final result = await repository.getCoins();
      final ids = result.map((coin) => coin.id).join(',');
      final images = await repository.getImages(ids);

      coins = result;
      coinImages = images;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
