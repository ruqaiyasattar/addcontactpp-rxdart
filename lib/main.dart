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
    const Duration(seconds: 1),
        (count) => 'Stream 1, count = $count',
  );

  final stream2 = Stream.periodic(
    const Duration(seconds: 1),
        (count) => 'Stream 2, count = $count',
  );
  final result = Rx.zip2(
      stream1,
      stream2,
          (one, two) => 'Zipped result, A = {$one}, B = {$two}',
  );
  await for(final value in result){
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