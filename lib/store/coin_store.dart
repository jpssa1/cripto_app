import 'package:cripto_app/http/http_client.dart';
import 'package:cripto_app/models/coin_model.dart';
import 'package:cripto_app/repository/coin_repository.dart';
import 'package:flutter/material.dart';

abstract class ICoinStore extends ChangeNotifier {
  Future<void> fetchCoins();
}

class CoinStore extends ICoinStore {
  final repository = CoinRepository(client: HttpClient());

  Map<String, String> coinImages = {};
  List<CoinModel> _allCoins = [];
  List<CoinModel> filteredCoins = [];
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

      _allCoins = result;
      filteredCoins = result; // inicialmente mostra todas
      coinImages = images;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    if (query.isEmpty) {
      filteredCoins = _allCoins;
    } else {
      filteredCoins =
          _allCoins
              .where(
                (coin) => coin.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    notifyListeners();
  }
}
