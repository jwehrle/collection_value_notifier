// Impossible to mock list with mockito or mocktail

// import 'dart:developer' as dev;
// import 'dart:math';
import 'dart:ui';

import 'package:collection_value_notifier/list_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:collection_value_notifier/collection_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // this is what would be needed
  // _GrowableList _growableList = _GrowableList();

  // late MockList<int> list;

  // setUp(() {
  //   // Create mock object.
  //   // list = MockList(); //Foo<int>.generate(42, (index) => 42);
  // });

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

  test('SafeValueNotifier int should not notify', () {
    final SafeValueNotifier<int> safeValueNotifier = SafeValueNotifier<int>(0);
    bool didChange = false;
    safeValueNotifier.addListener(() {
      didChange = true;
    });
    safeValueNotifier.value = 0;
    expect(didChange, false);
  });

  test('SafeValueNotifier int should notify', () {
    final SafeValueNotifier<int> safeValueNotifier = SafeValueNotifier<int>(0);
    bool didChange = false;
    safeValueNotifier.addListener(() {
      didChange = true;
    });
    safeValueNotifier.value = 1;
    expect(didChange, true);
  });

  test('SafeValueNotifier String should not notify', () {
    final SafeValueNotifier<String> safeValueNotifier =
        SafeValueNotifier<String>('A');
    bool didChange = false;
    safeValueNotifier.addListener(() {
      didChange = true;
    });
    safeValueNotifier.value = 'A';
    expect(didChange, false);
  });

  test('SafeValueNotifier String should notify', () {
    final SafeValueNotifier<String> safeValueNotifier =
        SafeValueNotifier<String>('A');
    bool didChange = false;
    safeValueNotifier.addListener(() {
      didChange = true;
    });
    safeValueNotifier.value = 'B';
    expect(didChange, true);
  });

  test('SafeValueNotifier double should not notify', () {
    final SafeValueNotifier<double> safeValueNotifier =
        SafeValueNotifier<double>(1.0);
    bool didChange = false;
    safeValueNotifier.addListener(() {
      didChange = true;
    });
    safeValueNotifier.value = 1.0;
    expect(didChange, false);
  });

  test('SafeValueNotifier double should notify', () {
    final SafeValueNotifier<double> safeValueNotifier =
        SafeValueNotifier<double>(1.0);
    bool didChange = false;
    safeValueNotifier.addListener(() {
      didChange = true;
    });
    safeValueNotifier.value = 1.2;
    expect(didChange, true);
  });

  test('SafeValueNotifier bool should not notify', () {
    final SafeValueNotifier<bool> safeValueNotifier =
        SafeValueNotifier<bool>(true);
    bool didChange = false;
    safeValueNotifier.addListener(() {
      didChange = true;
    });
    safeValueNotifier.value = true;
    expect(didChange, false);
  });

  test('SafeValueNotifier bool should notify', () {
    final SafeValueNotifier<bool> safeValueNotifier =
        SafeValueNotifier<bool>(true);
    bool didChange = false;
    safeValueNotifier.addListener(() {
      didChange = true;
    });
    safeValueNotifier.value = false;
    expect(didChange, true);
  });

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

  group('Collection wrapper function tests', () {
    test('first', () {
      // when(list.first).thenReturn(0);
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      int result = sut.first;
      expect(result, 0);
      // verify(list.first).called(1);
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

    test('iterable', () {
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      expect(list, [0, 1, 2, 3]);
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      expect(list, [0, 1, 2, 3, 4, 5]);
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
      sut.dispose();
    });

    test('any', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.any((element) => element.isOdd);
      expect(result, true);
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
      expect(result, TypeMatcher<Iterable<double>>());
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      final result = sut.every((element) => element.isEven);
      expect(result, false);
      sut.dispose();
    });

    test('expand', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.expand((element) => [element + 1, element + 2]);
      expect(result.elementAt(0), 1);
      expect(result.elementAt(1), 2);
      expect(result.elementAt(2), 2);
      expect(result.elementAt(3), 3);
      expect(result.elementAt(4), 3);
      expect(result.elementAt(5), 4);
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
      sut.dispose();
    });

    test('firstWhere', () {
      List<int> list = [0, 1, 2];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.firstWhere((e) => e > 1, orElse: () => -1);
      expect(result, 2);
      sut.dispose();
    });

    test('firstWhereOrNull, contains', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.firstWhereOrNull((element) => element > 3);
      expect(result, 4);
      sut.dispose();
    });

    test('firstWhereOrNull, does not contain', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.firstWhereOrNull((element) => element > 5);
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

    test('followedBy', () {
      List<int> list = [0, 1, 2];
      List<int> other = [3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.followedBy(other);
      expect(result.elementAt(0), 0);
      expect(result.elementAt(1), 1);
      expect(result.elementAt(2), 2);
      expect(result.elementAt(3), 3);
      expect(result.elementAt(4), 4);
      expect(result.elementAt(5), 5);
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

    test('getRange', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.getRange(1, 3);
      expect(result, TypeMatcher<Iterable<int>>());
      expect(result.length, 2);
      expect(result.elementAt(0), 1);
      expect(result.elementAt(1), 2);
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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

    test('map', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.map((e) => <int>{e});
      expect(result, TypeMatcher<Iterable<Set<int>>>());
      sut.dispose();
    });

    test('reduce', () {
      List<int> list = [0, 1, 2, 2, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.reduce((value, element) => value += element);
      expect(result, 14);
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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

    test('skip', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.skip(2);
      expect(result, TypeMatcher<Iterable<int>>());
      expect(result.length, 4);
      expect(result.elementAt(0), 2);
      expect(result.elementAt(1), 3);
      expect(result.elementAt(2), 4);
      expect(result.elementAt(3), 5);
      sut.dispose();
    });

    test('skipWhile', () {
      List<int> list = [0, 1, 2, 3, 4, 5];
      ListNotifier<int> sut = ListNotifier<int>(list);
      final result = sut.skipWhile((e) => e < 2);
      expect(result, TypeMatcher<Iterable<int>>());
      expect(result.length, 4);
      expect(result.elementAt(0), 2);
      expect(result.elementAt(1), 3);
      expect(result.elementAt(2), 4);
      expect(result.elementAt(3), 5);
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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
      Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
      sut.dispose();
    });

    test('sublist', () {
      List<int> list1 = [10, 2, 3, 4, 0, 7, -5];
      ListNotifier<int> sut = ListNotifier<int>(list1);
      final result = sut.sublist(1, 5);
      expect(result, [2, 3, 4, 0]);
      sut.dispose();
    });
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
    Future.delayed(Duration(seconds: 1), () => expect(didChange, true));
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

  test('where', () {
    List<dynamic> list1 = ['ten', 2, 3, VoidCallback, 0, null, -5];
    ListNotifier<dynamic> sut = ListNotifier<dynamic>(list1);
    final result = sut.whereType<int>();
    expect(result, TypeMatcher<Iterable<int>>());
    expect(result, [2, 3, 0, -5]);
    sut.dispose();
  });
}
