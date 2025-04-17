import 'package:cripto_app/http/http_client.dart';
import 'package:cripto_app/models/coin_model.dart';
import 'package:cripto_app/repository/coin_repository.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchCoins();
  }

  Future<void> _fetchCoins() async {
    try {
      final result = await repository.getCoins();

      // Monta string com todos os id`s separados por vírgula
      final ids = result.map((coinModel) => coinModel.id).join(',');
      //faz o push de todos as url das imagens
      final imagesData = await repository.getImages(ids);

      setState(() {
        coins = result;
        coinImages = imagesData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  final repository = CoinRepository(client: HttpClient());

  Map<String, String> coinImages = {};
  List<CoinModel> coins = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text('Erro: $errorMessage')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Moedas')),
      body: ListView.builder(
        itemCount: coins.length,
        itemBuilder: (context, index) {
          final coin = coins[index];
          return ListTile(
            leading: Image.network(
              coinImages[coin.id.toString()] ?? '', // Usa o ID como chave
            ),

            title: Text(coin.name),
            subtitle: Text(coin.price.toStringAsFixed(2)),
          );
        },
      ),
    );
  }
}
