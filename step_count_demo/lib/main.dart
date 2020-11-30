import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: readStepCount,
        tooltip: 'Step Count',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> readStepCount() async {
    Map<DataType, List<FitData>> results = Map();
    DateTime toDay = DateTime.now();
    DateTime _dateFrom = DateTime(toDay.year, toDay.month, toDay.day);
    DateTime _dateTo = toDay;

    try {
      bool permissions = await FitKit.requestPermissions([DataType.STEP_COUNT]);
      if (!permissions) {
        print('requestPermissions: failed');
      } else {
        try {
          results[DataType.STEP_COUNT] = await FitKit.read(
            DataType.STEP_COUNT,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
          );
        } on UnsupportedException catch (e) {
          results[e.dataType] = [];
        }

        print('readAll: success');
        final item = results.entries.expand((entry) => [entry.key, ...entry.value]).toList();
        int steps = 0;
        item.forEach((element) {
          if (element is FitData) {
            print('MyStep Data -- $item');
            steps += element.value;
          }
        });
        print('MyFinalSteps -- $steps');
        setState(() {
          _counter = steps;
        });
      }
    } catch (e) {
      print('readAll: $e');
    }
  }
}
