import 'package:collection_value_notifier/collection_value_notifier.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('description', (widgetTester) async {
    ListNotifier<String> listNotifier = ListNotifier(['a', 'b', 'c', 'd']);
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Material(
          child: ListBuilderTestBed(listenable: listNotifier),
        ),
      ),
    );
    final aFinderBefore = find.text('a');
    final bFinderBefore = find.text('b');
    final cFinderBefore = find.text('c');
    final dFinderBefore = find.text('d');
    expect(aFinderBefore, findsOneWidget);
    expect(bFinderBefore, findsOneWidget);
    expect(cFinderBefore, findsOneWidget);
    expect(dFinderBefore, findsOneWidget);
    listNotifier.remove('b');
    await widgetTester.pumpAndSettle();
    final aFinderAfter = find.text('a');
    final bFinderAfter = find.text('b');
    final cFinderAfter = find.text('c');
    final dFinderAfter = find.text('d');
    expect(aFinderAfter, findsOneWidget);
    expect(bFinderAfter, findsNothing);
    expect(cFinderAfter, findsOneWidget);
    expect(dFinderAfter, findsOneWidget);
    listNotifier.dispose();
  });

  testWidgets('description', (widgetTester) async {
    SetNotifier<String> setNotifier = SetNotifier({'a', 'b', 'c', 'd'});
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SetBuilderTestBed(listenable: setNotifier),
        ),
      ),
    );
    final aFinderBefore = find.text('a');
    final bFinderBefore = find.text('b');
    final cFinderBefore = find.text('c');
    final dFinderBefore = find.text('d');
    expect(aFinderBefore, findsOneWidget);
    expect(bFinderBefore, findsOneWidget);
    expect(cFinderBefore, findsOneWidget);
    expect(dFinderBefore, findsOneWidget);
    setNotifier.remove('b');
    await widgetTester.pumpAndSettle();
    final aFinderAfter = find.text('a');
    final bFinderAfter = find.text('b');
    final cFinderAfter = find.text('c');
    final dFinderAfter = find.text('d');
    expect(aFinderAfter, findsOneWidget);
    expect(bFinderAfter, findsNothing);
    expect(cFinderAfter, findsOneWidget);
    expect(dFinderAfter, findsOneWidget);
    setNotifier.dispose();
  });

  testWidgets('description', (widgetTester) async {
    MapNotifier<String, String> mapNotifier =
    MapNotifier({'a': 'A', 'b': 'B', 'c': 'C', 'd': 'D'});
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Material(
          child: MapBuilderTestBed(listenable: mapNotifier),
        ),
      ),
    );
    final aFinderBefore = find.text('a : A');
    final bFinderBefore = find.text('b : B');
    final cFinderBefore = find.text('c : C');
    final dFinderBefore = find.text('d : D');
    expect(aFinderBefore, findsOneWidget);
    expect(bFinderBefore, findsOneWidget);
    expect(cFinderBefore, findsOneWidget);
    expect(dFinderBefore, findsOneWidget);
    mapNotifier.remove('b');
    await widgetTester.pumpAndSettle();
    final aFinderAfter = find.text('a : A');
    final bFinderAfter = find.text('b : B');
    final cFinderAfter = find.text('c : C');
    final dFinderAfter = find.text('d : D');
    expect(aFinderAfter, findsOneWidget);
    expect(bFinderAfter, findsNothing);
    expect(cFinderAfter, findsOneWidget);
    expect(dFinderAfter, findsOneWidget);
    mapNotifier.dispose();
  });
}

class ListBuilderTestBed extends StatelessWidget {
  final ListListenable<String> listenable;

  const ListBuilderTestBed({Key? key, required this.listenable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListListenableBuilder<String>(
      valueListenable: listenable,
      builder: (context, list, _) {
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(list[index]),
            );
          },
        );
      },
    );
  }
}

class SetBuilderTestBed extends StatelessWidget {
  final SetListenable<String> listenable;

  const SetBuilderTestBed({Key? key, required this.listenable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SetListenableBuilder<String>(
      valueListenable: listenable,
      builder: (context, set, _) {
        return ListView.builder(
          itemCount: set.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(set.elementAt(index)),
            );
          },
        );
      },
    );
  }
}

class MapBuilderTestBed extends StatelessWidget {
  final MapListenable<String, String> listenable;

  const MapBuilderTestBed({Key? key, required this.listenable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapListenableBuilder<String, String>(
      valueListenable: listenable,
      builder: (context, map, _) {
        final mapList = map.entries.toList();
        return ListView.builder(
          itemCount: mapList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${mapList[index].key} : ${mapList[index].value}'),
            );
          },
        );
      },
    );
  }
}
