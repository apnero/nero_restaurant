import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image.asset(
            'assets/images/order_card.jpg',
            height: 265.0,
            fit: BoxFit.cover,
          ),
          const ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Whats for dinner'),
            subtitle: const Text('Flavorful protein rich goodness.'),
          ),
          new ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              children: <Widget>[
                new RaisedButton(
                  color: Colors.white,
                  child: const Text('ORDER'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/main-order-page');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}