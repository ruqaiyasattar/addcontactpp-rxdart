import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: const HomePage(),
    ),
  );
}

void testIt() async {
  final stream1 = Stream.periodic(
    const Duration(seconds: 1), (count) => 'Stream 1, count = $count',
  );

  final stream2 = Stream.periodic(
    const Duration(seconds: 3), (count) => 'Stream 2, count = $count',
  );

  final combine = Rx.combineLatest2(
    stream1,
    stream2,
        (one, two) => 'One is ($one), Two is ($two)',
  );
  await for(final value in combine) {
    value.log();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
    );
  }
}