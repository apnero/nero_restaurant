import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/home_page/rewards_row.dart';
import 'package:nero_restaurant/ui/home_page/weather_row.dart';
import 'package:nero_restaurant/model/weather_model.dart';
import 'package:nero_restaurant/model/web_link_model.dart';
import 'package:nero_restaurant/ui/home_page/web_link_cards.dart';
import 'package:nero_restaurant/ui/home_page/flutter_fab_dialer.dart';

Future<Weather> fetchWeather() async {
  final response = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?zip=06810,us&APPID=21162b0c67022caa4dde8b1427b916b4');
  final responseJson = json.decode(response.body);

  return new Weather.fromJson(responseJson);
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _fabMiniMenuItemList = [
      new FabMiniMenuItem.noText(
        new Icon(Icons.restaurant_menu),
        Colors.blue,
        4.0,
        "Button menu 1",
        () => Navigator.pushNamed(context, "/main_order_page"),
      ),
      new FabMiniMenuItem.noText(
        new Icon(Icons.card_membership),
        Colors.blue,
        4.0,
        "Button menu 2",
        () => Navigator.pushNamed(context, "/loyalty_card_page"),
      )
    ];

    return new Scaffold(
        appBar: new AppBar(
            title: globals.currentUser != null
                ? new Text(
                    'Welcome ' + globals.currentUser.displayName.split(' ')[0])
                : new Text('Welcome'),
            elevation: 4.0,
            bottom: new PreferredSize(
                preferredSize: Size(200.0, 25.0),
                child: new Container(
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
                      }),
                ))),
        body: new Stack(children: <Widget>[
          new Container(
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                globals.currentUser != null
                    ? new RewardsRow()
                    : new Container(),
                new Expanded(
                    child: new ListView(
                  children: globals.webLinks != null
                      ? globals.webLinks.map<Widget>((WebLink webLink) {
                          return WebLinkCard(data: webLink);
                        }).toList()
                      : [Container(), Container()],
                )),
              ])),
          new FabDialer(_fabMiniMenuItemList, Colors.blue, new Icon(Icons.add)),
        ]));
  }
}
