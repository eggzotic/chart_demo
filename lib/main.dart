import 'package:chart_demo/state/my_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MyState(slots: 50),
      builder: (_, __) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chart Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget chartToRun({
    required List<List<double>> dataRows,
    required List<String> xAxisData,
    required List<String> legends,
  }) {
    // LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions(
      lineChartOptions: LineChartOptions(
        hotspotInnerRadius: 1,
        hotspotOuterRadius: 1,
        hotspotInnerPaintColor: Colors.black,
        hotspotOuterPaintColor: Colors.black,
        lineStrokeWidth: 2,
      ),
    );
    chartData = ChartData(
      dataRows: dataRows,
      xUserLabels: xAxisData,
      dataRowsLegends: legends,
      chartOptions: chartOptions,
      dataRowsColors: const [Colors.blue, Colors.purple],
    );
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      // xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyState>(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts Demo'),
        actions: [
          if (appState.ready)
            TextButton(
              onPressed: () => appState.pauseResume(),
              child: Text(
                appState.paused ? 'Resume' : "Pause",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (appState.ready)
            TextButton(
              onPressed: () => appState.stop(),
              child: const Text(
                'Stop',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: !appState.started
          ? Center(
              child: ElevatedButton(
                onPressed: () => appState.start(),
                child: const Text('Start'),
              ),
            )
          : appState.ready
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.height * .8,
                    child: chartToRun(
                      dataRows: appState.dataRows,
                      xAxisData: appState.xAxisData,
                      legends: appState.dataLegends,
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
