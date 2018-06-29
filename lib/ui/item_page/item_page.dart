import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/model/selection_model.dart';
import 'package:nero_restaurant/ui/item_page/chips_tile.dart';
import 'package:nero_restaurant/model/item_model.dart';
import 'package:nero_restaurant/model/options_model.dart';
import 'package:nero_restaurant/services/firebase_calls.dart';
import 'package:nero_restaurant/ui/item_page/animated_fab.dart';
import 'package:nero_restaurant/ui/item_page/diagonal_clipper.dart';


class ItemPage extends StatefulWidget {
  ItemPage({Key key, @required this.selection}) : super(key: key);
  final Selection selection;

  @override
  _ItemPageState createState() => new _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final double _imageHeight = 256.0;
  Item thisItem;
  Map<String, List<String>> thisItemOptions;
  String uid = '';

  @override
  void initState() {
    thisItem = Item.getItemFromDocId(widget.selection.itemDocId);
    thisItemOptions = Options.getOptionsForThisItem(thisItem.options);
    uid = FirebaseCalls.getCurrentUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildImage(),
//          _buildTopHeader(),
          _buildProfileRow(),
          _buildBottomPart(),
          thisItem.options[0] !='' ? _buildOptions():Container(),
          _buildFab(),

        ],
      ),
    );
  }

  Widget _buildFab() {
    return new Positioned(
        top: _imageHeight - 100.0,
        right: -40.0,
        child: new AnimatedFab(
          selection: widget.selection,
        ));
  }

  Widget _buildImage() {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Hero(
            tag: widget.selection.hashCode.toString(),
            child: new Container(
                height: 256.0,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new CachedNetworkImageProvider(thisItem.url))))),
      ),
    );
  }

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
        ],
      ),
    );
  }

  Widget _buildMyTasksHeader() {
    return new Padding(
      padding: new EdgeInsets.only(left: 40.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            thisItem.name,
            style: new TextStyle(fontSize: 32.0),
          ),
          new Padding(
            padding: EdgeInsets.only(right:20.0, top:2.0,),
          child: new Text(
            thisItem.description.replaceAll('\"', ''),
            style: Theme.of(context).textTheme.subhead,
          )),
        ],
      ),
    );
  }



  Widget _buildProfileRow() {
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
      child: new Row(
        children: <Widget>[

        ],
      ),
    );
  }


  Widget _buildOptions() {
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, top: 410.0),
      child: new ListView.builder(
        itemCount: thisItemOptions.length,
        itemBuilder: (context, index) {
          return new ChipsTile(
              label: thisItemOptions.keys.toList()[index],
              values: thisItemOptions.values.toList()[index],
              choices: widget.selection.choices);

        },
      ),
    );
  }
}
