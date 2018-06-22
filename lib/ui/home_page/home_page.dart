import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nero_restaurant/ui/home_page/order_card.dart';
import 'package:nero_restaurant/ui/home_page/rewards_row.dart';
import 'package:nero_restaurant/ui/loyalty_card_page.dart';
import 'package:nero_restaurant/ui/home_page/weather_row.dart';
import 'package:nero_restaurant/model/weather_model.dart';
import 'package:nero_restaurant/ui/home_page/special_card.dart';
import 'package:nero_restaurant/ui/home_page/event_card.dart';
import 'package:nero_restaurant/model/selection_model.dart';
Future<Weather> fetchWeather() async {
  final response = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?zip=06810,us&APPID=21162b0c67022caa4dde8b1427b916b4');
  final responseJson = json.decode(response.body);

  return new Weather.fromJson(responseJson);
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: globals.currentUser != null
              ? new Text(
                  'Welcome ' + globals.currentUser.displayName.split(' ')[0])
              : new Text('Welcome'),
          elevation: 4.0,
        ),
        body: new Container(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
                child: new FutureBuilder<Weather>(
                    future: fetchWeather(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return new WeatherRow(data: snapshot.data);
                      } else if (snapshot.hasError) {
                        return new Text("${snapshot.error}");
                      } else
                        return new Container(
                          height: 30.0,
                        );
                    })),
            new Expanded(
                child: new ListView(children: <Widget>[
              globals.currentUser != null ? new RewardsRow() : new Container(),
              new EventCard(),
              new SpecialCard(
                selection: Selection.fromItemId('G8U7PeLXNI4f4mzYbert'),
              ),
              new OrderCard(),
            ])),
          ],
        )),
        floatingActionButton: new FloatingActionButton.extended(
            key: new ValueKey<Key>(new Key('1')),
            tooltip: 'Show Your Card',
            backgroundColor: Colors.blue,
            icon: new Icon(Icons.card_membership), //page.fabIcon,
            label: Text('Card'),
            onPressed: () {
//                    final snackBar = new SnackBar(content: new Text("Tap"));
//                    Scaffold.of(context).showSnackBar(snackBar);
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new LoyaltyCardPage(),
                ),
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
//
//  void _logout() {
//    FirebaseAuth.instance.signOut();
//  }
}
