import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //create a subject behavior object, everytime the widget is rebuilt
    final subject = useMemoized(
          () => BehaviorSubject<String>(),
          [key],
    );

    //dispose of the old obj, everytime the widget is rebuilt
    useEffect(
            () => subject.close,
            [subject],
    );

    return Scaffold(
     appBar: AppBar(
       title: StreamBuilder<String>(
         initialData: 'Please start typing...',
         stream: subject.stream
             .distinct()
             .debounceTime(const Duration(seconds: 1),
         ),
         builder: (context, snapshot){
           return Text(snapshot.requireData);
         },
       ),
     ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: subject.sink.add,

        ),
      ),
    );
  }
}