import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:collection/collection.dart';
import '../extensions.dart';
import './collection_notifier.dart';

/// A basic Listenable for Sets where T is the type of its element
/// See documentation for [Listenable]
abstract class SetListenable<T> extends Listenable {
  const SetListenable();

  /// The underlying set of a SetNotifier. Modifying this map will not trigger
  /// notification of listeners. Instead, use Map method wrappers of the
  /// SetNotifier or, use an editing block method of SetNotifier like
  /// [asyncEditBlock], [syncEditBlock], or [completerEditBlock]
  Set<T> get value;
}

/// A [CollectionNotifier] for Sets.
/// Use the implemented Set methods on this class (rather than [value] to
/// have your set modifications trigger any listeners on this notifier.
/// To make multiple modifications and yet trigger listeners only once, use
/// [asyncEditBlock], [syncEditBlock], or [completerEditBlock] - see
/// [CollectionController] for more information on how these work.
class SetNotifier<T> extends CollectionNotifier
    implements
        SetListenable<T>,
        Set<T>,
        CollectionController<Set<T>>,
        ExtendedIterable<T> {
  Set<T> _value;

  /// Creates a [CollectionNotifier] that wraps this value.
  SetNotifier(this._value) : super();

  // Setters

  @override
  set collection(Set<T> set) {
    _value = set;
    notifyListeners();
  }

  @override
  set value(newValue) {
    SchedulerBinding.instance.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = Set<T>.from(newValue);
      notifyListeners();
    }, Priority.animation);
  }

  // Getters

  @override
  T get first => _value.first;

  @override
  T? get firstOrNull => _value.firstOrNull;

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterator<T> get iterator => _value.iterator;

  @override
  T get last => _value.last;

  @override
  T? get lastOrNull => _value.lastOrNull;

  @override
  int get length => _value.length;

  @override
  T get single => _value.single;

  @override
  T? get singleOrNull => _value.singleOrNull;

  @override
  Set<T> get value => _value;

  // Methods

  @override
  bool add(T value) {
    bool result = _value.add(value);
    notifyListeners();
    return result;
  }

  @override
  void addAll(Iterable<T> elements) {
    _value.addAll(elements);
    notifyListeners();
  }

  @override
  bool any(bool Function(T element) test) {
    return _value.any(test);
  }

  @override
  void asyncEditBlock(
    Future Function(Set<T> set) asyncAction, {
    Function? onError,
  }) {
    asyncAction(_value)
        .then((editedList) => collection = editedList, onError: onError);
  }

  @override
  Set<R> cast<R>() {
    return _value.cast<R>();
  }

  @override
  void clear() {
    _value.clear();
    notifyListeners();
  }

  @override
  void completerEditBlock(Completer<Set<T>> completer, {Function? onError}) {
    completer.future
        .then((editedSet) => collection = editedSet, onError: onError);
  }

  @override
  bool contains(Object? value) {
    return _value.contains(value);
  }

  @override
  bool containsAll(Iterable<Object?> other) {
    return _value.containsAll(other);
  }

  @override
  Set<T> difference(Set<Object?> other) {
    return _value.difference(other);
  }

  @override
  T elementAt(int index) {
    return _value.elementAt(index);
  }

  @override
  bool every(bool Function(T element) test) {
    return _value.every(test);
  }

  @override
  Iterable<U> expand<U>(Iterable<U> Function(T element) toElements) {
    return _value.expand(toElements);
  }

  @override
  Iterable<R> expandIndexed<R>(
      Iterable<R> Function(int index, T element) expand) {
    return _value.expandIndexed(expand);
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _value.firstWhere(test, orElse: orElse);
  }

  @override
  T? firstWhereIndexedOrNull(bool Function(int index, T element) test) {
    return _value.firstWhereIndexedOrNull(test);
  }

  @override
  T? firstWhereOrNull(bool Function(T element) test) {
    return _value.firstWhereOrNull(test);
  }

  @override
  U fold<U>(U initialValue, U Function(U previousValue, T element) combine) {
    return _value.fold(initialValue, combine);
  }

  @override
  R foldIndexed<R>(
      R initialValue, R Function(int index, R previous, T element) combine) {
    return _value.foldIndexed(initialValue, combine);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    return _value.followedBy(other);
  }

  @override
  void forEach(void Function(T element) action) {
    return _value.forEach(action);
  }

  @override
  void forEachIndexed(void Function(int index, T element) action) {
    _value.forEachIndexed(action);
  }

  @override
  void forEachIndexedWhile(bool Function(int index, T element) action) {
    return _value.forEachIndexedWhile(action);
  }

  @override
  void forEachWhile(bool Function(T element) action) {
    return _value.forEachWhile(action);
  }

  @override
  Map<K, G> groupFoldBy<K, G>(
      K Function(T element) keyOf, G Function(G? previous, T element) combine) {
    return _value.groupFoldBy<K, G>(keyOf, combine);
  }

  @override
  Map<K, List<T>> groupListsBy<K>(K Function(T element) keyOf) {
    return _value.groupListsBy<K>(keyOf);
  }

  @override
  Map<K, Set<T>> groupSetsBy<K>(K Function(T element) keyOf) {
    return _value.groupSetsBy<K>(keyOf);
  }

  @override
  Set<T> intersection(Set<Object?> other) {
    return _value.intersection(other);
  }

  @override
  bool isSorted(Comparator<T> compare) {
    return _value.isSorted(compare);
  }

  @override
  bool isSortedBy<K extends Comparable<K>>(K Function(T element) keyOf) {
    return _value.isSortedBy(keyOf);
  }

  @override
  bool isSortedByCompare<K>(
      K Function(T element) keyOf, Comparator<K> compare) {
    return _value.isSortedByCompare(keyOf, compare);
  }

  @override
  String join([String separator = ""]) {
    return _value.join(separator);
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _value.lastWhere(test, orElse: orElse);
  }

  @override
  T? lastWhereIndexedOrNull(bool Function(int index, T element) test) {
    return _value.lastWhereIndexedOrNull(test);
  }

  @override
  T? lastWhereOrNull(bool Function(T element) test) {
    return _value.lastWhereOrNull(test);
  }

  @override
  T? lookup(Object? object) {
    return _value.lookup(object);
  }

  @override
  Iterable<U> map<U>(U Function(T e) toElement) {
    return _value.map(toElement);
  }

  @override
  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) {
    return _value.mapIndexed<R>(convert);
  }

  @override
  bool none(bool Function(T) test) {
    return _value.none(test);
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    return _value.reduce(combine);
  }

  @override
  T reduceIndexed(T Function(int index, T previous, T element) combine) {
    return _value.reduceIndexed(combine);
  }

  @override
  bool remove(Object? value) {
    bool result = _value.remove(value);
    if (result) {
      notifyListeners();
    }
    return result;
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    _value.removeAll(elements);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _value.removeWhere(test);
    notifyListeners();
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _value.retainAll(elements);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _value.retainWhere(test);
    notifyListeners();
  }

  @override
  List<T> sample(int count, [Random? random]) {
    return _value.sample(count, random);
  }

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _value.singleWhere(test, orElse: orElse);
  }

  @override
  T? singleWhereIndexedOrNull(bool Function(int index, T element) test) {
    return _value.singleWhereIndexedOrNull(test);
  }

  @override
  T? singleWhereOrNull(bool Function(T element) test) {
    return _value.singleWhereOrNull(test);
  }

  @override
  Iterable<T> skip(int count) {
    return _value.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    return _value.skipWhile(test);
  }

  @override
  Iterable<List<T>> slices(int length) {
    return _value.slices(length);
  }

  @override
  List<T> sorted(Comparator<T> compare) {
    return _value.sorted(compare);
  }

  @override
  List<T> sortedBy<K extends Comparable<K>>(K Function(T element) keyOf) {
    return _value.sortedBy(keyOf);
  }

  @override
  List<T> sortedByCompare<K>(
      K Function(T element) keyOf, Comparator<K> compare) {
    return _value.sortedByCompare<K>(keyOf, compare);
  }

  @override
  Iterable<List<T>> splitAfter(bool Function(T element) test) {
    return _value.splitAfter(test);
  }

  @override
  Iterable<List<T>> splitAfterIndexed(
      bool Function(int index, T element) test) {
    return _value.splitAfterIndexed(test);
  }

  @override
  Iterable<List<T>> splitBefore(bool Function(T element) test) {
    return _value.splitBefore(test);
  }

  @override
  Iterable<List<T>> splitBeforeIndexed(
      bool Function(int index, T element) test) {
    return _value.splitBeforeIndexed(test);
  }

  @override
  Iterable<List<T>> splitBetween(bool Function(T first, T second) test) {
    return _value.splitBetween(test);
  }

  @override
  Iterable<List<T>> splitBetweenIndexed(
      bool Function(int index, T first, T second) test) {
    return _value.splitBetweenIndexed(test);
  }

  @override
  void syncEditBlock(Set<T> Function(Set<T> set) action) {
    collection = action(_value);
  }

  @override
  Iterable<T> take(int count) {
    return _value.take(count);
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    return _value.takeWhile(test);
  }

  @override
  List<T> toList({bool growable = true}) {
    return _value.toList(growable: growable);
  }

  @override
  Set<T> toSet() {
    return _value.toSet();
  }

  @override
  Set<T> union(Set<T> other) {
    return _value.union(other);
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return _value.where(test);
  }

  @override
  Iterable<T> whereIndexed(bool Function(int index, T element) test) {
    return _value.whereIndexed(test);
  }

  @override
  Iterable<T> whereNot(bool Function(T element) test) {
    return _value.whereNot(test);
  }

  @override
  Iterable<T> whereNotIndexed(bool Function(int index, T element) test) {
    return _value.whereNotIndexed(test);
  }

  @override
  Iterable<U> whereType<U>() {
    return _value.whereType<U>();
  }
}
