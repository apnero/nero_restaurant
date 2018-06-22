import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:nero_restaurant/ui/style.dart';
import 'package:nero_restaurant/ui/reward_details_page.dart';

class RewardsRow extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(color: Colors.blueGrey),
        child: new Row(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(10.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text("NERO DIGITAL REWARDS", style: rewardRowText),
                    new AnimatedCircularChart(
                      key: new Key('key'),
                      size: new Size(100.0, 100.0),
                      initialChartData: <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                              globals.currentUser.points/3,
                              Colors.blue[400],
                              rankKey: 'completed',
                            ),
                            new CircularSegmentEntry(
                              (300 - globals.currentUser.points/3),
                              Colors.blueGrey[600],
                              rankKey: 'remaining',
                            ),
                          ],
                          rankKey: 'progress',
                        ),
                      ],
                      chartType: CircularChartType.Radial,
                      percentageValues: true,
                      holeLabel: globals.currentUser.points.truncate().toString() + '/300',
                      labelStyle: new TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                )),
            new Container( height: 70.0, child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text((300-globals.currentUser.points).truncate().toString() + ' points until Premier',
                    style: rewardRowText,
                  ),
                  new OutlineButton(
                    child: Text('Details', style: rewardRowText),
//                    color: Theme.of(context).accentColor,
                    borderSide: new BorderSide(color: Colors.white70),
                    splashColor: Colors.blueGrey,
    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new RewardDetailsPage()),
                      ); // Perform some action
                    },
                  ),
                ])
            )],
        ));
  }
}
