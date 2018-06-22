import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class LoyaltyCardPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: new AppBar(
          title: new Text('Loyalty Card'),
        ),
        body: new Center(
          child:    new QrImage(
            data: globals.currentUser.id,
            size: 300.0,
            backgroundColor: Colors.white,
          ),
        ),

    );}


}
