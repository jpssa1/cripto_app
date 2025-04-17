class CoinModel {
  final int id;
  final String name;
  final String symbol;
  final double price;

  CoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
  });

  factory CoinModel.fromMap(Map<String, dynamic> coin) {
    return CoinModel(
      id: coin["id"],
      name: coin["name"],
      symbol: coin["symbol"],
      price: coin["quote"]["USD"]["price"],
    );
  }
}
