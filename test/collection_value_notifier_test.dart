import 'package:flutter_test/flutter_test.dart';

import 'package:collection_value_notifier/collection_notifier.dart';

void main() {
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
}
