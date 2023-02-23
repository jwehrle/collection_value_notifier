import 'dart:math';

import 'package:collection_value_notifier/collection_value_notifier.dart';
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
      debugShowCheckedModeBanner: false,
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

  /// This method no longer calls setState() - rather the Text Widgets
  /// associated with each notifier only rebuild when their underlying
  /// collections have changed.
  void _incrementCounter() {
    _listNotifier.syncEditBlock((list) {
      list.shuffle(Random());
      return list;
    });
    _setNotifier.syncEditBlock((set) {
      Random random = Random();
      final result = set.union(<int>{random.nextInt(9)});
      if (result.length > 3) {
        result.remove(result.first);
      }
      return result;
    });
    _mapNotifier.syncEditBlock((map) {
      map['0'] = Random().nextInt(9);
      map['1'] = Random().nextInt(9);
      map['2'] = Random().nextInt(9);
      return map;
    });
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
            const Text('Collections only rebuild when they have changed.'),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            const Text('You have shuffled the list:'),
            ListWidget(listListenable: _listNotifier),
            const Text('You have randomized a set:'),
            SetWidget(setListenable: _setNotifier),
            const Text('You have randomized map values:'),
            MapWidget(mapListenable: _mapNotifier),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Do something',
        child: const Icon(Icons.numbers),
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

/// Stateless widgets for changeable collections

class ListWidget extends StatelessWidget {
  final ListListenable<int> listListenable;

  const ListWidget({super.key, required this.listListenable});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium;
    return ListListenableBuilder<int>(
      valueListenable: listListenable,
      builder: (context, list, _) {
        return Text('$list', style: style);
      },
    );
  }
}

class SetWidget extends StatelessWidget {
  final SetListenable<int> setListenable;

  const SetWidget({super.key, required this.setListenable});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium;
    return SetListenableBuilder<int>(
      valueListenable: setListenable,
      builder: (context, set, _) {
        return Text('$set', style: style);
      },
    );
  }
}

class MapWidget extends StatelessWidget {
  final MapListenable<String, int> mapListenable;

  const MapWidget({super.key, required this.mapListenable});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium;
    return MapListenableBuilder<String, int>(
      valueListenable: mapListenable,
      builder: (context, map, _) {
        return Text('$map', style: style);
      },
    );
  }
}
