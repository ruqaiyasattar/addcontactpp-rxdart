import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This widget is the root of your application.
  
  late final  BehaviorSubject<DateTime> subject;
  late final  Stream<String> streamOfString;
  
  @override
  void initState() {
    super.initState();
    subject = BehaviorSubject<DateTime>();
    streamOfString = subject.switchMap((dateTime) =>
    Stream.periodic(
      const Duration(seconds: 1),
          (count) => 'Stream count = $count, dateTime = $dateTime',
    ),
    );
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: const Text("Home Page"),
     ),
      body: Column(
        children: [
          StreamBuilder<String>(
              stream: streamOfString,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  final string = snapshot.requireData;
                  return Text(string);
                } else {
                  return const Text('Waiting for the button to be pressed');
                }

              },
          ),
          TextButton(
              onPressed: (){
                subject.add(DateTime.now());
              },
              child:const Text('Start the Stream'),
          ),

        ],
      ),
    );
  }
}