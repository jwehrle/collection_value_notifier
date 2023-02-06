import 'package:collection_value_notifier/list_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:collection_value_notifier/collection_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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

  test('Reorder valid', () {
    final List<int> sut = [1, 2, 3];
    sut.reorder(1, 0);
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

  test('findFirstWhere: contains element', () {
    final List<int> sut = [1, 2, 3];
    final result = sut.findFirstWhere((item) => item == 2);
    expect(result, 2);
  });

  test('findFirstWhere: does not contains element', () {
    final List<int> sut = [1, 2, 3];
    final result = sut.findFirstWhere((item) => item == 4);
    expect(result, null);
  });

  test('findFirstWhere: contains multiple matching elements', () {
    final List<int> sut = [1, 1, 1];
    final result = sut.findFirstWhere((item) => item == 1);
    expect(result, 1);
  });

  test('findFirstWhere: list is empty', () {
    final List<int> sut = [];
    final result = sut.findFirstWhere((item) => item == 4);
    expect(result, null);
  });
}
