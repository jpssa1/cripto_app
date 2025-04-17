import 'package:cripto_app/http/http_client.dart';
import 'package:cripto_app/models/coin_model.dart';
import 'package:cripto_app/repository/coin_repository.dart';
import 'package:cripto_app/store/coin_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CoinStore>();

    if (store.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (store.errorMessage != null) {
      return Scaffold(body: Center(child: Text('Erro: $store.errorMessage')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Moedas')),
      body: ListView.builder(
        itemCount: store.coins.length,
        itemBuilder: (context, index) {
          final coin = store.coins[index];
          return ListTile(
            leading: Image.network(
              store.coinImages[coin.id.toString()] ?? '', // Usa o ID como chave
            ),

            title: Text(coin.name),
            subtitle: Text(coin.price.toStringAsFixed(2)),
          );
        },
      ),
    );
  }
}
