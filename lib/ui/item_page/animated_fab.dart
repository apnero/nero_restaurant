import 'dart:math' as math;

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nero_restaurant/model/selection_model.dart';

import 'package:nero_restaurant/services/firebase_calls.dart';
import 'package:nero_restaurant/ui/shopping_cart/shopping_cart_page.dart';
import 'package:nero_restaurant/ui/order_page/main_order_page.dart';
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';

class AnimatedFab extends StatefulWidget {
  final Selection selection;

  const AnimatedFab({Key key, this.selection}) : super(key: key);

  @override
  _AnimatedFabState createState() => new _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  final double expandedSize = 180.0;
  final double hiddenSize = 20.0;
  bool fav = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  FirebaseUser _currentUser;
  String pushToken = '';

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = new ColorTween(begin: Colors.pink, end: Colors.pink[800])
        .animate(_animationController);
    _firebaseMessaging.getToken().then((token) {
      print(token);
      pushToken = token;
    });
    _checkCurrentUser();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: expandedSize,
      height: expandedSize,
      child: new AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildExpandedBackground(),
              _buildFavoriteOption(0.0, _onFavoriteClick),
              _buildOption(
                  Icons.add_shopping_cart, -math.pi / 3, _onAddToCartClick),
              _buildOption(Icons.payment, -2 * math.pi / 3, _onGoToCartClick),
              _buildOption(Icons.restaurant_menu, math.pi, _onGoToMenu),
              _buildFabCore(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOption(IconData icon, double angle, Function action) {
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }
    return new Transform.rotate(
      angle: angle,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Padding(
          padding: new EdgeInsets.only(top: 8.0),
          child: new IconButton(
            onPressed: action,
            icon: new Transform.rotate(
                angle: -angle,
                child: new Icon(
                  icon,
                  color: Colors.white,
                )),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: new EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteOption(double angle, Function action) {
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }
    return new Transform.rotate(
      angle: angle,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Padding(
          padding: new EdgeInsets.only(top: 8.0),
          child: new IconButton(
            onPressed: action,
            icon: new Transform.rotate(
                angle: -angle,
                child: fav
                    ? new Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )
                    : new Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      )),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: new EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedBackground() {
    double size =
        hiddenSize + (expandedSize - hiddenSize) * _animationController.value;
    return new Container(
      height: size,
      width: size,
      decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
    );
  }

  Widget _buildFabCore() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();
    return new FloatingActionButton(
      onPressed: _onFabTap,
      child: new Transform(
        alignment: Alignment.center,
        transform: new Matrix4.identity()..scale(1.0, scaleFactor),
        child: new Icon(
          _animationController.value > 0.5 ? Icons.close : Icons.filter_list,
          color: Colors.white,
          size: 26.0,
        ),
      ),
      backgroundColor: _colorAnimation.value,
    );
  }

  open() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  _onFavoriteClick() {
    String snackBarText = '';
    fav = !fav;

    if (_currentUser == null) {
      snackBarText = 'Please Login First!';

      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text(snackBarText)));
    } else {
      if (fav == true)
        snackBarText = 'Added Item To Favorites!';
      else
        snackBarText = 'Removed Item From Favorites!';

      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text(snackBarText)));

      if (fav == true) {
        widget.selection.favorite = true;
        FirebaseCalls.modifySelection(widget.selection);
      } else {
        widget.selection.favorite = false;
        FirebaseCalls.modifySelection(widget.selection);
      }
    }
    close();
  }

  _onAddToCartClick() {
    String snackBarText = '';
    if (_currentUser == null) {
      snackBarText = 'Please Login First!';

      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text(snackBarText)));
    } else {
      Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text("Item Had Been Added To The Cart!")));

      widget.selection.inCart = true;
      FirebaseCalls.modifySelection(widget.selection);
    }
    close();
  }

  _onGoToCartClick() {
    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new ShoppingCartPage(),
      ),
    );
    close();
  }

  _onGoToMenu() {
    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new MainOrderPage(),
      ),
    );
    close();
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
