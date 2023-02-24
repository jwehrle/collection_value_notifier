import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:collection/collection.dart';
import 'collection_notifier.dart';

/// A basic Listenable for Maps where T is the type of its element
/// See documentation for [Listenable]
abstract class MapListenable<K, V> extends Listenable {
  const MapListenable();

  /// The underlying map of a MapNotifier. Modifying this map will not trigger
  /// notification of listeners. Instead, use Map method wrappers of the
  /// MapNotifier or, use an editing block method of MapNotifier like
  /// [asyncEditBlock], [syncEditBlock], or [completerEditBlock]
  Map<K, V> get value;
}

/// A [CollectionNotifier] for Maps.
/// Use the implemented Map methods on this class (rather than [value] to
/// have your map modifications trigger any listeners on this notifier.
/// To make multiple modifications and yet trigger listeners only once, use
/// [asyncEditBlock], [syncEditBlock], or [completerEditBlock] - see
/// [CollectionController] for more information on how these work.
class MapNotifier<K, V> extends CollectionNotifier
    implements MapListenable<K, V>, Map<K, V>, CollectionController<Map<K, V>> {
  Map<K, V> _value;

  /// Creates a [CollectionNotifier] that wraps this value.
  MapNotifier(this._value) : super();

  // Setters

  @override
  set collection(Map<K, V> map) {
    _value = map;
    notifyListeners();
  }

  set value(newValue) {
    SchedulerBinding.instance.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = Map<K, V>.from(newValue);
      notifyListeners();
    }, Priority.animation);
  }

  // Getters

  @override
  Iterable<MapEntry<K, V>> get entries => _value.entries;

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterable<K> get keys => _value.keys;

  @override
  int get length => _value.length;

  @override
  Map<K, V> get value => _value;

  @override
  Iterable<V> get values => _value.values;

  // Operators

  @override
  V? operator [](Object? key) {
    return _value[key];
  }

  @override
  void operator []=(K key, V value) {
    _value[key] = value;
    notifyListeners();
  }

  // Methods

  @override
  void addAll(Map<K, V> other) {
    _value.addAll(other);
    notifyListeners();
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    _value.addEntries(newEntries);
    notifyListeners();
  }

  @override
  void asyncEditBlock(
    Future Function(Map<K, V> map) asyncAction, {
    Function? onError,
  }) {
    asyncAction(_value)
        .then((editedList) => collection = editedList, onError: onError);
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    return _value.cast<RK, RV>();
  }

  @override
  void clear() {
    _value.clear();
    notifyListeners();
  }

  @override
  void completerEditBlock(Completer<Map<K, V>> completer, {Function? onError}) {
    completer.future
        .then((editedMap) => collection = editedMap, onError: onError);
  }

  @override
  bool containsKey(Object? key) {
    return _value.containsKey(key);
  }

  @override
  bool containsValue(Object? value) {
    return _value.containsValue(value);
  }

  @override
  void forEach(void Function(K key, V value) action) {
    _value.forEach(action);
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    return _value.map(convert);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    bool shouldNotify = !_value.containsKey(key);
    V result = _value.putIfAbsent(key, ifAbsent);
    if (shouldNotify) {
      notifyListeners();
    }
    return result;
  }

  @override
  V? remove(Object? key) {
    V? result = _value.remove(key);
    if (result != null) {
      notifyListeners();
    }
    return result;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _value.removeWhere(test);
    notifyListeners();
  }

  @override
  void syncEditBlock(Map<K, V> Function(Map<K, V> map) action) {
    collection = action(_value);
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    V result = _value.update(key, update, ifAbsent: ifAbsent);
    notifyListeners();
    return result;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _value.updateAll(update);
    notifyListeners();
  }
}
