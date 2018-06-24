import 'package:flutter/material.dart';
import 'package:nero_restaurant/model/web_link_model.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nero_restaurant/ui/item_page/item_page.dart';
import 'package:nero_restaurant/model/selection_model.dart';

class WebLinkCard extends StatelessWidget {
  WebLinkCard({Key key, @required this.data}) : super(key: key);
  final WebLink data;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
              height: 256.0,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: new CachedNetworkImageProvider(data.imageUrl)))),
          ListTile(
            leading: const Icon(Icons.arrow_forward),
            title: Text(data.title),
            subtitle: Text(data.subtitle),
          ),
          new ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              children: <Widget>[
                new OutlineButton(
                  child: Text('Details',
                      style: Theme.of(context).textTheme.subhead),
//                    color: Theme.of(context).accentColor,
                  borderSide: new BorderSide(color: Colors.white70),
                  splashColor: Colors.blueGrey,

                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => data.type == 'link'
                            ? new WebviewScaffold(
                                url: data.destUrlOrItemId,
                                appBar: new AppBar(
                                  title: new Text(data.webtitle),
                                ),
                              )
                            : new ItemPage(
                                selection:
                                    Selection.fromItemId(data.destUrlOrItemId)),
                      ),
                    );
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
