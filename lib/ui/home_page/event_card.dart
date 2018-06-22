import 'package:flutter/material.dart';
import 'package:nero_restaurant/ui/order_page/main_order_page.dart';

class EventCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image.asset(
            'assets/images/special.jpg',
            height: 265.0,
            fit: BoxFit.cover,
          ),
          const ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('4th of July Special'),
            subtitle: const Text('Celebrate the holiday at your favorite place.'),
          ),

        ],
      ),
    );
  }
}