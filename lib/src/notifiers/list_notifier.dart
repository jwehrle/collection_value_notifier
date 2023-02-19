import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:collection/collection.dart';
import './collection_notifier.dart';
import 'dart:math';

import 'package:collection_value_notifier/src/extensions.dart';

abstract class ListListenable<T> extends Listenable {
  const ListListenable();

  /// The underlying map of a ListNotifier. Modifying this map will not trigger
  /// notification of listeners. Instead, use Map method wrappers of the
  /// ListNotifier or, use an editing block method of ListNotifier like
  /// [asyncEditBlock], [syncEditBlock], or [completerEditBlock]
  List<T> get value;
}

class ListNotifier<T> extends CollectionNotifier
    implements
        ListListenable<T>,
        List<T>,
        CollectionController<List<T>>,
        ExtendedList<T>,
        ExtendedIterable<T> {
  List<T> _value;

  ListNotifier(this._value) : super();

  // Setters

  @override
  set collection(List<T> list) {
    _value = list;
    notifyListeners();
  }

  @override
  set first(T value) {
    _value.first = value;
    notifyListeners();
  }

  @override
  set last(T value) {
    _value.last = value;
    notifyListeners();
  }

  @override
  set length(int newLength) {
    _value.length = newLength;
    notifyListeners();
  }

  @override
  set value(newValue) {
    SchedulerBinding.instance.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = List<T>.from(newValue);
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
  Iterable<T> get reversed => _value.reversed;

  @override
  T get single => _value.single;

  @override
  T? get singleOrNull => _value.singleOrNull;

  @override
  List<T> get value => _value;

  // Operators

  @override
  List<T> operator +(List<T> other) {
    return _value + other;
  }

  @override
  T operator [](int index) {
    return _value[index];
  }

  @override
  void operator []=(int index, T value) {
    _value[index] = value;
    notifyListeners();
  }

  // Methods

  @override
  void add(T value) {
    _value.add(value);
    notifyListeners();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _value.addAll(iterable);
    notifyListeners();
  }

  @override
  bool any(bool Function(T element) test) {
    return _value.any(test);
  }

  @override
  void asyncEditBlock(Future<List<T>> Function(List<T> list) asyncAction,
      {Function? onError}) {
    asyncAction(_value)
        .then((editedList) => collection = editedList, onError: onError);
  }

  @override
  Map<int, T> asMap() {
    return _value.asMap();
  }

  @override
  List<R> cast<R>() {
    return _value.cast<R>();
  }

  @override
  void clear() {
    _value.clear();
    notifyListeners();
  }

  @override
  void completerEditBlock(Completer<List<T>> completer, {Function? onError}) {
    completer.future
        .then((editedList) => collection = editedList, onError: onError);
  }

  @override
  bool contains(Object? element) {
    return _value.contains(element);
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
  Iterable<U> expand<U>(Iterable<U> toElements(T element)) {
    return _value.expand(toElements);
  }

  @override
  Iterable<R> expandIndexed<R>(
      Iterable<R> Function(int index, T element) expand) {
    return _value.expandIndexed(expand);
  }

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    _value.fillRange(start, end, fillValue);
    notifyListeners();
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
    _value.forEach(action);
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
  Iterable<T> getRange(int start, int end) {
    return _value.getRange(start, end);
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
  int indexOf(T element, [int start = 0]) {
    return _value.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    return _value.indexWhere(test, start);
  }

  @override
  void insert(int index, element) {
    _value.insert(index, element);
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _value.insertAll(index, iterable);
    notifyListeners();
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
  int lastIndexOf(T element, [int? start]) {
    return _value.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) {
    return _value.lastIndexWhere(test, start);
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
    bool didRemove = _value.remove(value);
    if (didRemove) {
      notifyListeners();
    }
    return didRemove;
  }

  @override
  T removeAt(int index) {
    T element = _value.removeAt(index);
    notifyListeners();
    return element;
  }

  @override
  T removeLast() {
    T element = _value.removeLast();
    notifyListeners();
    return element;
  }

  @override
  void removeRange(int start, int end) {
    _value.removeRange(start, end);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(T) test) {
    _value.removeWhere(test);
    notifyListeners();
  }

  @override
  void reorder(int oldIndex, int newIndex) {
    _value.reorder(oldIndex, newIndex);
    notifyListeners();
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    _value.replaceRange(start, end, replacements);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(T) test) {
    _value.retainWhere(test);
    notifyListeners();
  }

  @override
  void reverseRange(int start, int end) {
    _value.reverseRange(start, end);
    notifyListeners();
  }

  @override
  List<T> sample(int count, [Random? random]) {
    return _value.sample(count, random);
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _value.setAll(index, iterable);
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _value.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  @override
  void shuffle([Random? random]) {
    _value.shuffle(random);
    notifyListeners();
  }

  @override
  void shuffleRange(int start, int end, [Random? random]) {
    _value.shuffleRange(start, end, random);
    notifyListeners();
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
  void sort([int Function(T, T)? compare]) {
    _value.sort(compare);
    notifyListeners();
  }

  @override
  void sortBy<K extends Comparable<K>>(K Function(T) keyOf) {
    _value.sortedBy(keyOf);
    notifyListeners();
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
  void sortRange(int start, int end, int Function(T a, T b) compare) {
    _value.sortRange(start, end, compare);
    notifyListeners();
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
  List<T> sublist(int start, [int? end]) {
    return value.sublist(start, end);
  }

  @override
  void swap(int index1, int index2) {
    _value.swap(index1, index2);
    notifyListeners();
  }

  @override
  void syncEditBlock(List<T> Function(List<T> list) action) {
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
