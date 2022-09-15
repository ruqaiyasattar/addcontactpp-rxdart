import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Stream<String> getName({
  required String filePath,
}){
  final names = rootBundle.loadString(filePath);
  return Stream.fromFuture(names).transform(const LineSplitter());
}
Stream<String> getAllNames() => getName(filePath: 'assets/texts/cat.txt')
    .concatWith([getName(filePath: 'assets/texts/dog.txt')]);

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Concatenation with rxDart"),
      ),
      body: FutureBuilder<List<String>>(
        future: getAllNames().toList(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              final names = snapshot.requireData;
              return ListView.separated(
                itemCount: names.length,
                separatorBuilder: (_,__) => const Divider(color: Colors.black,),
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(names[index]),
                  );
                },
              );
          }
        },
      ),
    );
  }
}