// To parse this JSON data, do
//
//     final cmcapVeriler = cmcapVerilerFromJson(jsonString);

import 'dart:convert';

List<CmcapVeriler> cmcapVerilerFromJson(String str) => List<CmcapVeriler>.from(json.decode(str).map((x) => CmcapVeriler.fromJson(x)));

CmcapVeriler cmcapVerisiFromJson(String str) => CmcapVeriler.fromJson(json.decode(str));

String cmcapVerilerToJson(List<CmcapVeriler> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CmcapVeriler {
  CmcapVeriler({
    required this.circulatingSupply,
    required this.cmcRank,
    required this.dateAdded,
    required this.id,
    required this.lastUpdated,
    required this.maxSupply,
    required this.name,
    required this.numMarketPairs,
    required this.quote,
    required this.slug,
    required this.symbol,
    required this.tags,
    required this.totalSupply,
  });

  double circulatingSupply;
  int cmcRank;
  DateTime dateAdded;
  int id;
  DateTime lastUpdated;
  int maxSupply;
  String name;
  int numMarketPairs;
  Quote quote;
  String slug;
  String symbol;
  List<String> tags;
  double totalSupply;

  factory CmcapVeriler.fromJson(Map<String, dynamic> json) => CmcapVeriler(
    circulatingSupply: json["circulating_supply"].toDouble(),
    cmcRank: json["cmc_rank"],
    dateAdded: DateTime.parse(json["date_added"]),
    id: json["id"],
    lastUpdated: DateTime.parse(json["last_updated"]),
    maxSupply: json["max_supply"] == null ? null : json["max_supply"],
    name: json["name"],
    numMarketPairs: json["num_market_pairs"],
    quote: Quote.fromJson(json["quote"]),
    slug: json["slug"],
    symbol: json["symbol"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    totalSupply: json["total_supply"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "circulating_supply": circulatingSupply,
    "cmc_rank": cmcRank,
    "date_added": dateAdded.toIso8601String(),
    "id": id,
    "last_updated": lastUpdated.toIso8601String(),
    "max_supply": maxSupply == null ? null : maxSupply,
    "name": name,
    "num_market_pairs": numMarketPairs,
    "quote": quote.toJson(),
    "slug": slug,
    "symbol": symbol,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "total_supply": totalSupply,
  };
}

class Quote {
  Quote({
    required this.usd,
  });

  Usd usd;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
    usd: Usd.fromJson(json["USD"]),
  );

  Map<String, dynamic> toJson() => {
    "USD": usd.toJson(),
  };
}

class Usd {
  Usd({
    required this.lastUpdated,
    required this.marketCap,
    required this.percentChange1H,
    required this.percentChange24H,
    required this.percentChange30D,
    required this.percentChange60D,
    required this.percentChange7D,
    required this.percentChange90D,
    required this.price,
    required this.volume24H,
  });

  DateTime lastUpdated;
  double marketCap;
  double percentChange1H;
  double percentChange24H;
  double percentChange30D;
  double percentChange60D;
  double percentChange7D;
  double percentChange90D;
  double price;
  double volume24H;

  factory Usd.fromJson(Map<String, dynamic> json) => Usd(
    lastUpdated: DateTime.parse(json["last_updated"]),
    marketCap: json["market_cap"].toDouble(),
    percentChange1H: json["percent_change_1h"].toDouble(),
    percentChange24H: json["percent_change_24h"].toDouble(),
    percentChange30D: json["percent_change_30d"].toDouble(),
    percentChange60D: json["percent_change_60d"].toDouble(),
    percentChange7D: json["percent_change_7d"].toDouble(),
    percentChange90D: json["percent_change_90d"].toDouble(),
    price: json["price"].toDouble(),
    volume24H: json["volume_24h"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "last_updated": lastUpdated.toIso8601String(),
    "market_cap": marketCap,
    "percent_change_1h": percentChange1H,
    "percent_change_24h": percentChange24H,
    "percent_change_30d": percentChange30D,
    "percent_change_60d": percentChange60D,
    "percent_change_7d": percentChange7D,
    "percent_change_90d": percentChange90D,
    "price": price,
    "volume_24h": volume24H,
  };
}
