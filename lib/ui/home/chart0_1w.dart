import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class Chart01w extends StatefulWidget {

  const Chart01w({super.key});

  @override
  State<Chart01w> createState() => _Chart01wState();
}

class _Chart01wState extends State<Chart01w> {
  
  late List<_ChartData> data;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    data = [
      _ChartData('23/09', 12),
      _ChartData('24/09', 15),
      _ChartData('25/09', 30),
      _ChartData('26/09', 6.4),
      _ChartData('27/09', 14),
      _ChartData('28/09', 14),
      _ChartData('29/09', 14),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFECEEFF).withValues(alpha: 0.8),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Total Weekly Upcoming Appointments',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Next 7 Days',
              style: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                color: kTextColor2,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              '16',
              style: kTextStyle1.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFFE8900),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(
              arrangeByIndex: true,
              labelRotation: 25,
              labelStyle: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: kTextStyle1.copyWith(
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              canShowMarker: true,
              textStyle: const TextStyle(
                fontFamily: kBodyFont,
              ),
            ),
            series: <CartesianSeries<_ChartData, String>>[
              ColumnSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'Total',
                color: const Color(0xFFFE8900),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(2.0), topRight: Radius.circular(2.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartData {
 
  final String x;
  final double y;

  _ChartData(this.x, this.y);
}