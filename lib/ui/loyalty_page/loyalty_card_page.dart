import 'package:nero_restaurant/model/globals.dart' as globals;

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/loyalty_page/order_structure_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/ui/common/pricing_item.dart';
import 'package:nero_restaurant/model/selection_price_model.dart';
import 'package:nero_restaurant/model/item_model.dart';

import 'package:nero_restaurant/services/firebase_calls.dart';
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';

final refSelections = Firestore.instance.collection('Selections');

class LoyaltyCardPage extends StatefulWidget {
  @override
  _LoyaltyCardPageState createState() => new _LoyaltyCardPageState();
}

class _LoyaltyCardPageState extends State<LoyaltyCardPage> {
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
    return _currentUser != null
        ? new Scaffold(
            appBar: new AppBar(
              title: new Text('Loyalty Card'),
            ),
            body: new SingleChildScrollView(
                child: new Center(
                    child: Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: new QrImage(
                    data: globals.currentUser.id,
                    size: 280.0,
                    backgroundColor: Colors.white,
                  )),
              new StreamBuilder(
                  stream: refSelections
                      .where('status', isEqualTo: 'working')
                      .where('uid', isEqualTo: globals.currentUser.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return new Text('Loading');
                    else if (snapshot.data.documents.length == 0)
                      return Text(
                        'No Current Order',
                        style: Theme.of(context).textTheme.headline,
                      );
                    return Column(children: <Widget>[
                      StructurePage(
                        context: context,
                        selections: snapshot.data.documents
                            .map<Selection>((DocumentSnapshot document) {
                          return Selection.fromSelectionDoc(document);
                        }).toList(),
                      ),
                      PricingItem(
                          context: context,
                          selectionPriceList:
                              snapshot.data.documents.map<SelectionPrice>(
                            (DocumentSnapshot snapshot) {
                              return SelectionPrice.from(
                                  snapshot['selectionId'],
                                  Item.getItemFromDocId(snapshot['itemDocId'])
                                      .price);
                            },
                          ).toList())
                    ]);
                  })
            ]))))
        : new SignInScreen(
            title: "Nero Restaurant",
            header: new Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
