import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pollutrack_26/model/heart_rate.dart';
import 'package:pollutrack_26/model/inhalation_rate.dart';
import 'package:pollutrack_26/model/pm_25.dart';

class TimeSeriesPoint {
  const TimeSeriesPoint({required this.timestamp, required this.value});

  final DateTime timestamp;
  final double value;
}

class TimeSeriesPlot extends StatelessWidget {
  const TimeSeriesPlot({
    super.key,
    required this.points,
    required this.lineColor,
    required this.emptyMessage,
    this.valueDecimals = 2,
  });

  final List<TimeSeriesPoint> points;
  final Color lineColor;
  final String emptyMessage;
  final int valueDecimals;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    final sortedPoints = [...points]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final firstTimestamp = sortedPoints.first.timestamp;

    final spots = sortedPoints
        .map(
          (e) => FlSpot(
            e.timestamp.difference(firstTimestamp).inMinutes.toDouble(),
            e.value,
          ),
        )
        .toList();

    final minY = sortedPoints
        .map((e) => e.value)
        .reduce((a, b) => a < b ? a : b);
    final maxY = sortedPoints
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final yRange = (maxY - minY).abs();
    final yPadding = yRange < 0.01 ? 1.0 : yRange * 0.15;

    final xMax = spots.last.x;
    final tickCount = spots.length < 5 ? spots.length : 5;
    final xInterval = tickCount <= 1 || xMax <= 0
        ? 1.0
        : xMax / (tickCount - 1);
    final yInterval = yPadding <= 0 ? 1.0 : yPadding;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: xMax == 0 ? 1 : xMax,
        minY: minY - yPadding,
        maxY: maxY + yPadding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: yInterval,
          verticalInterval: xInterval,
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: yInterval,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                final date = firstTimestamp.add(
                  Duration(minutes: value.round()),
                );
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    DateFormat('HH:mm').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.black12),
            bottom: BorderSide(color: Colors.black12),
            right: BorderSide.none,
            top: BorderSide.none,
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final ts = firstTimestamp.add(
                  Duration(minutes: spot.x.round()),
                );
                return LineTooltipItem(
                  '${DateFormat('HH:mm').format(ts)}\n${spot.y.toStringAsFixed(valueDecimals)}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2,
            color: lineColor,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withOpacity(0.45),
                  lineColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<TimeSeriesPoint> filterPointsByDay({
  required List<TimeSeriesPoint> points,
  required DateTime selectedDate,
}) {
  return points.where((e) {
    return e.timestamp.year == selectedDate.year &&
        e.timestamp.month == selectedDate.month &&
        e.timestamp.day == selectedDate.day;
  }).toList();
}


class CustomPlotHR extends StatelessWidget {
  const CustomPlotHR({
    super.key,
    required this.hrData,
    required this.selectedDate,
  });

  final List<HR> hrData;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final points = filterPointsByDay(
      points: hrData
          .map(
            (e) => TimeSeriesPoint(
              timestamp: e.timestamp,
              value: e.value.toDouble(),
            ),
          )
          .toList(),
      selectedDate: selectedDate,
    );

    return TimeSeriesPlot(
      points: points,
      lineColor: const Color(0xFF89453C),
      emptyMessage: 'No heart rate data available',
      valueDecimals: 0,
    );
  }
}

class CustomPlotPM extends StatelessWidget {
  const CustomPlotPM({
    super.key,
    required this.pm25Data,
    required this.selectedDate,
  });

  final List<PM25> pm25Data;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final points = filterPointsByDay(
      points: pm25Data
          .map((e) => TimeSeriesPoint(timestamp: e.timestamp, value: e.value))
          .toList(),
      selectedDate: selectedDate,
    );

    return TimeSeriesPlot(
      points: points,
      lineColor: const Color.fromARGB(255, 2, 21, 96),
      emptyMessage: 'No PM2.5 data available',
      valueDecimals: 2,
    );
  }
}

class CustomPlotExposure extends StatelessWidget {
  const CustomPlotExposure({
    super.key,
    required this.exposureData,
    required this.selectedDate,
  });

  final List<InhalationRate> exposureData;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final points = filterPointsByDay(
      points: exposureData
          .map((e) => TimeSeriesPoint(timestamp: e.timestamp, value: e.value))
          .toList(),
      selectedDate: selectedDate,
    );

    return TimeSeriesPlot(
      points: points,
      lineColor: const Color.fromARGB(255, 2, 21, 96),
      emptyMessage: 'No exposure data available',
      valueDecimals: 2,
    );
  }
}
