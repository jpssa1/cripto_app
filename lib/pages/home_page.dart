import 'package:cripto_app/store/coin_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      appBar: AppBar(
        title: const Text('Moedas', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Buscar moeda...',
              onChanged: (value) {
                store.setSearchQuery(value);
              },
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: store.filteredCoins.length,
              itemBuilder: (context, index) {
                final coin = store.filteredCoins[index];
                return ListTile(
                  leading: Image.network(
                    store.coinImages[coin.id.toString()] ??
                        '', // Usa o ID como chave
                  ),

                  title: Text(coin.name),
                  subtitle: Text(coin.price.toStringAsFixed(2)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
