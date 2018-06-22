import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/model/weather_model.dart';

class WeatherRow extends StatelessWidget {
  WeatherRow({Key key, @required this.data}) : super(key: key);
  final Weather data;

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text((data.temp)),
              new Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new CachedNetworkImageProvider(data.icon)))),
              new Text((data.description)),
            ]));
  }
}
