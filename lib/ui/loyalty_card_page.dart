
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class LoyaltyCardPage extends StatelessWidget {
  final String userId;

  // In the constructor, require a Todo
  LoyaltyCardPage({Key key, @required this.userId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: new AppBar(
          title: new Text('Loyalty Card'),
        ),
        body: new Center(
          child:    new QrImage(
            data: userId,
            size: 300.0,
            backgroundColor: Colors.white,
          ),
        ),

    );}


}
