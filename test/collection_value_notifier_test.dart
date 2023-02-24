// Impossible to mock list with mockito or mocktail

// import 'dart:developer' as dev;
// import 'dart:math';
import 'dart:async';
import 'dart:ui';

import 'package:collection_value_notifier/src/extensions.dart';
import 'package:collection_value_notifier/collection_value_notifier.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ListNotifier tests', () {
    test('ListNotifier shallow should notify', () {
      final ListNotifier<String> listNotifier =
          ListNotifier<String>(['a', 'b', 'c']);
      bool didChange = false;
      listNotifier.addListener(() {
        didChange = true;
      });
      listNotifier.value = ['z', 'b', 'c'];
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
    });

    test('ListNotifier deep should notify', () {
      final ListNotifier<Map> listNotifier = ListNotifier<Map>([
        {'a': true},
        {'b': true},
        {'c': true}
      ]);
      bool didChange = false;
      listNotifier.addListener(() {
        didChange = true;
      });
      listNotifier.value = [
        {'a': true},
        {'b': false},
        {'c': true}
      ];
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
    });

    test('collection setter', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.collection = [4, 5, 6];
      expect(sut.value, [4, 5, 6]);
      expect(didChange, true);
      sut.dispose();
    });

    test('first setter', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.first = 10;
      expect(sut.value, [10, 1, 2]);
      expect(didChange, true);
      sut.dispose();
    });

    test('last setter', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.last = 10;
      expect(sut.value, [0, 1, 10]);
      expect(didChange, true);
      sut.dispose();
    });

    test('first', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      int result = sut.first;
      expect(result, 0);
      sut.dispose();
    });

    test('last', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      int result = sut.last;
      expect(result, 2);
      sut.dispose();
    });

    test('length', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      int result = sut.length;
      expect(result, 3);
      sut.dispose();
    });

    test('isEmpty', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool result = sut.isEmpty;
      expect(result, false);
      sut.dispose();
    });

    test('isNotEmpty', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool result = sut.isNotEmpty;
      expect(result, true);
      sut.dispose();
    });

    test('iterator', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.iterator;
      expect(result, TypeMatcher<Iterator<int>>());
      sut.dispose();
    });

    test('reversed', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.reversed;
      expect(result.first, 2);
      expect(result.last, 0);
      sut.dispose();
    });

    test('single', () {
      List<int> list = [0];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.single;
      expect(result, 0);
      sut.dispose();
    });

    test('operator +', () {
      List<int> list1 = [0, 1];
      List<int> list2 = [2];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut + list2;
      expect(result, [0, 1, 2]);
      sut.dispose();
    });

    test('operator []', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut[0];
      expect(result, 0);
      sut.dispose();
    });

    test('operator []=', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut[0] = 1;
      expect(list[0], 1);
      expect(didChange, true);
      sut.dispose();
    });

    test('add', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.add(3);
      expect(sut.value, [0, 1, 2, 3]);
      expect(didChange, true);
      sut.dispose();
    });

    test('addAll', () {
      List<int> list = [0, 1, 2];
      List<int> testAdd = [3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.addAll(testAdd);
      expect(sut.value, [0, 1, 2, 3, 4, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('any', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.any((e) => e.isOdd);
      expect(result, true);
      sut.dispose();
    });

    test('asyncEditBlock', () async {
      ListNotifier<int> sut = ListNotifier<int>([0, 1, 2]);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.asyncEditBlock((list) async {
        return [3, 4, 5];
      });
      await Future.delayed(Duration(seconds: 1));
      expect(didChange, true);
      expect(sut.value, [3, 4, 5]);
      sut.dispose();
    });

    test('asMap', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.asMap();
      expect(result, {0: 0, 1: 1, 2: 2});
      sut.dispose();
    });

    test('cast', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.cast<double>();
      expect(result, TypeMatcher<List<double>>());
      sut.dispose();
    });

    test('clear', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.clear();
      expect(sut.isEmpty, true);
      expect(didChange, true);
      sut.dispose();
    });

    test('completerEditBlock', () async {
      ListNotifier<int> sut = ListNotifier<int>([0, 1, 2]);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      Completer<List<int>> completer = Completer();
      sut.completerEditBlock(completer);
      completer.complete([3, 4, 5]);
      await Future.delayed(Duration(seconds: 1));
      expect(didChange, true);
      expect(sut.value, [3, 4, 5]);
      sut.dispose();
    });

    test('contains', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.contains(2);
      expect(result, true);
      sut.dispose();
    });

    test('every', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.every((e) => e.isEven);
      expect(result, false);
      sut.dispose();
    });

    test('expand', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.expand((e) => [e + 1, e + 2]);
      expect(result.toList(), <int>[1, 2, 2, 3, 3, 4]);
      sut.dispose();
    });

    test('expandIndexed', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.expandIndexed((i, e) => [e + i, e + i]);
      expect(result.toList(), <int>[0, 0, 2, 2, 4, 4]);
      sut.dispose();
    });

    test('fillRange', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.fillRange(1, 4, 100);
      expect(sut.value, [0, 100, 100, 100, 4, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('firstWhere', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.firstWhere((e) => e > 1, orElse: () => -1);
      expect(result, 2);
      sut.dispose();
    });

    test('firstWhereIndexedOrNull, contains', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.firstWhereIndexedOrNull((i, e) => (i + e) > 3);
      expect(result, 2);
      sut.dispose();
    });

    test('firstWhereIndexedOrNull, does not contain', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.firstWhereIndexedOrNull((i, e) => (i + e) > 10);
      expect(result, null);
      sut.dispose();
    });

    test('firstWhereOrNull, contains', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.firstWhereOrNull((e) => e > 3);
      expect(result, 4);
      sut.dispose();
    });

    test('firstWhereOrNull, does not contain', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.firstWhereOrNull((e) => e > 5);
      expect(result, null);
      sut.dispose();
    });

    test('fold', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.fold<int>(10, (p, e) => p + e);
      expect(result, 13);
      sut.dispose();
    });

    test('foldIndexed', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.foldIndexed<int>(10, (i, p, e) => p + e + i);
      expect(result, 16);
      sut.dispose();
    });

    test('followedBy', () {
      List<int> list = [0, 1, 2];
      List<int> other = [3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.followedBy(other);
      expect(result.toList(), <int>[0, 1, 2, 3, 4, 5]);
      sut.dispose();
    });

    test('forEach', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      var result0;
      var result1;
      var result2;
      sut.forEach((e) {
        if (e == 0) {
          result0 = e;
        }
        if (e == 1) {
          result1 = e;
        }
        if (e == 2) {
          result2 = e;
        }
      });
      expect(result0, 0);
      expect(result1, 1);
      expect(result2, 2);
      sut.dispose();
    });

    test('forEachIndexed', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      int sum = 0;
      sut.forEachIndexed((i, e) {
        sum += i + e;
      });
      expect(sum, 30);
      sut.dispose();
    });

    test('forEachIndexedWhile', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      int callCount = 0;
      sut.forEachIndexedWhile((i, e) {
        callCount++;
        return e < 3 && i < 2;
      });
      expect(callCount, 3);
      sut.dispose();
    });

    test('forEachWhile', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      int callCount = 0;
      sut.forEachWhile((e) {
        callCount++;
        return e < 3;
      });
      expect(callCount, 4);
      sut.dispose();
    });

    test('getRange', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.getRange(1, 3);
      expect(result, TypeMatcher<Iterable<int>>());
      expect(result.toList(), <int>[1, 2]);
      sut.dispose();
    });

    test('groupFoldBy', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.groupFoldBy((e) => e.isEven, (int? previous, int e) {
        return (previous ?? 0) + e;
      });
      expect(result, {true: 6, false: 9});
      sut.dispose();
    });

    test('groupListsBy', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.groupListsBy((e) => e.isEven);
      expect(result, {
        true: <int>[0, 2, 4],
        false: <int>[1, 3, 5]
      });
      sut.dispose();
    });

    test('groupSetsBy', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.groupSetsBy((e) => e.isEven);
      expect(result, {
        true: <int>{0, 2, 4},
        false: <int>{1, 3, 5}
      });
      sut.dispose();
    });

    test('indexOf', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.indexOf(4, 2);
      expect(result, 4);
      sut.dispose();
    });

    test('indexWhere', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.indexWhere((e) => e > 4, 2);
      expect(result, 5);
      sut.dispose();
    });

    test('insert', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.insert(1, 5);
      expect(list, [0, 5, 1, 2]);
      expect(didChange, true);
      sut.dispose();
    });

    test('insertAll', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.insertAll(1, [12, 13]);
      expect(list, [0, 12, 13, 1, 2]);
      expect(didChange, true);
      sut.dispose();
    });

    test('isSorted', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.isSorted((a, b) => a.compareTo(b));
      expect(result, true);
      sut.dispose();
    });

    test('isSortedBy', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.isSortedBy<num>((e) => e);
      expect(result, true);
      sut.dispose();
    });

    test('isSortedBy', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result =
          sut.isSortedByCompare((e) => e, (int a, int b) => a.compareTo(b));
      expect(result, true);
      sut.dispose();
    });

    test('join', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.join(", ");
      expect(result, '0, 1, 2');
      sut.dispose();
    });

    test('lastIndexOf', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.lastIndexOf(2, 4);
      expect(result, 3);
      sut.dispose();
    });

    test('lastIndexWhere', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.lastIndexWhere((e) => e < 4, 4);
      expect(result, 3);
      sut.dispose();
    });

    test('lastWhere', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.lastWhere((e) => e < 4, orElse: () => -1);
      expect(result, 2);
      sut.dispose();
    });

    test('lastWhereIndexedOrNull present', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.lastWhereIndexedOrNull((i, e) => i > 1 && e < 4);
      expect(result, 2);
      sut.dispose();
    });

    test('lastWhereIndexedOrNull not present', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.lastWhereIndexedOrNull((i, e) => i > 4 && e < 2);
      expect(result, null);
      sut.dispose();
    });

    test('lastWhereOrNull present', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.lastWhereOrNull((e) => e < 4);
      expect(result, 2);
      sut.dispose();
    });

    test('lastWhereOrNull not present', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.lastWhereOrNull((e) => e > 45);
      expect(result, null);
      sut.dispose();
    });

    test('map', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.map((e) => <int>{e});
      expect(result, [
        {0},
        {1},
        {2},
        {2},
        {4},
        {5}
      ]);
      sut.dispose();
    });

    test('mapIndexed', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.mapIndexed((i, e) => <int>{e * i});
      expect(result, [
        {0},
        {1},
        {4},
        {6},
        {16},
        {25}
      ]);
      sut.dispose();
    });

    test('none', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.none((p0) => p0.isNegative);
      expect(result, true);
      sut.dispose();
    });

    test('reduce', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.reduce((value, e) => value += e);
      expect(result, 14);
      sut.dispose();
    });

    test('reduceIndexed', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.reduceIndexed((i, previous, e) => previous += (e * i));
      expect(result, 52);
      sut.dispose();
    });

    test('remove', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      final result = sut.remove(4);
      expect(result, true);
      expect(sut.value, [0, 1, 2, 2, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('removeAt', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      final result = sut.removeAt(3);
      expect(result, 2);
      expect(sut.value, [0, 1, 2, 4, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('removeLast', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      final result = sut.removeLast();
      expect(result, 5);
      expect(sut.value, [0, 1, 2, 2, 4]);
      expect(didChange, true);
      sut.dispose();
    });

    test('removeRange', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.removeRange(1, 4);
      expect(sut.value, [0, 4, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('removeWhere', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.removeWhere((e) => e.isEven);
      expect(sut.value, [1, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('reorder, extreme increasing index', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.reorder(0, 5);
      expect(sut.value, [1, 2, 3, 4, 5, 0]);
      expect(didChange, true);
      sut.dispose();
    });

    test('reorder, extreme decreasing index', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.reorder(5, 0);
      expect(sut.value, [5, 0, 1, 2, 3, 4]);
      expect(didChange, true);
      sut.dispose();
    });

    test('reorder, increasing index by one', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.reorder(2, 1);
      expect(sut.value, [0, 2, 1, 3, 4, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('reorder, decreasing index by one', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.reorder(1, 2);
      expect(sut.value, [0, 2, 1, 3, 4, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('replaceRange', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.replaceRange(1, 5, [8, 9]);
      expect(sut.value, [0, 8, 9, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('retainWhere', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.retainWhere((e) => e.isEven);
      expect(sut.value, [0, 2, 4]);
      expect(didChange, true);
      sut.dispose();
    });

    test('reverseRange', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.reverseRange(1, 5);
      expect(sut.value, [0, 4, 3, 2, 1, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    // Intentionally Not Testing shuffle and shuffleRange since there is no
    // deductive test for randomness.

    test('singleWhere', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.singleWhere((e) => e == 1, orElse: () => -1);
      expect(result, 1);
      sut.dispose();
    });

    test('singleWhereIndexedOrNull present', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.singleWhereIndexedOrNull((i, e) => e.isOdd && i > 7);
      expect(result, 9);
      sut.dispose();
    });

    test('singleWhereIndexedOrNull too many', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.singleWhereIndexedOrNull((i, e) => e.isOdd && i > 3);
      expect(result, null);
      sut.dispose();
    });

    test('singleWhereOrNull too many', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.singleWhereOrNull((e) => e.isOdd);
      expect(result, null);
      sut.dispose();
    });

    test('singleWhereOrNull present', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.singleWhereOrNull((e) => e.isOdd && e > 8);
      expect(result, 9);
      sut.dispose();
    });

    test('singleWhereOrNull too many', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.singleWhereOrNull((e) => e.isOdd);
      expect(result, null);
      sut.dispose();
    });

    test('skip', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.skip(2);
      expect(result.toList(), <int>[2, 3, 4, 5]);
      sut.dispose();
    });

    test('skipWhile', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.skipWhile((e) => e < 2);
      expect(result.toList(), <int>[2, 3, 4, 5]);
      sut.dispose();
    });

    test('setAll', () {
      List<String> list = ['a', 'b', 'c', 'd'];
      ListNotifier<String> sut = ListNotifier<String>(list);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.setAll(1, ['bee', 'see']);
      expect(sut.value, ['a', 'bee', 'see', 'd']);
      expect(didChange, true);
      sut.dispose();
    });

    test('setRange', () {
      List<int> list1 = [1, 2, 3, 4];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.setRange(1, 3, [5, 6, 7, 8, 9], 3);
      expect(sut.value, [1, 8, 9, 4]);
      expect(didChange, true);
      sut.dispose();
    });

    test('slices', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.slices(2);
      expect(result, [
        [1, 0],
        [2, 1],
        [5, 7],
        [6, 8],
        [9]
      ]);
      sut.dispose();
    });

    test('sort', () {
      List<int> list1 = [10, 2, -3, 4];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.sort((e1, e2) => e1.compareTo(e2));
      expect(sut.value, [-3, 2, 4, 10]);
      expect(didChange, true);
      sut.dispose();
    });

    test('sortBy', () {
      List<int> list1 = [10, 2, 3, 4];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.sortBy<String>((p0) {
        if (p0 == 10) {
          return 'ten';
        }
        if (p0 == 2) {
          return 'two';
        }
        if (p0 == 3) {
          return 'three';
        }
        return 'four';
      });
      expect(sut.value, [10, 2, 3, 4]);
      expect(didChange, true);
      sut.dispose();
    });

    test('sortRange', () {
      List<int> list1 = [10, 2, 3, 4, 0, 7, -5];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.sortRange(1, 6, (a, b) => a.compareTo(b));
      expect(sut.value, [10, 0, 2, 3, 4, 7, -5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('sortedByCompare', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result =
          sut.sortedByCompare((e) => e * 2, (int a, int b) => a.compareTo(b));
      expect(result, [0, 1, 1, 2, 5, 6, 7, 8, 9]);
      sut.dispose();
    });

    test('splitAfter', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.splitAfter((a) => a.isOdd);
      expect(result, [
        [1],
        [0, 2, 1],
        [5],
        [7],
        [6, 8, 9]
      ]);
      sut.dispose();
    });

    test('splitBeforeIndexed', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.splitBetween((i, e) => i < e);
      expect(result, [
        [1, 0],
        [2, 1],
        [5],
        [7, 6],
        [8],
        [9]
      ]);
      sut.dispose();
    });

    test('splitBetween', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.splitBetween((a, b) => a > b);
      expect(result, [
        [1],
        [0, 2],
        [1, 5, 7],
        [6, 8, 9]
      ]);
      sut.dispose();
    });

    test('splitBetweenIndexed', () {
      List<int> list1 = [1, 0, 2, 1, 5, 7, 6, 8, 9];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.splitBeforeIndexed((i, e) => i < e);
      expect(result, [
        [1, 0, 2, 1],
        [5],
        [7, 6],
        [8],
        [9]
      ]);
      sut.dispose();
    });

    test('sublist', () {
      List<int> list1 = [10, 2, 3, 4, 0, 7, -5];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.sublist(1, 5);
      expect(result, [2, 3, 4, 0]);
      sut.dispose();
    });

    test('swap', () {
      List<int> list1 = [10, 2, 3, 4, 0, 7, -5];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.swap(1, 5);
      expect(sut.value, [10, 7, 3, 4, 0, 2, -5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('syncEditBlock', () {
      List<int> list1 = [10, 2, 3, 4, 0, 7, -5];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.syncEditBlock((list) {
        return list + [3, 4, 5];
      });
      expect(sut.value, [10, 2, 3, 4, 0, 7, -5, 3, 4, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('take', () {
      List<int> list1 = [10, 2, 3, 4, 0, 7, -5];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.take(4);
      expect(result, [10, 2, 3, 4]);
      sut.dispose();
    });

    test('takeWhile', () {
      List<int> list1 = [10, 2, 3, 4, 0, 7, -5];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.takeWhile((e) => e.isEven);
      expect(result, [10, 2]);
      sut.dispose();
    });

    test('where', () {
      List<int> list1 = [10, 2, 3, 4, 0, 7, -5];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.where((e) => e.isEven);
      expect(result, [10, 2, 4, 0]);
      sut.dispose();
    });

    test('whereIndexed', () {
      List<int> list1 = [0, 1, 2, 3, 4, 5, 6];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.whereIndexed((i, e) => i.isEven || e > 2);
      expect(result, [0, 2, 3, 4, 5, 6]);
      sut.dispose();
    });

    test('whereNot', () {
      List<int> list1 = [0, 1, 2, 3, 4, 5, 6];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.whereNot((e) => e > 2);
      expect(result, [0, 1, 2]);
      sut.dispose();
    });

    test('whereNotIndexed', () {
      List<int> list1 = [0, 1, 2, 3, 4, 5, 6];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.whereNotIndexed((i, e) => i.isEven || e > 2);
      expect(result, [1]);
      sut.dispose();
    });

    test('whereType', () {
      List<dynamic> list1 = ['ten', 2, 3, VoidCallback, 0, null, -5];
      ListNotifier<dynamic> sut = ListNotifier<dynamic>(list1);
      final result = sut.whereType<int>();
      expect(result, TypeMatcher<Iterable<int>>());
      expect(result, [2, 3, 0, -5]);
      sut.dispose();
    });
  });

  group('SetNotifier tests', () {
    test('SetNotifier shallow should notify', () {
      final SetNotifier<String> setNotifier =
          SetNotifier<String>({'a', 'b', 'c'});
      bool didChange = false;
      setNotifier.addListener(() {
        didChange = true;
      });
      setNotifier.value = {'z', 'b', 'c'};
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
    });

    test('SetNotifier deep should notify', () {
      final SetNotifier<Map> setNotifier = SetNotifier<Map>({
        {'a': true},
        {'b': true},
        {'c': true}
      });
      bool didChange = false;
      setNotifier.addListener(() {
        didChange = true;
      });
      setNotifier.value = {
        {'a': true},
        {'b': false},
        {'c': true}
      };
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
    });

    test('collection setter', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.collection = {4, 5, 6};
      expect(sut.value, {4, 5, 6});
      expect(didChange, true);
      sut.dispose();
    });

    test('first', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.first;
      expect(result, 0);
      sut.dispose();
    });

    test('firstOrNull', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.firstOrNull;
      expect(result, 0);
      sut.dispose();
    });

    test('isEmpty', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.isEmpty;
      expect(result, false);
      sut.dispose();
    });

    test('isNotEmpty', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.isNotEmpty;
      expect(result, true);
      sut.dispose();
    });

    test('iterator', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.iterator;
      expect(result, TypeMatcher<Iterator<int>>());
      sut.dispose();
    });

    test('last', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.last;
      expect(result, 2);
      sut.dispose();
    });

    test('lastOrNull', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.lastOrNull;
      expect(result, 2);
      sut.dispose();
    });

    test('length', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.length;
      expect(result, 3);
      sut.dispose();
    });

    test('single', () {
      Set<int> set = {0};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.single;
      expect(result, 0);
      sut.dispose();
    });

    test('singleOrNull', () {
      Set<int> set = {0};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.singleOrNull;
      expect(result, 0);
      sut.dispose();
    });

    test('value getter', () {
      Set<int> set = {0};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.value;
      expect(result, {0});
      sut.dispose();
    });

    test('add', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.add(3);
      expect(sut.value, [0, 1, 2, 3]);
      expect(didChange, true);
      sut.dispose();
    });

    test('addAll', () {
      Set<int> set = {0, 1, 2};
      Set<int> testAdd = {3, 4, 5};
      SetNotifier<int> sut = SetNotifier<int>(set);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.addAll(testAdd);
      expect(sut.value, [0, 1, 2, 3, 4, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('any', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.any((e) => e.isOdd);
      expect(result, true);
      sut.dispose();
    });

    test('asyncEditBlock', () async {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.asyncEditBlock((list) async {
        return {3, 4, 5};
      });
      await Future.delayed(Duration(seconds: 1));
      expect(didChange, true);
      expect(sut.value, [3, 4, 5]);
      sut.dispose();
    });

    test('cast', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.cast<double>();
      expect(result, TypeMatcher<Set<double>>());
      sut.dispose();
    });

    test('clear', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.clear();
      expect(sut.isEmpty, true);
      expect(didChange, true);
      sut.dispose();
    });

    test('completerEditBlock', () async {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      Completer<Set<int>> completer = Completer();
      sut.completerEditBlock(completer);
      completer.complete({3, 4, 5});
      await Future.delayed(Duration(seconds: 1));
      expect(didChange, true);
      expect(sut.value, {3, 4, 5});
      sut.dispose();
    });

    test('contains', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.contains(2);
      expect(result, true);
      sut.dispose();
    });

    test('containsAll', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.containsAll({1, 2});
      expect(result, true);
      sut.dispose();
    });

    test('difference', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.difference({1, 2});
      expect(result, {0});
      sut.dispose();
    });

    test('elementAt', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.elementAt(1);
      expect(result, 1);
      sut.dispose();
    });

    test('every', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.every((e) => e.isEven);
      expect(result, false);
      sut.dispose();
    });

    test('expand', () {
      Set<int> set = {0, 1, 2};
      SetNotifier<int> sut = SetNotifier<int>(set);
      final result = sut.expand((e) => [e + 1, e + 2]);
      expect(result.toList(), <int>[1, 2, 2, 3, 3, 4]);
      sut.dispose();
    });

    test('expandIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.expandIndexed((i, e) => [e + i, e + i]);
      expect(result.toList(), <int>[0, 0, 2, 2, 4, 4]);
      sut.dispose();
    });

    test('firstWhere', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.firstWhere((e) => e > 1, orElse: () => -1);
      expect(result, 2);
      sut.dispose();
    });

    test('firstWhereIndexedOrNull, contains', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.firstWhereIndexedOrNull((i, e) => (i + e) > 3);
      expect(result, 2);
      sut.dispose();
    });

    test('firstWhereIndexedOrNull, does not contain', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.firstWhereIndexedOrNull((i, e) => (i + e) > 10);
      expect(result, null);
      sut.dispose();
    });

    test('firstWhereOrNull, contains', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.firstWhereOrNull((e) => e > 3);
      expect(result, 4);
      sut.dispose();
    });

    test('firstWhereOrNull, does not contain', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.firstWhereOrNull((e) => e > 5);
      expect(result, null);
      sut.dispose();
    });

    test('fold', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.fold<int>(10, (p, e) => p + e);
      expect(result, 13);
      sut.dispose();
    });

    test('foldIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.foldIndexed<int>(10, (i, p, e) => p + e + i);
      expect(result, 16);
      sut.dispose();
    });

    test('followedBy', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.followedBy({3, 4, 5});
      expect(result.toList(), <int>[0, 1, 2, 3, 4, 5]);
      sut.dispose();
    });

    test('forEach', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      var result0;
      var result1;
      var result2;
      sut.forEach((e) {
        if (e == 0) {
          result0 = e;
        }
        if (e == 1) {
          result1 = e;
        }
        if (e == 2) {
          result2 = e;
        }
      });
      expect(result0, 0);
      expect(result1, 1);
      expect(result2, 2);
      sut.dispose();
    });

    test('forEachIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      int sum = 0;
      sut.forEachIndexed((i, e) {
        sum += i + e;
      });
      expect(sum, 30);
      sut.dispose();
    });

    test('forEachIndexedWhile', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      int callCount = 0;
      sut.forEachIndexedWhile((i, e) {
        callCount++;
        return e < 3 && i < 2;
      });
      expect(callCount, 3);
      sut.dispose();
    });

    test('forEachWhile', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      int callCount = 0;
      sut.forEachWhile((e) {
        callCount++;
        return e < 3;
      });
      expect(callCount, 4);
      sut.dispose();
    });

    test('groupFoldBy', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.groupFoldBy((e) => e.isEven, (int? previous, int e) {
        return (previous ?? 0) + e;
      });
      expect(result, {true: 6, false: 9});
      sut.dispose();
    });

    test('groupListsBy', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.groupListsBy((e) => e.isEven);
      expect(result, {
        true: <int>[0, 2, 4],
        false: <int>[1, 3, 5]
      });
      sut.dispose();
    });

    test('groupSetsBy', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.groupSetsBy((e) => e.isEven);
      expect(result, {
        true: <int>{0, 2, 4},
        false: <int>{1, 3, 5}
      });
      sut.dispose();
    });

    test('intersection', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.intersection({4, 5, 6, 7});
      expect(result, {4, 5});
      sut.dispose();
    });

    test('isSorted', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.isSorted((a, b) => a.compareTo(b));
      expect(result, true);
      sut.dispose();
    });

    test('isSortedBy', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.isSortedBy<num>((e) => e);
      expect(result, true);
      sut.dispose();
    });

    test('isSortedBy', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result =
          sut.isSortedByCompare((e) => e, (int a, int b) => a.compareTo(b));
      expect(result, true);
      sut.dispose();
    });

    test('join', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2});
      final result = sut.join(", ");
      expect(result, '0, 1, 2');
      sut.dispose();
    });

    test('lastWhere', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.lastWhere((e) => e < 4, orElse: () => -1);
      expect(result, 2);
      sut.dispose();
    });

    test('lastWhereIndexedOrNull present', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.lastWhereIndexedOrNull((i, e) => i > 1 && e < 4);
      expect(result, 2);
      sut.dispose();
    });

    test('lastWhereIndexedOrNull not present', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.lastWhereIndexedOrNull((i, e) => i > 4 && e < 2);
      expect(result, null);
      sut.dispose();
    });

    test('lastWhereOrNull present', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.lastWhereOrNull((e) => e < 4);
      expect(result, 2);
      sut.dispose();
    });

    test('lastWhereOrNull not present', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.lastWhereOrNull((e) => e > 45);
      expect(result, null);
      sut.dispose();
    });

    test('lookup present', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.lookup(1);
      expect(result, 1);
      sut.dispose();
    });

    test('lookup absent', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.lookup(42);
      expect(result, null);
      sut.dispose();
    });

    test('map', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.map((e) => <int>{e});
      expect(result, {
        {0},
        {1},
        {2},
        {4},
        {5}
      });
      sut.dispose();
    });

    test('mapIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.mapIndexed((i, e) => <int>{e * i});
      expect(result, {
        {0},
        {1},
        {4},
        {12},
        {20}
      });
      sut.dispose();
    });

    test('none', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.none((p0) => p0.isNegative);
      expect(result, true);
      sut.dispose();
    });

    test('reduce', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.reduce((value, e) => value += e);
      expect(result, 12);
      sut.dispose();
    });

    test('reduceIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.reduceIndexed((i, previous, e) => previous += (e * i));
      expect(result, 37);
      sut.dispose();
    });

    test('remove', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      final result = sut.remove(4);
      expect(result, true);
      expect(sut.value, {0, 1, 2, 5});
      expect(didChange, true);
      sut.dispose();
    });

    test('removeAll', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.removeAll({2, 4, 5});
      expect(sut.value, {0, 1});
      expect(didChange, true);
      sut.dispose();
    });

    test('removeWhere', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.removeWhere((e) => e.isEven);
      expect(sut.value, [1, 5]);
      expect(didChange, true);
      sut.dispose();
    });

    test('retainWhere', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.retainWhere((e) => e.isEven);
      expect(sut.value, [0, 2, 4]);
      expect(didChange, true);
      sut.dispose();
    });

    // Intentionally Not Testing sample since there is no
    // deductive test for randomness.

    test('singleWhere', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 4, 5});
      final result = sut.singleWhere((e) => e == 1, orElse: () => -1);
      expect(result, 1);
      sut.dispose();
    });

    test('singleWhereIndexedOrNull present', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.singleWhereIndexedOrNull((i, e) => e.isOdd && i > 6);
      expect(result, 9);
      sut.dispose();
    });

    test('singleWhereIndexedOrNull too many', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.singleWhereIndexedOrNull((i, e) => e.isOdd && i > 3);
      expect(result, null);
      sut.dispose();
    });

    test('singleWhereOrNull too many', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.singleWhereOrNull((e) => e.isOdd);
      expect(result, null);
      sut.dispose();
    });

    test('singleWhereOrNull present', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.singleWhereOrNull((e) => e.isOdd && e > 8);
      expect(result, 9);
      sut.dispose();
    });

    test('singleWhereOrNull too many', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.singleWhereOrNull((e) => e.isOdd);
      expect(result, null);
      sut.dispose();
    });

    test('skip', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.skip(2);
      expect(result.toSet(), <int>[2, 3, 4, 5]);
      sut.dispose();
    });

    test('skipWhile', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5});
      final result = sut.skipWhile((e) => e < 2);
      expect(result.toSet(), <int>[2, 3, 4, 5]);
      sut.dispose();
    });

    test('slices', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.slices(2);
      expect(result, [
        [1, 0],
        [2, 5],
        [7, 6],
        [8, 9],
      ]);
      sut.dispose();
    });

    test('sortedByCompare', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result =
          sut.sortedByCompare((e) => e * 2, (int a, int b) => a.compareTo(b));
      expect(result, [0, 1, 2, 5, 6, 7, 8, 9]);
      sut.dispose();
    });

    test('splitAfter', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.splitAfter((a) => a.isOdd);
      expect(result, [
        [1],
        [0, 2, 5],
        [7],
        [6, 8, 9]
      ]);
      sut.dispose();
    });

    test('splitBeforeIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.splitBetween((i, e) => i < e);
      expect(result, [
        [1, 0],
        [2],
        [5],
        [7, 6],
        [8],
        [9]
      ]);
      sut.dispose();
    });

    test('splitBetween', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.splitBetween((a, b) => a > b);
      expect(result, [
        [1],
        [0, 2, 5, 7],
        [6, 8, 9]
      ]);
      sut.dispose();
    });

    test('splitBetweenIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({1, 0, 2, 5, 7, 6, 8, 9});
      final result = sut.splitBeforeIndexed((i, e) => i < e);
      expect(result, [
        [1, 0, 2],
        [5],
        [7],
        [6],
        [8],
        [9]
      ]);
      sut.dispose();
    });

    test('syncEditBlock', () {
      SetNotifier<int> sut = SetNotifier<int>({10, 2, 3, 4, 0, 7, -5});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.syncEditBlock((set) {
        return set.intersection({3, 4, 5});
      });
      expect(sut.value, {3, 4});
      expect(didChange, true);
      sut.dispose();
    });

    test('take', () {
      SetNotifier<int> sut = SetNotifier<int>({10, 2, 3, 4, 0, 7, -5});
      final result = sut.take(4);
      expect(result, [10, 2, 3, 4]);
      sut.dispose();
    });

    test('takeWhile', () {
      SetNotifier<int> sut = SetNotifier<int>({10, 2, 3, 4, 0, 7, -5});
      final result = sut.takeWhile((e) => e.isEven);
      expect(result, [10, 2]);
      sut.dispose();
    });

    test('takeWhile', () {
      SetNotifier<int> sut = SetNotifier<int>({10, 2, 3, 4, 0, 7, -5});
      final result = sut.union({2, 42, 8});
      expect(result, {10, 2, 3, 4, 0, 7, -5, 42, 8});
      sut.dispose();
    });

    test('where', () {
      SetNotifier<int> sut = SetNotifier<int>({10, 2, 3, 4, 0, 7, -5});
      final result = sut.where((e) => e.isEven);
      expect(result, [10, 2, 4, 0]);
      sut.dispose();
    });

    test('whereIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5, 6});
      final result = sut.whereIndexed((i, e) => i.isEven || e > 2);
      expect(result, [0, 2, 3, 4, 5, 6]);
      sut.dispose();
    });

    test('whereNot', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5, 6});
      final result = sut.whereNot((e) => e > 2);
      expect(result, [0, 1, 2]);
      sut.dispose();
    });

    test('whereNotIndexed', () {
      SetNotifier<int> sut = SetNotifier<int>({0, 1, 2, 3, 4, 5, 6});
      final result = sut.whereNotIndexed((i, e) => i.isEven || e > 2);
      expect(result, [1]);
      sut.dispose();
    });

    test('whereType', () {
      SetNotifier<dynamic> sut =
          SetNotifier<dynamic>({'ten', 2, 3, VoidCallback, 0, null, -5});
      final result = sut.whereType<int>();
      expect(result, TypeMatcher<Iterable<int>>());
      expect(result, [2, 3, 0, -5]);
      sut.dispose();
    });
  });

  group('MapNotifier test', () {
    test('MapNotifier shallow should notify', () {
      final MapNotifier<String, bool> mapNotifier =
          MapNotifier<String, bool>({'a': true, 'b': true, 'c': true});
      bool didChange = false;
      mapNotifier.addListener(() {
        didChange = true;
      });
      mapNotifier.value = {'a': false, 'b': true, 'c': true};
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
    });

    test('MapNotifier deep should notify', () {
      final MapNotifier<String, Map> mapNotifier = MapNotifier<String, Map>({
        '0': {'a': true},
        '1': {'b': true},
        '2': {'c': true}
      });
      bool didChange = false;
      mapNotifier.addListener(() {
        didChange = true;
      });
      mapNotifier.value = {
        '0': {'a': true},
        '1': {'b': true},
        '2': {'c': false}
      };
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
    });

    test('collection setter', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.collection = {'4': 4, '5': 5, '6': 6};
      expect(sut.value, {'4': 4, '5': 5, '6': 6});
      expect(didChange, true);
      sut.dispose();
    });

    test('isEmpty', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.isEmpty;
      expect(result, false);
      sut.dispose();
    });

    test('isNotEmpty', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.isNotEmpty;
      expect(result, true);
      sut.dispose();
    });

    test('keys', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.keys;
      expect(result.toList(), ['0', '1', '2']);
      sut.dispose();
    });

    test('length', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.length;
      expect(result, 3);
      sut.dispose();
    });

    test('[] getter', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut['2'];
      expect(result, 2);
      sut.dispose();
    });

    test('[] setter', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut['2'] = 42;
      expect(sut.value, {'0': 0, '1': 1, '2': 42});
      expect(didChange, true);
      sut.dispose();
    });

    test('addAll', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.addAll({'4': 4, '5': 5});
      expect(sut.value, {'0': 0, '1': 1, '2': 2, '4': 4, '5': 5});
      expect(didChange, true);
      sut.dispose();
    });

    test('addEntries', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.addEntries([MapEntry<String, int>('4', 4)]);
      expect(sut.value, {'0': 0, '1': 1, '2': 2, '4': 4});
      expect(didChange, true);
      sut.dispose();
    });

    test('asyncEditBlock', () async {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.asyncEditBlock((map) async {
        return {'0': 0, '1': 1, '3': 3};
      });
      await Future.delayed(Duration(seconds: 1));
      expect(didChange, true);
      expect(sut.value, {'0': 0, '1': 1, '3': 3});
      sut.dispose();
    });

    test('cast', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.cast<String, double>();
      expect(result, TypeMatcher<Map<String, double>>());
      sut.dispose();
    });

    test('clear', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      sut.clear();
      expect(sut.value, {});
      sut.dispose();
    });

    test('completerEditBlock', () async {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      Completer<Map<String, int>> completer = Completer();
      sut.completerEditBlock(completer);
      completer.complete({'3': 3, '4': 4, '5': 5});
      await Future.delayed(Duration(seconds: 1));
      expect(didChange, true);
      expect(sut.value, {'3': 3, '4': 4, '5': 5});
      sut.dispose();
    });

    test('containsKey present', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.containsKey('0');
      expect(result, true);
      sut.dispose();
    });

    test('containsKey absent', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.containsKey('3');
      expect(result, false);
      sut.dispose();
    });

    test('containsValue present', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.containsValue(0);
      expect(result, true);
      sut.dispose();
    });

    test('containsValue absent', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.containsValue(3);
      expect(result, false);
      sut.dispose();
    });

    test('forEach', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      var result0;
      var result1;
      var result2;
      sut.forEach((k, v) {
        if (k == '0') {
          result0 = v;
        }
        if (k == '1') {
          result1 = v;
        }
        if (k == '2') {
          result2 = v;
        }
      });
      expect(result0, 0);
      expect(result1, 1);
      expect(result2, 2);
      sut.dispose();
    });

    test('map', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      final result = sut.map((k, v) => MapEntry(k, v + 1));
      expect(result, {'0': 1, '1': 2, '2': 3});
      sut.dispose();
    });

    test('putIfAbsent present', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      final result = sut.putIfAbsent('2', () => 3);
      expect(result, 2);
      expect(didChange, false);
    });

    test('putIfAbsent absent', () {
      MapNotifier<String, int> sut = MapNotifier<String, int>({'0': 0, '1': 1});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      final result = sut.putIfAbsent('2', () => 3);
      expect(result, 3);
      expect(didChange, true);
    });

    test('remove absent', () {
      MapNotifier<String, int> sut = MapNotifier<String, int>({'0': 0, '1': 1});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      final result = sut.remove('2');
      expect(didChange, false);
      expect(result, null);
    });

    test('remove present', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      final result = sut.remove('2');
      expect(didChange, true);
      expect(result, 2);
    });

    test('removeWhere', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.removeWhere((key, value) => value > 0);
      expect(sut.value, {'0': 0});
      expect(didChange, true);
    });

    test('syncEditBlock', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.syncEditBlock((map) => {'3': 3, '4': 4, '5': 5});
      expect(didChange, true);
      expect(sut.value, {'3': 3, '4': 4, '5': 5});
    });

    test('update', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.update('1', (value) => value + 1);
      expect(didChange, true);
      expect(sut.value, {'0': 0, '1': 2, '2': 2});
    });

    test('update', () {
      MapNotifier<String, int> sut =
          MapNotifier<String, int>({'0': 0, '1': 1, '2': 2});
      bool didChange = false;
      sut.addListener(() {
        didChange = true;
      });
      sut.updateAll((key, value) => value += 1);
      expect(didChange, true);
      expect(sut.value, {'0': 1, '1': 2, '2': 3});
    });
  });

  group('List extension tests', () {
    test('Reorder valid extreme increasing', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(0, 2);
      expect(sut, [2, 3, 1]);
    });

    test('Reorder valid extreme decreasing', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(2, 0);
      expect(sut, [3, 1, 2]);
    });

    test('Reorder valid, increasing by one', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(1, 0);
      expect(sut, [2, 1, 3]);
    });

    test('Reorder valid, decreasing by one', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(0, 1);
      expect(sut, [2, 1, 3]);
    });

    test('Reorder invalid: length < 2', () {
      final List<int> sut = [1];
      sut.reorder(1, 0);
      expect(sut, [1]);
    });

    test('Reorder invalid: oldIndex too great', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(3, 0);
      expect(sut, [1, 2, 3]);
    });

    test('Reorder invalid: newIndex too great', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(1, 3);
      expect(sut, [1, 2, 3]);
    });

    test('Reorder invalid: oldIndex less than zero', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(-1, 0);
      expect(sut, [1, 2, 3]);
    });

    test('Reorder invalid: newIndex less than zero', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(1, -1);
      expect(sut, [1, 2, 3]);
    });

    test('Reorder invalid: oldIndex == newIndex', () {
      final List<int> sut = [1, 2, 3];
      sut.reorder(1, 1);
      expect(sut, [1, 2, 3]);
    });
  });
}
