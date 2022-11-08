// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:bitcoin_ticker/components/networking.dart';
import 'package:flutter/material.dart';
import 'price_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.orange, scaffoldBackgroundColor: Colors.white),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void gettingData() async {
    Networking networking = Networking();
    dynamic cryptoPrice = await networking.getData('AUD');

    if (cryptoPrice == null) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Error'),
            content: Text(
                'Unable to connect with server! Please make sure you internet is connected!'),
            actions: <Widget>[
              TextButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PriceScreen(),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    gettingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading...',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            SizedBox(
              height: 15.0,
            ),
            SpinKitWave(
              color: Colors.black,
              size: 100.0,
              type: SpinKitWaveType.center,
            ),
          ],
        ),
      ),
    );
  }
}
