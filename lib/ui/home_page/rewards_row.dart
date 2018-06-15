import 'package:flutter/material.dart';

class RewardsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(color: Colors.blueGrey),
        child: new Row(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(32.0),
                child: new Column(
                  children: <Widget>[
                    new Text("NERO DIGITAL REWARDS",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                          fontFamily: 'Dosis',
                          fontWeight: FontWeight.w700,
                        )
                    ),
                    new Row(
                      children: <Widget>[
                        new Text("0/",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.w700,
                            )),
                        new Text("300",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            )
                        ),
                      ],
                    ),
                  ],
                )
            )
          ],
        )
    );
  }
}