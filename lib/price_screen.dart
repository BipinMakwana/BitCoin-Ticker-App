// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'components/constant.dart';
import 'components/networking.dart';

class PriceScreen extends StatefulWidget {
  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  String? userCurrency = 'AUD';

  String liveBTCPrice = '?';
  String liveETHPrice = '?';
  String liveUSDTPrice = '?';
  String liveBNBPrice = '?';

  void gettingData() async {
    Networking networking = Networking();
    dynamic cryptoPrice = await networking.getData(userCurrency!);

    setState(() {
      if (cryptoPrice == null) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(
                'Please wait!',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              content: Text(
                'We are fetching live data from server!',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                  },
                ),
              ],
            );
          },
        );
      }
      liveBTCPrice =
          '${cryptoPrice[0]["current_price"].toString()} $userCurrency';
      liveETHPrice =
          '${cryptoPrice[1]["current_price"].toString()} $userCurrency';
      liveUSDTPrice =
          '${cryptoPrice[2]["current_price"].toString()} $userCurrency';
      liveBNBPrice =
          '${cryptoPrice[4]["current_price"].toString()} $userCurrency';
    });
  }

  @override
  void initState() {
    super.initState();
    gettingData();
  }

  Widget iOSPicker() {
    List<Widget> myCupertinoItem = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var item = Text(currenciesList[i]);
      myCupertinoItem.add(item);
    }
    return CupertinoPicker(
      looping: true,
      backgroundColor: Colors.teal,
      itemExtent: 40.0,
      onSelectedItemChanged: (int index) {
        setState(() {
          userCurrency = currenciesList[index];
          gettingData();
        });
      },
      children: myCupertinoItem,
    );
  }

  Widget androidPicker() {
    List<DropdownMenuItem> cryptoList = [];
    for (String currency in currenciesList) {
      cryptoList.add(DropdownMenuItem(
        value: currency,
        child: Text(currency),
      ));
    }
    return DropdownButton(
      dropdownColor: Colors.teal,
      style: TextStyle(color: Colors.white),
      items: cryptoList,
      value: userCurrency,
      onChanged: (value) {
        setState(() {
          userCurrency = value;
          gettingData();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          '🤑 Coin Ticker',
        ),
        centerTitle: true,
      ),
      body: ListView(scrollDirection: Axis.vertical, children: [
        Column(
          children: [
            SizedBox(
              height: 450,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    CardReuse(textData: '1 BTC = $liveBTCPrice'),
                    CardReuse(textData: '1 ETH = $liveETHPrice '),
                    CardReuse(textData: '1 USDT = $liveUSDTPrice '),
                    CardReuse(textData: '1 BNB = $liveBNBPrice '),
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Text(
                'Currency ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: 100.0,
              height: 50,
              child: Center(child: androidPicker()),
            )
          ],
        ),
      ]),
    );
  }
}

class CardReuse extends StatelessWidget {
  final String? textData;
  CardReuse({required this.textData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      height: 80.0,
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(10.0),
        color: Colors.teal,
        child: Center(
          child: Text(
            textData!,
            textAlign: TextAlign.center,
            style: kMyTextStyle,
          ),
        ),
      ),
    );
  }
}
