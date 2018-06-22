import 'package:nero_restaurant/model/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:nero_restaurant/ui/style.dart';

class RewardDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Nero Rewards'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Text('REWARDS PROGRESS', style: rewardRowText),
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
                      (300 - globals.currentUser.points)/3,
                      Colors.blueGrey[600],
                      rankKey: 'remaining',
                    ),
                  ],
                  rankKey: 'progress',
                ),
              ],
              chartType: CircularChartType.Radial,
              percentageValues: true,
              holeLabel:
                  globals.currentUser.points.truncate().toString() + '/300',
              labelStyle: new TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            ),
            new Divider(),
            new Text('MEMBERSHIP STATUS', style: rewardRowText),
            new Text('Novice Status',
                style: new TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 24.0,
                )),
            new Text(
                'Earn ' +
                    (300 - globals.currentUser.points).truncate().toString() +
                    ' points to reach Premier Status',
                style: rewardRowText),
          ],
        ),
      ),
    );
  }
}
