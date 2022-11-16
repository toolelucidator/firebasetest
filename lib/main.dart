import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textcontroller = TextEditingController();
  final databaseRef =
      FirebaseDatabase.instance.ref("Firebase IoT").child("Relay1");
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  String Data = ""; //Solo una cadena de texto

  //Add

  void AddData(String data) {
    databaseRef.set({'valor': data});
  }

  void PrintFromFireBase() {
    // databaseRef.child("FirebaseIOT").child("LatestReading").once().then((DatabaseEvent event) {print('test');} );
    databaseRef.once().then((DatabaseEvent event) {
      print(event.snapshot.value);
    });

    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref("Firebase IoT").child("Relay1");
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print(data);
    });
    /* databaseRef.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });*/
    //databaseRef.once().then((DataSnapshot _snapshot) {
    //print('Data on raw from snapshot ${_snapshot.value}');
    //});
  }

  void addlistener() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref("Firebase IoT").child("Relay1");
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print(data);
    });
  }

  /*Listener Methods*/

  /*void _onDataAdded(Event event){
    setState(() {
      Data = event.snapshot.value["valor"].toString();
      print("Data en tiempo real $Data");
    });
  }

  late StreamSubscription <Event> _onDataChangedListen;*/

  /*******************************************/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addlistener();
    // _onDataChangedListen = databaseRef.onValue.listen(_onDataAdded);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _onDataChangedListen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Firebase Insert and Get Demo"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: textcontroller,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          AddData(textcontroller.text);
                        },
                        color: Colors.greenAccent,
                        child: Text("Guardar a Firebase RTDB"),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          PrintFromFireBase();
                        },
                        color: Colors.redAccent,
                        child: Text("Obtener datos una vez desde Firebase"),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
