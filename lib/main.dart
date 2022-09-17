import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Subscribe Duration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isToggle = false;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectDate;

  int daysBetween(DateTime? from, DateTime to) {
    if (from == null) {
      return 0;
    } else {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inDays).round();
    }
  }

  int? get difference {
    return daysBetween(startDate, endDate ?? DateTime.now());
  }

  String get expiredDate {
    if (endDate == null) {
      return '-';
    } else {
      if (difference! >= 31) {
        var expire = DateTime(endDate!.year, endDate!.month + 1, endDate!.day);
        return expire.toString();
      } else {
        var expire = endDate!;
        return expire.toString();
      }
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a day you want to be your start subscription',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _isToggle ? null : _presentDatePicker,
              child: selectDate == null
                  ? const Text('Pick your date')
                  : Text(selectDate.toString()),
            ),
            const Divider(),
            Text(
                'Date you subscribe: for example ${startDate ?? 'a few month ago'}'),
            Text('Date you unsubscribe: ${endDate ?? 'Still subscribe us'}'),
            Text('Duration of your subscription: $difference'),
            Text('Expired: $expiredDate'),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isToggle = !_isToggle;
                });
                if (_isToggle) {
                  setState(() {
                    endDate;
                    expiredDate;
                    startDate = selectDate ?? DateTime(2022, 05, 08);
                  });
                } else {
                  endDate = DateTime.now();
                  daysBetween(startDate, endDate!);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: !_isToggle ? Colors.blueAccent : Colors.blueGrey,
              ),
              child: !_isToggle
                  ? const Text('Subscribe')
                  : const Text('Unsubscribe'),
            ),
            ElevatedButton(
              onPressed: expiredDate == '-' || _isToggle
                  ? null
                  : () {
                      setState(() {
                        startDate = null;
                        endDate = null;
                        selectDate = null;
                      });
                    },
              style: ElevatedButton.styleFrom(
                primary: startDate != null ? Colors.blueAccent : Colors.grey,
              ),
              child: const Text('Reset App'),
            ),
          ],
        ),
      ),
    );
  }
}
