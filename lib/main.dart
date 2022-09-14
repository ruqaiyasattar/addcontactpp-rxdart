import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum TypeOfThings{ animal, person }

@immutable
class Thing {
  final TypeOfThings type;
  final String name;

  const Thing({
    required this.name,
    required this.type,
  });
}

@immutable
class Bloc{
  final Sink<TypeOfThings?> setTypeOfThing; //write only
  final Stream<TypeOfThings?> currentTypeOfThing; //read only
  final Stream<Iterable<Thing>> things;  //read-only

  const Bloc._({
    required this.setTypeOfThing,
    required this.currentTypeOfThing,
    required this.things,
  });


  void dispose() {
    setTypeOfThing.close();
  }

  factory Bloc({
    required Iterable<Thing> things,
}){
    final typeOfThingSubject = BehaviorSubject<TypeOfThings?>();

    final filteredThings = typeOfThingSubject
        .debounceTime(const Duration(milliseconds: 300))
        .map<Iterable<Thing>>((typeOfThing) {
          if (typeOfThing != null) {
            return things.where((thing) => thing.type == typeOfThing);
          }  else {
            return things;
          }
    }).startWith(things);

    return Bloc._(
        setTypeOfThing: typeOfThingSubject.sink,
        currentTypeOfThing: typeOfThingSubject.stream,
        things: filteredThings,
    );
}
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

const things = [
  Thing(name: 'Foo',type: TypeOfThings.person),
  Thing(name: 'Bar',type: TypeOfThings.person),
  Thing(name: 'Baz',type: TypeOfThings.person),
  Thing(name: 'Bunz',type: TypeOfThings.animal),
  Thing(name: 'Fluffers',type: TypeOfThings.animal),
  Thing(name: 'Woofz',type: TypeOfThings.animal),
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This widget is the root of your application.
  late final Bloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = Bloc(
      things:things,
    );
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
       title: const Text("FilterChip with RxDart"),
     ),
      body: Column(
        children: [
          StreamBuilder<TypeOfThings?>(
              stream: bloc.currentTypeOfThing,
              builder: (context, snapshot){
                final selectedTypeOfthing = snapshot.data;
                return Wrap(children: TypeOfThings.values.map((typeOfThings) {
                  return FilterChip(
                      selectedColor: Colors.blueAccent[100],
                      label: Text(typeOfThings.name),
                      onSelected: (selected){
                        final type  = selected ? typeOfThings : null;
                        bloc.setTypeOfThing.add(type);
                      },
                    selected: selectedTypeOfthing == typeOfThings,
                  );
                }).toList(),);
              },
          ),
          Expanded(child: StreamBuilder<Iterable<Thing>>(
            stream: bloc.things,
            builder: (context, snapshot){
              final things = snapshot.data ?? [];
              return ListView.builder(
                  itemCount: things.length,
                  itemBuilder: (context , index){
                    final thing = things.elementAt(index);
                    return ListTile(
                      title: Text(thing.name),
                      subtitle: Text(thing.type.name),
                    );
              });
            },
          ),
          ),
        ]
      ),
    );
  }
}