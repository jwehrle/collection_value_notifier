library collection_notifier;

import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_value_notifier/list_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Adapted from ChangeNotifier and ValueListenable and ValueNotifier for Lists,
/// Sets, and Maps and to wrap notifyListeners() for public use.

abstract class ListListenable<T> extends Listenable {
  const ListListenable();
  List<T> get value;
}

abstract class SetListenable<T> extends Listenable {
  const SetListenable();
  Set<T> get value;
}

abstract class MapListenable<K, V> extends Listenable {
  const MapListenable();
  Map<K, V> get value;
}

class _ListenerEntry extends LinkedListEntry<_ListenerEntry> {
  _ListenerEntry(this.listener);
  final VoidCallback listener;
}

class Notifier implements Listenable {
  LinkedList<_ListenerEntry> _listeners = LinkedList<_ListenerEntry>();

  bool get hasListeners {
    return _listeners.isNotEmpty;
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(_ListenerEntry(listener));
  }

  @override
  void removeListener(VoidCallback listener) {
    for (final _ListenerEntry entry in _listeners) {
      if (entry.listener == listener) {
        entry.unlink();
        return;
      }
    }
  }

  @mustCallSuper
  void dispose() {
    _listeners.clear();
  }

  void notifyListeners() {
    if (_listeners.isEmpty) return;

    final List<_ListenerEntry> localListeners =
        List<_ListenerEntry>.from(_listeners);

    for (final _ListenerEntry entry in localListeners) {
      try {
        if (entry.list != null) entry.listener();
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'foundation library',
          context: ErrorDescription(
              'while dispatching notifications for $runtimeType'),
          informationCollector: () sync* {
            yield DiagnosticsProperty<Notifier>(
              'The $runtimeType sending notification was',
              this,
              style: DiagnosticsTreeStyle.errorProperty,
            );
          },
        ));
      }
    }
  }
}

class ListNotifier<T> extends Notifier implements ListListenable<T>, List<T> {
  List<T> _value;

  void notify() {
    notifyListeners();
  }

  ListNotifier(this._value) : super();

  @override
  List<T> get value => _value;
  set value(newValue) {
    SchedulerBinding.instance.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = List<T>.from(newValue);
      notifyListeners();
    }, Priority.animation);
  }

  /// Calls [action] then notifies listeners synchronously.
  void syncNotifyBlock(void Function(List<T> list) action) {
    action(value);
    notifyListeners();
  }

  /// Calls [action] and if it completes successfully notifies listeners.
  void asyncNotifyBlock(
    Future Function(List<T> list) asyncAction, {
    Function? onError,
  }) {
    asyncAction(value).then((value) => notifyListeners(), onError: onError);
  }

  @override
  T get first => _value.first;

  @override
  set first(T value) {
    this.value.first = value;
    notifyListeners();
  }

  /// The first element, or `null` if the iterable is empty.
  T? get firstOrNull => value.firstOrNull;

  @override
  T get last => _value.last;

  @override
  set last(T value) {
    this.value.last = value;
    notifyListeners();
  }

  /// The last element, or `null` if the iterable is empty.
  T? get lastOrNull => value.lastOrNull;

  @override
  int get length => _value.length;

  @override
  set length(int newLength) {
    value.length = newLength;
    notifyListeners();
  }

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterator<T> get iterator => _value.iterator;

  @override
  Iterable<T> get reversed => _value.reversed;

  @override
  T get single => _value.single;

  /// The single element of the iterable, or `null`.
  ///
  /// The value is `null` if the iterable is empty
  /// or it contains more than one element.
  T? get singleOrNull => value.singleOrNull;

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

  /// Expands each element and index to a number of elements in a new iterable.
  ///
  /// Like [Iterable.expand] except that the callback function is supplied with
  /// both the index and the element.
  Iterable<R> expandIndexed<R>(
      Iterable<R> Function(int index, T element) expand) sync* {
    value.expandIndexed(expand);
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

  /// The first element whose value and index satisfies [test].
  ///
  /// Returns `null` if there are no element and index satisfying [test].
  T? firstWhereIndexedOrNull(bool Function(int index, T element) test) {
    return value.firstWhereIndexedOrNull(test);
  }

  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    return _value.firstWhereOrNull(test);
  }

  @override
  U fold<U>(U initialValue, U Function(U previousValue, T element) combine) {
    return _value.fold(initialValue, combine);
  }

  /// Combine the elements with a value and the current index.
  ///
  /// Calls [combine] for each element with the current index,
  /// the result of the previous call, or [initialValue] for the first element,
  /// and the current element.
  ///
  /// Returns the result of the last call to [combine],
  /// or [initialValue] if there are no elements.
  R foldIndexed<R>(
      R initialValue, R Function(int index, R previous, T element) combine) {
    return value.foldIndexed(initialValue, combine);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    return _value.followedBy(other);
  }

  @override
  void forEach(void Function(T element) action) {
    _value.forEach(action);
  }

  /// Takes an action for each element.
  ///
  /// Calls [action] for each element along with the index in the
  /// iteration order.
  void forEachIndexed(void Function(int index, T element) action) {
    value.forEachIndexed(action);
  }

  /// Takes an action for each element and index as long as desired.
  ///
  /// Calls [action] for each element along with the index in the
  /// iteration order.
  /// Stops iteration if [action] returns `false`.
  void forEachIndexedWhile(bool Function(int index, T element) action) {
    return value.forEachIndexedWhile(action);
  }

  /// Takes an action for each element as long as desired.
  ///
  /// Calls [action] for each element.
  /// Stops iteration if [action] returns `false`.
  void forEachWhile(bool Function(T element) action) {
    return value.forEachWhile(action);
  }

  @override
  Iterable<T> getRange(int start, int end) {
    return _value.getRange(start, end);
  }

  /// Groups elements by [keyOf] then folds the elements in each group.
  ///
  /// A key is found for each element using [keyOf].
  /// Then the elements with the same key are all folded using [combine].
  /// The first call to [combine] for a particular key receives [null] as
  /// the previous value, the remaining ones receive the result of the previous call.
  ///
  /// Can be used to _group_ elements into arbitrary collections.
  /// For example [groupSetsBy] could be written as:
  /// ```dart
  /// iterable.groupFoldBy(keyOf,
  ///     (Set<T>? previous, T element) => (previous ?? <T>{})..add(element));
  /// ````
  Map<K, G> groupFoldBy<K, G>(
      K Function(T element) keyOf, G Function(G? previous, T element) combine) {
    return value.groupFoldBy<K, G>(keyOf, combine);
  }

  /// Groups elements into lists by [keyOf].
  Map<K, List<T>> groupListsBy<K>(K Function(T element) keyOf) {
    return value.groupListsBy<K>(keyOf);
  }

  /// Groups elements into sets by [keyOf].
  Map<K, Set<T>> groupSetsBy<K>(K Function(T element) keyOf) {
    return value.groupSetsBy<K>(keyOf);
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

  /// Whether the elements are sorted by the [compare] ordering.
  ///
  /// Compares pairs of elements using `compare` to check that
  /// the elements of this iterable to check
  /// that earlier elements always compare
  /// smaller than or equal to later elements.
  ///
  /// An single-element or empty iterable is trivially in sorted order.
  bool isSorted(Comparator<T> compare) {
    return value.isSorted(compare);
  }

  /// Whether the elements are sorted by their [keyOf] property.
  ///
  /// Applies [keyOf] to each element in iteration order,
  /// then checks whether the results are in non-decreasing [Comparable] order.
  bool isSortedBy<K extends Comparable<K>>(K Function(T element) keyOf) {
    return value.isSortedBy(keyOf);
  }

  /// Whether the elements are [compare]-sorted by their [keyOf] property.
  ///
  /// Applies [keyOf] to each element in iteration order,
  /// then checks whether the results are in non-decreasing order
  /// using the [compare] [Comparator]..
  bool isSortedByCompare<K>(
      K Function(T element) keyOf, Comparator<K> compare) {
    return value.isSortedByCompare(keyOf, compare);
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

  /// The last element whose index and value satisfies [test].
  ///
  /// Returns `null` if no element and index satisfies [test].
  T? lastWhereIndexedOrNull(bool Function(int index, T element) test) {
    return value.lastWhereIndexedOrNull(test);
  }

  /// The last element satisfying [test], or `null` if there are none.
  T? lastWhereOrNull(bool Function(T element) test) {
    return value.lastWhereOrNull(test);
  }

  @override
  Iterable<U> map<U>(U Function(T e) toElement) {
    return _value.map(toElement);
  }

  /// Maps each element and its index to a new value.
  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert) sync* {
    value.mapIndexed<R>(convert);
  }

  /// Whether no element satisfies [test].
  ///
  /// Returns true if no element satisfies [test],
  /// and false if at least one does.
  ///
  /// Equivalent to `iterable.every((x) => !test(x))` or
  /// `!iterable.any(test)`.
  bool none(bool Function(T) test) {
    return value.none(test);
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    return _value.reduce(combine);
  }

  /// Combine the elements with each other and the current index.
  ///
  /// Calls [combine] for each element except the first.
  /// The call passes the index of the current element, the result of the
  /// previous call, or the first element for the first call, and
  /// the current element.
  ///
  /// Returns the result of the last call, or the first element if
  /// there is only one element.
  /// There must be at least one element.
  T reduceIndexed(T Function(int index, T previous, T element) combine) {
    return value.reduceIndexed(combine);
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

  /// Extension method on List that reorders one element of a list.
  /// [oldIndex] is the current index of the element to be moved.
  /// [newIndex] is the destination index for the element to be moved.
  /// If list:
  ///    has less than 2 members,
  ///    oldIndex or newIndex are out of bounds,
  ///    oldIndex equals newIndex,
  /// this method returns without making any changes.
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

  /// Reverses the elements in a range of the list.
  void reverseRange(int start, int end) {
    _value.reverseRange(start, end);
    notifyListeners();
  }

  /// Selects [count] elements at random from this iterable.
  ///
  /// The returned list contains [count] different elements of the iterable.
  /// If the iterable contains fewer that [count] elements,
  /// the result will contain all of them, but will be shorter than [count].
  /// If the same value occurs more than once in the iterable,
  /// it can also occur more than once in the chosen elements.
  ///
  /// Each element of the iterable has the same chance of being chosen.
  /// The chosen elements are not in any specific order.
  List<T> sample(int count, [Random? random]) {
    return value.sample(count, random);
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

  /// Shuffle a range of elements.
  void shuffleRange(int start, int end, [Random? random]) {
    _value.shuffleRange(start, end, random);
    notifyListeners();
  }

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _value.singleWhere(test, orElse: orElse);
  }

  /// The single element satisfying [test].
  ///
  /// Returns `null` if there are either none
  /// or more than one element and index satisfying [test].
  T? singleWhereIndexedOrNull(bool Function(int index, T element) test) {
    return value.singleWhereIndexedOrNull(test);
  }

  /// The single element satisfying [test].
  ///
  /// Returns `null` if there are either no elements
  /// or more than one element satisfying [test].
  ///
  /// **Notice**: This behavior differs from [Iterable.singleWhere]
  /// which always throws if there are more than one match,
  /// and only calls the `orElse` function on zero matches.
  T? singleWhereOrNull(bool Function(T element) test) {
    return value.singleWhereOrNull(test);
  }

  @override
  Iterable<T> skip(int count) {
    return _value.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    return _value.skipWhile(test);
  }

  /// Contiguous [slice]s of [this] with the given [length].
  ///
  /// Each slice is a view of this list [length] elements long, except for the
  /// last one which may be shorter if [this] contains too few elements. Each
  /// slice begins after the last one ends.
  ///
  /// As with [slice], these slices are backed by this list, which must not
  /// change its length while the views are being used.
  ///
  /// For example, `[1, 2, 3, 4, 5].slices(2)` returns `[[1, 2], [3, 4], [5]]`.
  Iterable<List<T>> slices(int length) sync* {
    value.slices(length);
  }

  @override
  void sort([int Function(T, T)? compare]) {
    _value.sort(compare);
    notifyListeners();
  }

  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the natural ordering of the
  /// property [keyOf] of the element.
  void sortBy<K extends Comparable<K>>(K Function(T) keyOf) {
    _value.sortedBy(keyOf);
    notifyListeners();
  }

  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the [compare] [Comparator].
  List<T> sorted(Comparator<T> compare) {
    return value.sorted(compare);
  }

  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the natural ordering of the
  /// property [keyOf] of the element.
  List<T> sortedBy<K extends Comparable<K>>(K Function(T element) keyOf) {
    return value.sortedBy(keyOf);
  }

  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the [compare] [Comparator] of the
  /// property [keyOf] of the element.
  List<T> sortedByCompare<K>(
      K Function(T element) keyOf, Comparator<K> compare) {
    return value.sortedByCompare<K>(keyOf, compare);
  }

  /// Sort a range of elements by [compare].
  void sortRange(int start, int end, int Function(T a, T b) compare) {
    _value.sortRange(start, end, compare);
    notifyListeners();
  }

  /// Splits the elements into chunks before some elements.
  ///
  /// Each element is checked using [test] for whether it should start a new chunk.
  /// If so, the elements since the previous chunk-starting element
  /// are emitted as a list.
  /// Any final elements are emitted at the end.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9].splitAfter(isPrime);
  /// print(parts); // ([1, 0, 2], [1, 5], [7], [6, 8, 9])
  /// ```
  Iterable<List<T>> splitAfter(bool Function(T element) test) {
    return value.splitAfter(test);
  }

  /// Splits the elements into chunks after some elements and indices.
  ///
  /// Each element and index is checked using [test]
  /// for whether it should end the current chunk.
  /// If so, the elements since the previous chunk-ending element
  /// are emitted as a list.
  /// Any final elements are emitted at the end, whether the last
  /// element should be split after or not.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9].splitAfterIndexed((i, v) => i < v);
  /// print(parts); // ([1, 0], [2, 1], [5, 7, 6], [8, 9])
  /// ```
  Iterable<List<T>> splitAfterIndexed(
      bool Function(int index, T element) test) sync* {
    value.splitAfterIndexed(test);
  }

  /// Splits the elements into chunks before some elements.
  ///
  /// Each element except the first is checked using [test]
  /// for whether it should start a new chunk.
  /// If so, the elements since the previous chunk-starting element
  /// are emitted as a list.
  /// Any final elements are emitted at the end.
  ///
  /// Example:
  /// Example:
  /// ```dart
  /// var parts = [1, 2, 3, 4, 5, 6, 7, 8, 9].split(isPrime);
  /// print(parts); // ([1], [2], [3, 4], [5, 6], [7, 8, 9])
  /// ```
  Iterable<List<T>> splitBefore(bool Function(T element) test) {
    return value.splitBefore(test);
  }

  /// Splits the elements into chunks before some elements and indices.
  ///
  /// Each element and index except the first is checked using [test]
  /// for whether it should start a new chunk.
  /// If so, the elements since the previous chunk-starting element
  /// are emitted as a list.
  /// Any final elements are emitted at the end.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9]
  ///     .splitBeforeIndexed((i, v) => i < v);
  /// print(parts); // ([1], [0, 2], [1, 5, 7], [6, 8, 9])
  /// ```
  Iterable<List<T>> splitBeforeIndexed(
      bool Function(int index, T element) test) sync* {
    value.splitBeforeIndexed(test);
  }

  /// Splits the elements into chunks between some elements.
  ///
  /// Each pair of adjacent elements are checked using [test]
  /// for whether a chunk should end between them.
  /// If so, the elements since the previous chunk-splitting elements
  /// are emitted as a list.
  /// Any final elements are emitted at the end.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9].splitBetween((v1, v2) => v1 > v2);
  /// print(parts); // ([1], [0, 2], [1, 5, 7], [6, 8, 9])
  /// ```
  Iterable<List<T>> splitBetween(bool Function(T first, T second) test) {
    return value.splitBetween(test);
  }

  /// Splits the elements into chunks between some elements and indices.
  ///
  /// Each pair of adjacent elements and the index of the latter are
  /// checked using [test] for whether a chunk should end between them.
  /// If so, the elements since the previous chunk-splitting elements
  /// are emitted as a list.
  /// Any final elements are emitted at the end.
  ///
  /// Example:
  /// ```dart
  /// var parts = [1, 0, 2, 1, 5, 7, 6, 8, 9]
  ///    .splitBetweenIndexed((i, v1, v2) => v1 > v2);
  /// print(parts); // ([1], [0, 2], [1, 5, 7], [6, 8, 9])
  /// ```
  Iterable<List<T>> splitBetweenIndexed(
      bool Function(int index, T first, T second) test) sync* {
    value.splitBetweenIndexed(test);
  }

  @override
  List<T> sublist(int start, [int? end]) {
    return value.sublist(start, end);
  }

  /// Swaps two elements of this list.
  void swap(int index1, int index2) {
    _value.swap(index1, index2);
    notifyListeners();
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
    return value.toList(growable: growable);
  }

  @override
  Set<T> toSet() {
    return value.toSet();
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return _value.where(test);
  }

  /// The elements whose value and index satisfies [test].
  Iterable<T> whereIndexed(bool Function(int index, T element) test) sync* {
    value.whereIndexed(test);
  }

  /// The elements that do not satisfy [test].
  Iterable<T> whereNot(bool Function(T element) test) {
    return value.whereNot(test);
  }

  /// The elements whose value and index do not satisfy [test].
  Iterable<T> whereNotIndexed(bool Function(int index, T element) test) sync* {
    value.whereNotIndexed(test);
  }

  @override
  Iterable<U> whereType<U>() {
    return _value.whereType<U>();
  }
}

class SetNotifier<T> extends Notifier implements SetListenable<T>, Set<T> {
  Set<T> _value;

  SetNotifier(this._value) : super();

  @override
  Set<T> get value => _value;
  set value(newValue) {
    SchedulerBinding.instance.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = Set<T>.from(newValue);
      notifyListeners();
    }, Priority.animation);
  }

  void notify() {
    notifyListeners();
  }

  /// Calls [action] then notifies listeners synchronously.
  void syncNotifyBlock(void Function(Set<T> set) action) {
    action(value);
    notifyListeners();
  }

  /// Calls [action] and if it completes successfully notifies listeners.
  void asyncNotifyBlock(
    Future Function(Set<T> set) asyncAction, {
    Function? onError,
  }) {
    asyncAction(value).then((value) => notifyListeners(), onError: onError);
  }

  @override
  bool add(T value) {
    bool result = this.value.add(value);
    notifyListeners();
    return result;
  }

  @override
  void addAll(Iterable<T> elements) {
    value.addAll(elements);
    notifyListeners();
  }

  @override
  bool any(bool Function(T element) test) {
    return value.any(test);
  }

  @override
  Set<R> cast<R>() {
    return value.cast<R>();
  }

  @override
  void clear() {
    value.clear();
    notifyListeners();
  }

  @override
  bool contains(Object? value) {
    return this.value.contains(value);
  }

  @override
  bool containsAll(Iterable<Object?> other) {
    return value.containsAll(other);
  }

  @override
  Set<T> difference(Set<Object?> other) {
    return value.difference(other);
  }

  @override
  T elementAt(int index) {
    return value.elementAt(index);
  }

  @override
  bool every(bool Function(T element) test) {
    return value.every(test);
  }

  @override
  Iterable<U> expand<U>(Iterable<U> Function(T element) toElements) {
    return value.expand(toElements);
  }

  @override
  T get first => value.first;

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return value.firstWhere(test, orElse: orElse);
  }

  @override
  U fold<U>(U initialValue, U Function(U previousValue, T element) combine) {
    return value.fold(initialValue, combine);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    return value.followedBy(other);
  }

  @override
  void forEach(void Function(T element) action) {
    return value.forEach(action);
  }

  @override
  Set<T> intersection(Set<Object?> other) {
    return value.intersection(other);
  }

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  Iterator<T> get iterator => value.iterator;

  @override
  String join([String separator = ""]) {
    return value.join(separator);
  }

  @override
  T get last => value.last;

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return value.lastWhere(test, orElse: orElse);
  }

  @override
  int get length => value.length;

  @override
  T? lookup(Object? object) {
    return value.lookup(object);
  }

  @override
  Iterable<U> map<U>(U Function(T e) toElement) {
    return value.map(toElement);
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    return value.reduce(combine);
  }

  @override
  bool remove(Object? value) {
    bool result = this.value.remove(value);
    if (result) {
      notifyListeners();
    }
    return result;
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    value.removeAll(elements);
    notifyListeners();
  }

  @override
  void removeWhere(bool Function(T element) test) {
    value.removeWhere(test);
    notifyListeners();
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    value.retainAll(elements);
    notifyListeners();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    value.retainWhere(test);
    notifyListeners();
  }

  @override
  T get single => value.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return value.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int count) {
    return value.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    return value.skipWhile(test);
  }

  @override
  Iterable<T> take(int count) {
    return value.take(count);
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    return value.takeWhile(test);
  }

  @override
  List<T> toList({bool growable = true}) {
    return value.toList(growable: growable);
  }

  @override
  Set<T> toSet() {
    return value.toSet();
  }

  @override
  Set<T> union(Set<T> other) {
    return value.union(other);
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return value.where(test);
  }

  @override
  Iterable<U> whereType<U>() {
    return value.whereType<U>();
  }
}

class MapNotifier<K, V> extends Notifier
    implements MapListenable<K, V>, Map<K, V> {
  Map<K, V> _value;

  MapNotifier(this._value) : super();

  @override
  Map<K, V> get value => _value;
  set value(newValue) {
    SchedulerBinding.instance.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = Map<K, V>.from(newValue);
      notifyListeners();
    }, Priority.animation);
  }

  void notify() {
    notifyListeners();
  }

  /// Calls [action] then notifies listeners synchronously.
  void syncNotifyBlock(void Function(Map<K, V> map) action) {
    action(value);
    notifyListeners();
  }

  /// Calls [action] and if it completes successfully notifies listeners.
  void asyncNotifyBlock(
    Future Function(Map<K, V> map) asyncAction, {
    Function? onError,
  }) {
    asyncAction(value).then((value) => notifyListeners(), onError: onError);
  }

  @override
  V? operator [](Object? key) {
    return value[key];
  }

  @override
  void operator []=(K key, V value) {
    this.value[key] = value;
    notifyListeners();
  }

  @override
  void addAll(Map<K, V> other) {
    value.addAll(other);
    notifyListeners();
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    value.addEntries(newEntries);
    notifyListeners();
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    return value.cast<RK, RV>();
  }

  @override
  void clear() {
    value.clear();
    notifyListeners();
  }

  @override
  bool containsKey(Object? key) {
    return value.containsKey(key);
  }

  @override
  bool containsValue(Object? value) {
    return this.value.containsValue(value);
  }

  @override
  Iterable<MapEntry<K, V>> get entries => value.entries;

  @override
  void forEach(void Function(K key, V value) action) {
    value.forEach(action);
  }

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  Iterable<K> get keys => value.keys;

  @override
  int get length => value.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    return value.map(convert);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    V result = value.putIfAbsent(key, ifAbsent);
    notifyListeners();
    return result;
  }

  @override
  V? remove(Object? key) {
    V? result = value.remove(key);
    if (result != null) {
      notifyListeners();
    }
    return result;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    value.removeWhere(test);
    notifyListeners();
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    V result = value.update(key, update, ifAbsent: ifAbsent);
    notifyListeners();
    return result;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    value.updateAll(update);
    notifyListeners();
  }

  @override
  Iterable<V> get values => value.values;
}

/// A [ChangeNotifier] that holds a single value.
///
/// When [value] is replaced with something that is not equal to the old
/// value as evaluated by the equality operator ==, this class notifies its
/// listeners.
class SafeValueNotifier<T> extends Notifier implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  SafeValueNotifier(this._value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
