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

@immutable
class Bloc{
  final Sink<String?> setFirstName; //write only
  final Sink<String?> setLastName;  //write only
  final Stream<String> fullName;

  Bloc._({
    required this.setFirstName,
    required this.setLastName,
    required this.fullName,
  }); //read only

  void dispose(){
    setFirstName.close();
    setLastName.close();
  }

  factory Bloc(){
    final firstNameSubject = BehaviorSubject<String?>();
    final lastNameSubject = BehaviorSubject<String?>();
    final Stream<String> fullName = Rx.combineLatest2(
        firstNameSubject.startWith(null),
        lastNameSubject.startWith(null),
            (String? firstName, String? lastName) {
          if (firstName != null &&
              firstName.isNotEmpty &&
              lastName != null &&
              lastName.isNotEmpty)  {
            return '$firstName $lastName';
          }  else {
            return 'Both first and last name must be provided';
          }
        });

    return Bloc._(
      setFirstName: firstNameSubject.sink,
      setLastName: lastNameSubject.sink,
      fullName: fullName,
    );
  }
}

typedef AsyncSnapshotBuilderCallBack<T> = Widget Function(
    BuildContext context,
    T? value,
    );

class AsyncSnapshotBuilder<T> extends StatelessWidget{
  final Stream<T> stream;
  final AsyncSnapshotBuilderCallBack<T>? onNone;
  final AsyncSnapshotBuilderCallBack<T>? onWaiting;
  final AsyncSnapshotBuilderCallBack<T>? onActive;
  final AsyncSnapshotBuilderCallBack<T>? onDone;

  const AsyncSnapshotBuilder({
    Key? key,
    required this.stream,
    this.onNone,
    this.onWaiting,
    this.onActive,
    this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
            final callback = onNone ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data,);
          case ConnectionState.waiting:
            final callback = onWaiting ?? (_, __) => const CircularProgressIndicator();
            return callback(context, snapshot.data,);
          case ConnectionState.active:
            final callback = onActive ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data, );
          case ConnectionState.done:
            final callback = onDone ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data, );
        }
      },
    );
  }

}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  late final Bloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = Bloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CombineLatest with RxDart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter first name here....',
              ),
              onChanged: bloc.setFirstName.add,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter last name here....',
              ),
              onChanged: bloc.setLastName.add,
            ),
            AsyncSnapshotBuilder<String>(
              stream: bloc.fullName,
              onActive: (context, String? value){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(value ?? ''),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}