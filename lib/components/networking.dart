import 'package:bitcoin_ticker/coin_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class Networking {
  Future<dynamic> getData(String userCurrency) async {
    List? cryptoPrice;
    bool itHasConnection = await InternetConnectionCheckerPlus().hasConnection;
    String url =
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=$userCurrency";

    http.Response response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200 && itHasConnection == true) {
      try {
        cryptoPrice = await jsonDecode(response.body.toString());
      } catch (e) {
        print(e);
      }
      return cryptoPrice;
    } else {
      return null;
    }
  }
}
