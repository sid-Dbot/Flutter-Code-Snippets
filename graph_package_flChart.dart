import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
// import 'package:mdabaliv4/view/accounts/tabs/loanTab/emi_calulator.dart';

// import '../../../model/dashboard/statement_model.dart';
// import '../../extracted widgets/colors.dart';

class MyGraph extends StatefulWidget {
  List<Statement> data;
  MyGraph({required this.data});

  @override
  State<MyGraph> createState() => _MyGraphState();
}

class _MyGraphState extends State<MyGraph> {
  FlDotPainter _defaultGetDotPainter(
    FlSpot spot,
    double xPercentage,
    LineChartBarData bar,
    int index, {
    double? size,
  }) {
    return FlDotCirclePainter(
      color: Colors.blue,
      radius: 6.5,
      strokeColor: Colors.white,
      strokeWidth: 2.5,
    );
  }

  List<FlSpot> spots = [];
  List<int> showingTooltipOnSpots = [];

  List<TouchedSpotIndicatorData> defaultTouchedIndicator(
    LineChartBarData barData,
    List<int> indicators,
  ) {
    return indicators.map((int index) {
      /// Indicator Line
      var lineColor = Colors.grey;

      if (barData.dotData.show) {
        lineColor = Colors.grey;
      }
      const lineStrokeWidth = 1.0;
      final flLine = FlLine(
        color: lineColor,
        strokeWidth: lineStrokeWidth,
        dashArray: [4, 4],
      );

      var dotSize = 10.0;
      if (barData.dotData.show) {
        dotSize = 4.0 * 1.8;
      }

      final dotData = FlDotData(
        getDotPainter: (spot, percent, bar, index) =>
            _defaultGetDotPainter(spot, percent, bar, index, size: dotSize),
      );

      return TouchedSpotIndicatorData(flLine, dotData);
    }).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    var x;
    for (x in widget.data) {
      spots.add(FlSpot(widget.data.indexOf(x).toDouble(), x.balance));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => LineChart(
        duration: Duration(seconds: 1),
        LineChartData(
            showingTooltipIndicators: showingTooltipOnSpots.map((index) {
              return ShowingTooltipIndicators([
                LineBarSpot(
                  LineChartBarData(
                    // preventCurveOverShooting: true,
                    showingIndicators: showingTooltipOnSpots,
                    dotData: FlDotData(show: false),
                    isCurved: true,
                    color: Color(0xff0B72EB),

                    spots: spots,
                  ),
                  index,
                  spots[index],
                ),
              ]);
            }).toList(),
            lineTouchData: LineTouchData(
                touchSpotThreshold: 1000,
                handleBuiltInTouches: false,
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? response) {
                  if (response == null || response.lineBarSpots == null) {
                    return;
                  }

                  final spotIndex = response.lineBarSpots!.first.spotIndex;
                  setState(() {
                    if (showingTooltipOnSpots.isNotEmpty) {
                      showingTooltipOnSpots = [];
                      showingTooltipOnSpots.add(spotIndex);
                    } else {
                      showingTooltipOnSpots.add(spotIndex);
                    }
                  });
                },
                getTouchLineEnd: (barData, spotIndex) =>
                    barData.spots[spotIndex].y + 100000,
                getTouchLineStart: (barData, spotIndex) =>
                    barData.spots[spotIndex].y - 100000,
                getTouchedSpotIndicator: defaultTouchedIndicator,
                // [
                //       TouchedSpotIndicatorData(
                //           FlLine(
                //             dashArray: [4, 4],
                //             color: Colors.grey,
                //           ),
                //           FlDotData(
                //             getDotPainter: (p0, p1, p2, p3) =>
                //                 FlDotCirclePainter(
                //                     color: Colors.blue,
                //                     radius: 8,
                //                     strokeColor: Colors.white,
                //                     strokeWidth: 3),
                //           )),
                //     ],
                touchTooltipData: LineTouchTooltipData(
                  // tooltipMargin: 20,
                  tooltipHorizontalOffset: 65,
                  // tooltipHorizontalAlignment: FLHorizontalAlignment.left,
                  maxContentWidth: 150,
                  // showOnTopOfTheChartBoxArea: true,
                  tooltipRoundedRadius: 8,
                  fitInsideHorizontally: true,
                  // fitInsideVertically: true,
                  tooltipBgColor: Colors.white,
                  getTooltipItems: (touchedSpots) {
                    return [
                      LineTooltipItem(
                          '${DateFormat('MMM d,y').format(DateTime.parse(widget.data[0].valueDate.toString()))}',
                          TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(text: '\nBalance'),
                            TextSpan(
                                text:
                                    "\nRs. ${formatter.format(touchedSpots[0].y)}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500))
                          ]),
                    ];
                  },
                )),
            titlesData: FlTitlesData(show: false),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                // preventCurveOverShooting: true,
                showingIndicators: showingTooltipOnSpots,
                dotData: FlDotData(show: false),
                isCurved: true,
                color: Color(0xff0B72EB),

                spots: spots,
              )
            ]),
      ),
    );
  }
}
