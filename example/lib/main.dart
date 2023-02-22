import 'dart:math';

import 'package:collection_value_notifier/collections.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ListNotifier<int> _listNotifier = ListNotifier([0, 1, 2]);
  final SetNotifier<int> _setNotifier = SetNotifier({0, 1, 2});
  final MapNotifier<String, int> _mapNotifier =
      MapNotifier({'0': 0, '1': 1, '2': 2});

  void _incrementCounter() {
    _listNotifier.syncEditBlock((list) {
      list.shuffle(Random());
      return list;
    });
    _setNotifier.collection = Set.from(_setNotifier.value.map((e) => e + 1));
    _mapNotifier.collection = Map.from(
        _mapNotifier.value.map((key, value) => MapEntry(key, value + 1)));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have shuffled the list:',
            ),
            ListValueListenableBuilder<int>(
                valueListenable: _listNotifier,
                builder: (context, list, _) {
                  return Text(
                    '$list',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }),
            const Text(
              'You have incremented the elements of the set:',
            ),
            SetListenableBuilder<int>(
                valueListenable: _setNotifier,
                builder: (context, set, _) {
                  return Text(
                    '$set',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }),
            const Text(
              'You have incremented the values of the map:',
            ),
            MapValueListenableBuilder<String, int>(
                valueListenable: _mapNotifier,
                builder: (context, map, _) {
                  return Text(
                    '$map',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Do something',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _listNotifier.dispose();
    _setNotifier.dispose();
    _mapNotifier.dispose();
    super.dispose();
  }
}
