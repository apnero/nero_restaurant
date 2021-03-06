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
import 'package:nero_restaurant/services/firebase_calls.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';

Future<Weather> fetchWeather() async {
  final response = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?zip=06810,us&APPID=21162b0c67022caa4dde8b1427b916b4');
  final responseJson = json.decode(response.body);

  return new Weather.fromJson(responseJson);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  FirebaseUser _currentUser;
  String pushToken = '';

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print(token);
      pushToken = token;
    });
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

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
          title: globals.currentUser != null &&
                  globals.currentUser.displayName.contains(' ')
              ? new Text(
                  'Welcome ' + globals.currentUser.displayName.split(' ')[0])
              : new Text('Welcome'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.restaurant_menu),
              tooltip: 'Menu',
              onPressed: () => Navigator.pushNamed(context, "/main_order_page"),
            ),
            new IconButton(
              icon: new Icon(Icons.shopping_cart),
              tooltip: 'Shopping Cart',
              onPressed: () =>
                  Navigator.pushNamed(context, "/shopping_cart_page"),
            ),
            new IconButton(
              icon: new Icon(Icons.card_membership),
              tooltip: 'Loyalty Card',
              onPressed: () =>
                  Navigator.pushNamed(context, "/loyalty_card_page"),
            ),
          ],
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
              globals.currentUser != null ? new RewardsRow() : new Container(),
              new Expanded(
                  child: new ListView(
                children: globals.webLinks != null
                    ? globals.webLinks.map<Widget>((WebLink webLink) {
                        return WebLinkCard(data: webLink);
                      }).toList()
                    : [Container(), Container()],
              )),
            ])),
//          new FabDialer(_fabMiniMenuItemList, Colors.blue, new Icon(Icons.add)),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FutureBuilder<Map<String, double>>(
          future: FirebaseCalls.getCost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data['sentPrice'] != 0.0
                  ? FloatingActionButton.extended(
                      icon: new Icon(Icons.card_membership),
                      key: new ValueKey<Key>(new Key('1')),
                      label: new Text('Order is being made: \$' +
                          (snapshot.data['sentPrice'] * 1.0635)
                              .toStringAsFixed(2)),
                      onPressed: () =>
                          Navigator.pushNamed(context, "/loyalty_card_page"))
                  : snapshot.data['cartPrice'] != 0.0
                      ? FloatingActionButton.extended(
                          icon: new Icon(Icons.shopping_cart),
                          key: new ValueKey<Key>(new Key('1')),
                          label: new Text('\$' +
                              (snapshot.data['cartPrice'] * 1.0635)
                                  .toStringAsFixed(2)),
                          onPressed: () => Navigator.pushNamed(
                              context, "/shopping_cart_page"))
                      : _currentUser == null
                          ? FloatingActionButton.extended(
                              icon: new Icon(Icons.vpn_key),
                              key: new ValueKey<Key>(new Key('1')),
                              label: new Text('Click To Login'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) => new SignInScreen(
                                          title: "Nero Restaurant",
                                          header: new Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 1.0),
                                            child: new Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6.0),
                                              child: new Image.asset(
                                                'assets/images/ndm_logo.jpg',
                                                width: 225.0,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          providers: [
                                            ProvidersTypes.facebook,
                                            ProvidersTypes.google,
//          ProvidersTypes.email
                                          ],
                                        ),
                                  ),
                                );
                              })
                          : Container();
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            } else
              return new Container(
                height: 30.0,
              );
          }),
    );
  }

  void _checkCurrentUser() async {
    try {
      _currentUser = await _auth.currentUser();
      _currentUser?.getIdToken(refresh: true);

      if (_currentUser != null) FirebaseCalls.saveUser(_currentUser, pushToken);

      _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
        setState(() {
          _currentUser = user;
          if (_currentUser != null)
            FirebaseCalls.saveUser(_currentUser, pushToken);
        });
        Navigator.maybePop(context);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
