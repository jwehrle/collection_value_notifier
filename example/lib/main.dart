import 'dart:math';

import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'collection_value_notifier Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ListNotifier<int> _listNotifier = ListNotifier([0, 1, 2]);
  final SetNotifier<int> _setNotifier = SetNotifier({0, 1, 2});
  final MapNotifier<String, int> _mapNotifier =
      MapNotifier({'A': 0, 'B': 1, 'C': 2});

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
      map['A'] = Random().nextInt(9);
      map['B'] = Random().nextInt(9);
      map['C'] = Random().nextInt(9);
      return map;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Collections rebuild when they have changed without calling setState.'),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            const Text('You have shuffled the list:'),
            ListWidget(listListenable: _listNotifier),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            const Text('You have randomized a set:'),
            SetWidget(setListenable: _setNotifier),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            const Text('You have randomized map values:'),
            MapWidget(mapListenable: _mapNotifier),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Randomize the values',
        onPressed: _incrementCounter,
        label: const Text('Randomize'),
        icon: const Icon(Icons.numbers),
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