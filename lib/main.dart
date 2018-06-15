import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nero_restaurant/model/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nero_restaurant/ui/loyalty_card_page.dart';
import 'package:nero_restaurant/ui/home_page/order_card.dart';
import 'package:nero_restaurant/ui/home_page/rewards_row.dart';
import 'package:nero_restaurant/ui/style.dart';
import 'package:nero_restaurant/ui/order_page/main_order_page.dart';
import 'package:nero_restaurant/ui/shopping_cart/shopping_cart_page.dart';

final auth = FirebaseAuth.instance;
final googleSignIn = new GoogleSignIn();
final ref = Firestore.instance.collection('Users');

User currentUserModel;
String pushToken = '';
bool admin = false;

Future<Null> _ensureLoggedIn(BuildContext context) async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) {
    user = await googleSignIn.signInSilently();
  }
  if (user == null) {
    await googleSignIn.signIn().then((_) {
      tryCreateUserRecord(context);
    });
  }

  await getUserRecord(context);

  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
        idToken: credentials.idToken, accessToken: credentials.accessToken);
  }
}

Future<Null> _silentLogin(BuildContext context) async {
  GoogleSignInAccount user = googleSignIn.currentUser;

  if (user == null) {
    user = await googleSignIn.signInSilently().then((_) {
      tryCreateUserRecord(context);
    });
  }

  await getUserRecord(context);

  if (await auth.currentUser() == null && user != null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
        idToken: credentials.idToken, accessToken: credentials.accessToken);
  }
}

tryCreateUserRecord(BuildContext context) async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) {
    return null;
  }

  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  DocumentSnapshot userRecord = await ref.document(user.id).get();
  if (userRecord.data == null) {
    // no user record exists, time to create

    ref.document(firebaseUser.uid).setData({
      "id": firebaseUser.uid,
      "photoUrl": user.photoUrl,
      "email": user.email,
      "displayName": user.displayName,
      "pushToken": pushToken,
      "admin": false,
    });
//    }
  }

  currentUserModel = new User.fromDocument(userRecord);
}

getUserRecord(BuildContext context) async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) {
    return null;
  }
  DocumentSnapshot userRecord = await ref.document(user.id).get();
  if (userRecord.data != null) {
    admin = userRecord.data['admin'];
  }
  return null;
}

class NeroRestaurant extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Nero Digital ',
      theme: mainTheme,
      home: new HomePage(title: 'Nero Digital Restaurant'),
      routes: <String, WidgetBuilder>{
        // Set named routes
        '/main-order-page': (BuildContext context) => new MainOrderPage(),
        '/shopping-cart-page': (BuildContext context) => new ShoppingCartPage(),
      },
    );
  }
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

//PageController pageController;

class _HomePageState extends State<HomePage> {
//  int _page = 0;
  bool triedSilentLogin = false;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final double _appBarHeight = 80.0;

  final AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print(token);
      pushToken = token;
    });
  }

  Scaffold buildLoginPage() {
    return new Scaffold(
      body: new Center(
        child: new Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: new Column(
            children: <Widget>[
              new Image.asset(
                'assets/images/ndm_logo.png',
                width: 350.0,
                fit: BoxFit.cover,
              ),
              new Padding(padding: const EdgeInsets.only(bottom: 60.0)),
              new GestureDetector(
                onTap: login,
                child: new Image.asset(
                  "assets/images/google_signin_button.png",
                  width: 225.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (triedSilentLogin == false) {
      silentLogin(context);
    }
    return googleSignIn.currentUser == null
        ? buildLoginPage()
        : new Scaffold(
            // Appbar
//            appBar: new AppBar(
//              centerTitle: true,
//              title: Text('Welcome ${googleSignIn.currentUser.displayName}'),
//            ),
            floatingActionButton: new FloatingActionButton.extended(
                key: new ValueKey<Key>(new Key('1')),
                tooltip: 'Show your loyalty card to the staff.',
                backgroundColor: Colors.blue,
                icon: new Icon(Icons.message), //page.fabIcon,
                label: Text('Loyalty Card'),
                onPressed: () {
//                    final snackBar = new SnackBar(content: new Text("Tap"));
//                    Scaffold.of(context).showSnackBar(snackBar);
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new LoyaltyCardPage(
                          userId: googleSignIn.currentUser.id),
                    ),
                  );
                }),

            // Body
            body: new CustomScrollView(
              slivers: <Widget>[
                new SliverAppBar(
                  expandedHeight: _appBarHeight,
//                  centerTitle: true,

                  pinned: _appBarBehavior == AppBarBehavior.pinned,
                  floating: _appBarBehavior == AppBarBehavior.floating ||
                      _appBarBehavior == AppBarBehavior.snapping,
                  snap: _appBarBehavior == AppBarBehavior.snapping,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: const Text('Nero Digital'),
                  ),
//                  title:  Text('Welcome ${googleSignIn.currentUser.displayName}'),
                  actions: <Widget>[
                    new PopupMenuButton<AppBarBehavior>(
                      onSelected: (AppBarBehavior value) {
//                        setState(() {
//                          _appBarBehavior = value;
//                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<AppBarBehavior>>[
                            const PopupMenuItem<AppBarBehavior>(
                                value: AppBarBehavior.normal,
                                child: const Text('App bar scrolls away')),
                            const PopupMenuItem<AppBarBehavior>(
                                value: AppBarBehavior.pinned,
                                child: const Text('App bar stays put')),
                            const PopupMenuItem<AppBarBehavior>(
                                value: AppBarBehavior.floating,
                                child: const Text('App bar floats')),
                            const PopupMenuItem<AppBarBehavior>(
                                value: AppBarBehavior.snapping,
                                child: const Text('App bar snaps')),
                          ],
                    ),
                  ],
                ),
                new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    new RewardsRow(),
                    new OrderCard(),
                  ]),
                ),
              ],
            ),
          );
  }

  void login() async {
    await _ensureLoggedIn(context);
    setState(() {
      triedSilentLogin = true;
    });
  }

  void silentLogin(BuildContext context) async {
    await _silentLogin(context);
    setState(() {
      triedSilentLogin = true;
    });
  }
}

void main() => runApp(new NeroRestaurant());
