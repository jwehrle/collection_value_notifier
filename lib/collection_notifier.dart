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

class ListNotifier<T> extends Notifier implements ListListenable<T> {
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

  /// Wrapper for List getter [fist]
  /// Returns the first element.
  ///
  /// Throws a [StateError] if `this` is empty.
  /// Otherwise returns the first element in the iteration order,
  /// equivalent to `this.elementAt(0)`.
  T get first => _value.first;

  /// Wrapper for List getter [last]
  /// Returns the last element.
  ///
  /// Throws a [StateError] if `this` is empty.
  /// Otherwise may iterate through the elements and returns the last one
  /// seen.
  /// Some iterables may have more efficient ways to find the last element
  /// (for example a list can directly access the last element,
  /// without iterating through the previous ones).
  T get last => _value.last;

  /// Wrapper for List getter [length]
  /// Returns the number of elements in [this].
  ///
  /// Counting all elements may involve iterating through all elements and can
  /// therefore be slow.
  /// Some iterables have a more efficient way to find the number of elements.
  int get length => _value.length;

  /// Wrapper for List getter [isEmpty]
  /// Whether this collection has no elements.
  ///
  /// May be computed by checking if `iterator.moveNext()` returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final emptyList = <int>[];
  /// print(emptyList.isEmpty); // true;
  /// print(emptyList.iterator.moveNext()); // false
  /// ```
  bool get isEmpty => _value.isEmpty;

  /// Wrapper for List getter [isNotEmpty]
  /// Whether this collection has at least one element.
  ///
  /// May be computed by checking if `iterator.moveNext()` returns `true`.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>{1, 2, 3};
  /// print(numbers.isNotEmpty); // true;
  /// print(numbers.iterator.moveNext()); // true
  /// ```
  bool get isNotEmpty => _value.isNotEmpty;

  /// Wrapper for List getter [iterator]
  /// Returns a new `Iterator` that allows iterating the elements of this
  /// `Iterable`.
  ///
  /// Iterable classes may specify the iteration order of their elements
  /// (for example [List] always iterate in index order),
  /// or they may leave it unspecified (for example a hash-based [Set]
  /// may iterate in any order).
  ///
  /// Each time `iterator` is read, it returns a new iterator,
  /// which can be used to iterate through all the elements again.
  /// The iterators of the same iterable can be stepped through independently,
  /// but should return the same elements in the same order,
  /// as long as the underlying collection isn't changed.
  ///
  /// Modifying the collection may cause new iterators to produce
  /// different elements, and may change the order of existing elements.
  /// A [List] specifies its iteration order precisely,
  /// so modifying the list changes the iteration order predictably.
  /// A hash-based [Set] may change its iteration order completely
  /// when adding a new element to the set.
  ///
  /// Modifying the underlying collection after creating the new iterator
  /// may cause an error the next time [Iterator.moveNext] is called
  /// on that iterator.
  /// Any *modifiable* iterable class should specify which operations will
  /// break iteration.
  Iterator<T> get iterator => _value.iterator;

  /// Wrapper for List getter [reverser]
  /// An [Iterable] of the objects in this list in reverse order.
  /// ```dart
  /// final numbers = <String>['two', 'three', 'four'];
  /// final reverseOrder = numbers.reversed;
  /// print(reverseOrder.toList()); // [four, three, two]
  /// ```
  Iterable<T> get reversed => _value.reversed;

  /// Wrapper for List getter [single]
  /// Checks that this iterable has only one element, and returns that element.
  ///
  /// Throws a [StateError] if `this` is empty or has more than one element.
  T get single => _value.single;

  /// Wrapper for List operator [+]
  /// Returns the concatenation of this list and [other].
  ///
  /// Returns a new list containing the elements of this list followed by
  /// the elements of [other].
  ///
  /// The default behavior is to return a normal growable list.
  /// Some list types may choose to return a list of the same type as themselves
  /// (see [Uint8List.+]);
  List operator +(List<T> other) {
    return _value + other;
  }

  /// Wrapper for List operator bracket getter
  /// The object at the given [index] in the list.
  ///
  /// The [index] must be a valid index of this list,
  /// which means that `index` must be non-negative and
  /// less than [length].
  T operator [](int index) {
    return _value[index];
  }

  /// Wrapper for List operator bracket setter
  /// Notifies listeners
  /// Sets the value at the given [index] in the list to [value].
  ///
  /// The [index] must be a valid index of this list,
  /// which means that `index` must be non-negative and
  /// less than [length].
  void operator []=(int index, T value) {
    _value[index] = value;
    notifyListeners();
  }

  /// Wrapper for List method [add]
  /// Notifies listeners
  /// Adds [value] to the end of this list,
  /// extending the length by one.
  ///
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.add(4);
  /// print(numbers); // [1, 2, 3, 4]
  /// ```
  void add(T value) {
    _value.add(value);
    notifyListeners();
  }

  /// Wrapper for List method [addAll]
  /// Notifies listeners
  /// Appends all objects of [iterable] to the end of this list.
  ///
  /// Extends the length of the list by the number of objects in [iterable].
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.addAll([4, 5, 6]);
  /// print(numbers); // [1, 2, 3, 4, 5, 6]
  /// ```
  void addAll(Iterable<T> iterable) {
    _value.addAll(iterable);
    notifyListeners();
  }

  /// Wrapper for List method [any]
  /// Checks whether any element of this iterable satisfies [test].
  ///
  /// Checks every element in iteration order, and returns `true` if
  /// any of them make [test] return `true`, otherwise returns false.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.any((element) => element >= 5); // true;
  /// result = numbers.any((element) => element >= 10); // false;
  /// ```
  bool any(bool Function(T element) test) {
    return _value.any(test);
  }

  /// Wrapper for List method [asMap]
  /// An unmodifiable [Map] view of this list.
  ///
  /// The map uses the indices of this list as keys and the corresponding objects
  /// as values. The `Map.keys` [Iterable] iterates the indices of this list
  /// in numerical order.
  /// ```dart
  /// var words = <String>['fee', 'fi', 'fo', 'fum'];
  /// var map = words.asMap();  // {0: fee, 1: fi, 2: fo, 3: fum}
  /// map.keys.toList(); // [0, 1, 2, 3]
  /// ```
  Map<int, T> asMap() {
    return _value.asMap();
  }

  /// Wrapper for List method [cast]
  /// Provides a view of this iterable as an iterable of [R] instances.
  ///
  /// If this iterable only contains instances of [R], all operations
  /// will work correctly. If any operation tries to access an element
  /// that is not an instance of [R], the access will throw instead.
  ///
  /// When the returned iterable creates a new object that depends on
  /// the type [R], e.g., from [toList], it will have exactly the type [R].
  List<R> cast<R>() {
    return _value.cast<R>();
  }

  /// Wrapper for List method [clear]
  /// Notifies listeners
  /// Removes all objects from this list; the length of the list becomes zero.
  ///
  /// The list must be growable.
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3];
  /// numbers.clear();
  /// print(numbers.length); // 0
  /// print(numbers); // []
  /// ```
  void clear() {
    _value.clear();
    notifyListeners();
  }

  /// Wrapper for List method [contains]
  /// Whether the collection contains an element equal to [element].
  ///
  /// This operation will check each element in order for being equal to
  /// [element], unless it has a more efficient way to find an element
  /// equal to [element].
  ///
  /// The equality used to determine whether [element] is equal to an element of
  /// the iterable defaults to the [Object.==] of the element.
  ///
  /// Some types of iterable may have a different equality used for its elements.
  /// For example, a [Set] may have a custom equality
  /// (see [Set.identity]) that its `contains` uses.
  /// Likewise the `Iterable` returned by a [Map.keys] call
  /// should use the same equality that the `Map` uses for keys.
  ///
  /// Example:
  /// ```dart
  /// final gasPlanets = <int, String>{1: 'Jupiter', 2: 'Saturn'};
  /// final containsOne = gasPlanets.keys.contains(1); // true
  /// final containsFive = gasPlanets.keys.contains(5); // false
  /// final containsJupiter = gasPlanets.values.contains('Jupiter'); // true
  /// final containsMercury = gasPlanets.values.contains('Mercury'); // false
  /// ```
  bool contains(Object? element) {
    return _value.contains(element);
  }

  /// Wrapper for List method [elementAt]
  /// Returns the [index]th element.
  ///
  /// The [index] must be non-negative and less than [length].
  /// Index zero represents the first element (so `iterable.elementAt(0)` is
  /// equivalent to `iterable.first`).
  ///
  /// May iterate through the elements in iteration order, ignoring the
  /// first [index] elements and then returning the next.
  /// Some iterables may have a more efficient way to find the element.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// final elementAt = numbers.elementAt(4); // 6
  /// ```
  T elementAt(int index) {
    return _value.elementAt(index);
  }

  /// Wrapper for List method [every]
  /// Checks whether every element of this iterable satisfies [test].
  ///
  /// Checks every element in iteration order, and returns `false` if
  /// any of them make [test] return `false`, otherwise returns `true`.
  ///
  /// Example:
  /// ```dart
  /// final planetsByMass = <double, String>{0.06: 'Mercury', 0.81: 'Venus',
  ///   0.11: 'Mars'};
  /// // Checks whether all keys are smaller than 1.
  /// final every = planetsByMass.keys.every((key) => key < 1.0); // true
  /// ```
  bool every(bool Function(T element) test) {
    return _value.every(test);
  }

  /// Wrapper for List method [expand]
  /// Expands each element of this [Iterable] into zero or more elements.
  ///
  /// The resulting Iterable runs through the elements returned
  /// by [toElements] for each element of this, in iteration order.
  ///
  /// The returned [Iterable] is lazy, and calls [toElements] for each element
  /// of this iterable every time the returned iterable is iterated.
  ///
  /// Example:
  /// ```dart
  /// Iterable<int> count(int n) sync* {
  ///   for (var i = 1; i <= n; i++) {
  ///     yield i;
  ///    }
  ///  }
  ///
  /// var numbers = [1, 3, 0, 2];
  /// print(numbers.expand(count)); // (1, 1, 2, 3, 1, 2)
  /// ```
  ///
  /// Equivalent to:
  /// ```
  /// Iterable<T> expand<T>(Iterable<T> toElements(E e)) sync* {
  ///   for (var value in this) {
  ///     yield* toElements(value);
  ///   }
  /// }
  /// ```
  Iterable<U> expand<U>(Iterable<U> toElements(T element)) {
    return _value.expand(toElements);
  }

  /// Wrapper for List method [fillRange]
  /// Notifies listeners
  /// Overwrites a range of elements with [fillValue].
  ///
  /// Sets the positions greater than or equal to [start] and less than [end],
  /// to [fillValue].
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// If the element type is not nullable, the [fillValue] must be provided and
  /// must be non-`null`.
  ///
  /// Example:
  /// ```dart
  /// final words = List.filled(5, 'old');
  /// print(words); // [old, old, old, old, old]
  /// words.fillRange(1, 3, 'new');
  /// print(words); // [old, new, new, old, old]
  /// ```
  void fillRange(int start, int end, [T? fillValue]) {
    _value.fillRange(start, end, fillValue);
    notifyListeners();
  }

  /// Wrapper for List method [firstWhere]
  /// Returns the first element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.firstWhere((element) => element < 5); // 1
  /// result = numbers.firstWhere((element) => element > 5); // 6
  /// result =
  ///     numbers.firstWhere((element) => element > 10, orElse: () => -1); // -1
  /// ```
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// If [orElse] is omitted, it defaults to throwing a [StateError].
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _value.firstWhere(test, orElse: orElse);
  }

  /// Wrapper for List method [fold]
  /// Reduces a collection to a single value by iteratively combining each
  /// element of the collection with an existing value
  ///
  /// Uses [initialValue] as the initial value,
  /// then iterates through the elements and updates the value with
  /// each element using the [combine] function, as if by:
  /// ```
  /// var value = initialValue;
  /// for (E element in this) {
  ///   value = combine(value, element);
  /// }
  /// return value;
  /// ```
  /// Example of calculating the sum of an iterable:
  /// ```dart
  /// final numbers = <double>[10, 2, 5, 0.5];
  /// const initialValue = 100.0;
  /// final result = numbers.fold<double>(
  ///     initialValue, (previousValue, element) => previousValue + element);
  /// print(result); // 117.5
  /// ```
  U fold<U>(U initialValue, U Function(U previousValue, T element) combine) {
    return _value.fold(initialValue, combine);
  }

  /// Wrapper for List method [followedBy]
  /// Returns the lazy concatenation of this iterable and [other].
  ///
  /// The returned iterable will provide the same elements as this iterable,
  /// and, after that, the elements of [other], in the same order as in the
  /// original iterables.
  ///
  /// Example:
  /// ```dart
  /// var planets = <String>['Earth', 'Jupiter'];
  /// var updated = planets.followedBy(['Mars', 'Venus']);
  /// print(updated); // (Earth, Jupiter, Mars, Venus)
  /// ```
  Iterable<T> followedBy(Iterable<T> other) {
    return _value.followedBy(other);
  }

  /// Wrapper for List method [forEach]
  /// Invokes [action] on each element of this iterable in iteration order.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 6, 7];
  /// numbers.forEach(print);
  /// // 1
  /// // 2
  /// // 6
  /// // 7
  /// ```
  void forEach(void Function(T element) action) {
    _value.forEach(action);
  }

  /// Wrapper for List method [getRange]
  /// Creates an [Iterable] that iterates over a range of elements.
  ///
  /// The returned iterable iterates over the elements of this list
  /// with positions greater than or equal to [start] and less than [end].
  ///
  /// The provided range, [start] and [end], must be valid at the time
  /// of the call.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The returned [Iterable] behaves like `skip(start).take(end - start)`.
  /// That is, it does *not* break if this list changes size, it just
  /// ends early if it reaches the end of the list early
  /// (if `end`, or even `start`, becomes greater than [length]).
  /// ```dart
  /// final colors = <String>['red', 'green', 'blue', 'orange', 'pink'];
  /// final firstRange = colors.getRange(0, 3);
  /// print(firstRange.join(', ')); // red, green, blue
  ///
  /// final secondRange = colors.getRange(2, 5);
  /// print(secondRange.join(', ')); // blue, orange, pink
  /// ```
  Iterable<T> getRange(int start, int end) {
    return _value.getRange(start, end);
  }

  /// Wrapper for List method [indexOf]
  /// The first index of [element] in this list.
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `o == element`,
  /// the index of `o` is returned.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// print(notes.indexOf('re')); // 1
  ///
  /// final indexWithStart = notes.indexOf('re', 2); // 3
  /// ```
  /// Returns -1 if [element] is not found.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// final index = notes.indexOf('fa'); // -1
  /// ```
  int indexOf(T element, [int start = 0]) {
    return _value.indexOf(element, start);
  }

  /// Wrapper for List method [indexWhere]
  /// The first index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to the end of the list.
  /// The first time an object `o` is encountered so that `test(o)` is true,
  /// the index of `o` is returned.
  ///
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// final first = notes.indexWhere((note) => note.startsWith('r')); // 1
  /// final second = notes.indexWhere((note) => note.startsWith('r'), 2); // 3
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// final index = notes.indexWhere((note) => note.startsWith('k')); // -1
  /// ```
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    return _value.indexWhere(test, start);
  }

  /// Wrapper for List method [insert]
  /// Notifies listeners
  /// Inserts [element] at position [index] in this list.
  ///
  /// This increases the length of the list by one and shifts all objects
  /// at or after the index towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  ///
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4];
  /// const index = 2;
  /// numbers.insert(index, 10);
  /// print(numbers); // [1, 2, 10, 3, 4]
  /// ```
  void insert(int index, element) {
    _value.insert(index, element);
    notifyListeners();
  }

  /// Wrapper for List method [insertAll]
  /// Notifies listeners
  /// Inserts all objects of [iterable] at position [index] in this list.
  ///
  /// This increases the length of the list by the length of [iterable] and
  /// shifts all later objects towards the end of the list.
  ///
  /// The list must be growable.
  /// The [index] value must be non-negative and no greater than [length].
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4];
  /// final insertItems = [10, 11];
  /// numbers.insertAll(2, insertItems);
  /// print(numbers); // [1, 2, 10, 11, 3, 4]
  /// ```
  void insertAll(int index, Iterable<T> iterable) {
    _value.insertAll(index, iterable);
    notifyListeners();
  }

  /// Wrapper for List method [join]
  /// Converts each element to a [String] and concatenates the strings.
  ///
  /// Iterates through elements of this iterable,
  /// converts each one to a [String] by calling [Object.toString],
  /// and then concatenates the strings, with the
  /// [separator] string interleaved between the elements.
  ///
  /// Example:
  /// ```dart
  /// final planetsByMass = <double, String>{0.06: 'Mercury', 0.81: 'Venus',
  ///   0.11: 'Mars'};
  /// final joinedNames = planetsByMass.values.join('-'); // Mercury-Venus-Mars
  /// ```
  String join([String separator = ""]) {
    return _value.join(separator);
  }

  /// Wrapper for List method [lastIndexOf]
  /// The last index of [element] in this list.
  ///
  /// Searches the list backwards from index [start] to 0.
  ///
  /// The first time an object `o` is encountered so that `o == element`,
  /// the index of `o` is returned.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// const startIndex = 2;
  /// final index = notes.lastIndexOf('re', startIndex); // 1
  /// ```
  /// If [start] is not provided, this method searches from the end of the
  /// list.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// final index = notes.lastIndexOf('re'); // 3
  /// ```
  /// Returns -1 if [element] is not found.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// final index = notes.lastIndexOf('fa'); // -1
  /// ```
  int lastIndexOf(T element, [int? start]) {
    return _value.lastIndexOf(element, start);
  }

  /// Wrapper for List method [lastIndexWhere]
  /// The last index in the list that satisfies the provided [test].
  ///
  /// Searches the list from index [start] to 0.
  /// The first time an object `o` is encountered so that `test(o)` is true,
  /// the index of `o` is returned.
  /// If [start] is omitted, it defaults to the [length] of the list.
  ///
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// final first = notes.lastIndexWhere((note) => note.startsWith('r')); // 3
  /// final second = notes.lastIndexWhere((note) => note.startsWith('r'),
  ///     2); // 1
  /// ```
  ///
  /// Returns -1 if [element] is not found.
  /// ```dart
  /// final notes = <String>['do', 're', 'mi', 're'];
  /// final index = notes.lastIndexWhere((note) => note.startsWith('k'));
  /// print(index); // -1
  /// ```
  int lastIndexWhere(bool Function(T element) test, [int? start]) {
    return _value.lastIndexWhere(test, start);
  }

  /// Wrapper for List method [lastWhere]
  /// Returns the last element that satisfies the given predicate [test].
  ///
  /// An iterable that can access its elements directly may check its
  /// elements in any order (for example a list starts by checking the
  /// last element and then moves towards the start of the list).
  /// The default implementation iterates elements in iteration order,
  /// checks `test(element)` for each,
  /// and finally returns that last one that matched.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.lastWhere((element) => element < 5); // 3
  /// result = numbers.lastWhere((element) => element > 5); // 7
  /// result = numbers.lastWhere((element) => element > 10,
  ///     orElse: () => -1); // -1
  /// ```
  ///
  /// If no element satisfies [test], the result of invoking the [orElse]
  /// function is returned.
  /// If [orElse] is omitted, it defaults to throwing a [StateError].
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _value.lastWhere(test, orElse: orElse);
  }

  /// Wrapper for List method [map]
  /// The current elements of this iterable modified by [toElement].
  ///
  /// Returns a new lazy [Iterable] with elements that are created by
  /// calling `toElement` on each element of this `Iterable` in
  /// iteration order.
  ///
  /// The returned iterable is lazy, so it won't iterate the elements of
  /// this iterable until it is itself iterated, and then it will apply
  /// [toElement] to create one element at a time.
  /// The converted elements are not cached.
  /// Iterating multiple times over the returned [Iterable]
  /// will invoke the supplied [toElement] function once per element
  /// for on each iteration.
  ///
  /// Methods on the returned iterable are allowed to omit calling `toElement`
  /// on any element where the result isn't needed.
  /// For example, [elementAt] may call `toElement` only once.
  ///
  /// Equivalent to:
  /// ```
  /// Iterable<T> map<T>(T toElement(E e)) sync* {
  ///   for (var value in this) {
  ///     yield toElement(value);
  ///   }
  /// }
  /// ```
  /// Example:
  /// ```dart import:convert
  /// var products = jsonDecode('''
  /// [
  ///   {"name": "Screwdriver", "price": 42.00},
  ///   {"name": "Wingnut", "price": 0.50}
  /// ]
  /// ''');
  /// var values = products.map((product) => product['price'] as double);
  /// var totalPrice = values.fold(0.0, (a, b) => a + b); // 42.5.
  /// ```
  Iterable<U> map<U>(U Function(T e) toElement) {
    return _value.map(toElement);
  }

  /// Wrapper for List method [reduce]
  /// Reduces a collection to a single value by iteratively combining elements
  /// of the collection using the provided function.
  ///
  /// The iterable must have at least one element.
  /// If it has only one element, that element is returned.
  ///
  /// Otherwise this method starts with the first element from the iterator,
  /// and then combines it with the remaining elements in iteration order,
  /// as if by:
  /// ```
  /// E value = iterable.first;
  /// iterable.skip(1).forEach((element) {
  ///   value = combine(value, element);
  /// });
  /// return value;
  /// ```
  /// Example of calculating the sum of an iterable:
  /// ```dart
  /// final numbers = <double>[10, 2, 5, 0.5];
  /// final result = numbers.reduce((value, element) => value + element);
  /// print(result); // 17.5
  /// ```
  T reduce(T Function(T value, T element) combine) {
    return _value.reduce(combine);
  }

  /// Wrapper for List method [remove]
  /// Notifies listeners
  /// Removes the first occurrence of [value] from this list.
  ///
  /// Returns true if [value] was in the list, false otherwise.
  /// The list must be growable.
  ///
  /// ```dart
  /// final parts = <String>['head', 'shoulders', 'knees', 'toes'];
  /// final retVal = parts.remove('head'); // true
  /// print(parts); // [shoulders, knees, toes]
  /// ```
  /// The method has no effect if [value] was not in the list.
  /// ```dart
  /// final parts = <String>['shoulders', 'knees', 'toes'];
  /// // Note: 'head' has already been removed.
  /// final retVal = parts.remove('head'); // false
  /// print(parts); // [shoulders, knees, toes]
  /// ```
  bool remove(Object? value) {
    bool didRemove = _value.remove(value);
    if (didRemove) {
      notifyListeners();
    }
    return didRemove;
  }

  /// Wrapper for List method [removeAt]
  /// Notifies listeners
  /// Removes the object at position [index] from this list.
  ///
  /// This method reduces the length of `this` by one and moves all later objects
  /// down by one position.
  ///
  /// Returns the removed value.
  ///
  /// The [index] must be in the range `0 ≤ index < length`.
  /// The list must be growable.
  /// ```dart
  /// final parts = <String>['head', 'shoulder', 'knees', 'toes'];
  /// final retVal = parts.removeAt(2); // knees
  /// print(parts); // [head, shoulder, toes]
  /// ```
  T removeAt(int index) {
    T element = _value.removeAt(index);
    notifyListeners();
    return element;
  }

  /// Wrapper for List method [removeLast]
  /// Notifies listeners
  /// Removes and returns the last object in this list.
  ///
  /// The list must be growable and non-empty.
  /// ```dart
  /// final parts = <String>['head', 'shoulder', 'knees', 'toes'];
  /// final retVal = parts.removeLast(); // toes
  /// print(parts); // [head, shoulder, knees]
  /// ```
  T removeLast() {
    T element = _value.removeLast();
    notifyListeners();
    return element;
  }

  /// Wrapper for List method [removeRange]
  /// Notifies listeners
  /// Removes a range of elements from the list.
  ///
  /// Removes the elements with positions greater than or equal to [start]
  /// and less than [end], from the list.
  /// This reduces the list's length by `end - start`.
  ///
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The list must be growable.
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4, 5];
  /// numbers.removeRange(1, 4);
  /// print(numbers); // [1, 5]
  /// ```
  void removeRange(int start, int end) {
    _value.removeRange(start, end);
    notifyListeners();
  }

  /// Wrapper for List method [removeWhere]
  /// Notifies listeners
  /// Removes all objects from this list that satisfy [test].
  ///
  /// An object `o` satisfies [test] if `test(o)` is true.
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// numbers.removeWhere((item) => item.length == 3);
  /// print(numbers); // [three, four]
  /// ```
  /// The list must be growable.
  void removeWhere(bool Function(T) test) {
    _value.removeWhere(test);
    notifyListeners();
  }

  /// Wrapper for list extension [reorder]
  /// Notifies listeners
  /// Moves the item at [oldIndex] to [newIndex]
  void reorder(int oldIndex, int newIndex) {
    _value.reorder(oldIndex, newIndex);
    notifyListeners();
  }

  /// Wrapper for List method [replaceRange]
  /// Notifies listeners
  /// Replaces a range of elements with the elements of [replacements].
  ///
  /// Removes the objects in the range from [start] to [end],
  /// then inserts the elements of [replacements] at [start].
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4, 5];
  /// final replacements = [6, 7];
  /// numbers.replaceRange(1, 4, replacements);
  /// print(numbers); // [1, 6, 7, 5]
  /// ```
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The operation `list.replaceRange(start, end, replacements)`
  /// is roughly equivalent to:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4, 5];
  /// numbers.removeRange(1, 4);
  /// final replacements = [6, 7];
  /// numbers.insertAll(1, replacements);
  /// print(numbers); // [1, 6, 7, 5]
  /// ```
  /// but may be more efficient.
  ///
  /// The list must be growable.
  /// This method does not work on fixed-length lists, even when [replacements]
  /// has the same number of elements as the replaced range. In that case use
  /// [setRange] instead.
  void replaceRange(int start, int end, Iterable<T> replacements) {
    _value.replaceRange(start, end, replacements);
    notifyListeners();
  }

  /// Wrapper for List method [retainWhere]
  /// Notifies listeners
  /// Removes all objects from this list that fail to satisfy [test].
  ///
  /// An object `o` satisfies [test] if `test(o)` is true.
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// numbers.retainWhere((item) => item.length == 3);
  /// print(numbers); // [one, two]
  /// ```
  /// The list must be growable.
  void retainWhere(bool Function(T) test) {
    _value.retainWhere(test);
    notifyListeners();
  }

  /// Wrapper for List method [reverseRange]
  /// Notifies listeners
  /// Reverses a range of elements.
  void reverseRange(int start, int end) {
    _value.reverseRange(start, end);
    notifyListeners();
  }

  /// Wrapper for List method [shuffle]
  /// Notifies listeners
  /// Shuffles the elements of this list randomly.
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 4, 5];
  /// numbers.shuffle();
  /// print(numbers); // [1, 3, 4, 5, 2] OR some other random result.
  /// ```
  void shuffle([Random? random]) {
    _value.shuffle(random);
    notifyListeners();
  }

  /// Wrapper for List method [shuffleRange]
  /// Notifies listeners
  /// Shuffle a range of elements.
  void shuffleRange(int start, int end, [Random? random]) {
    _value.shuffleRange(start, end, random);
    notifyListeners();
  }

  /// Wrapper for List method [singleWhere]
  /// Returns the single element that satisfies [test].
  ///
  /// Checks elements to see if `test(element)` returns true.
  /// If exactly one element satisfies [test], that element is returned.
  /// If more than one matching element is found, throws [StateError].
  /// If no matching element is found, returns the result of [orElse].
  /// If [orElse] is omitted, it defaults to throwing a [StateError].
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[2, 2, 10];
  /// var result = numbers.singleWhere((element) => element > 5); // 10
  /// ```
  /// When no matching element is found, the result of calling [orElse] is
  /// returned instead.
  /// ```dart continued
  /// result = numbers.singleWhere((element) => element == 1,
  ///     orElse: () => -1); // -1
  /// ```
  /// There must not be more than one matching element.
  /// ```dart continued
  /// result = numbers.singleWhere((element) => element == 2); // Throws Error.
  ///
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _value.singleWhere(test, orElse: orElse);
  }

  /// Wrapper for List method [skip]
  /// Returns an [Iterable] that provides all but the first [count] elements.
  ///
  /// When the returned iterable is iterated, it starts iterating over `this`,
  /// first skipping past the initial [count] elements.
  /// If `this` has fewer than `count` elements, then the resulting Iterable is
  /// empty.
  /// After that, the remaining elements are iterated in the same order as
  /// in this iterable.
  ///
  /// Some iterables may be able to find later elements without first iterating
  /// through earlier elements, for example when iterating a [List].
  /// Such iterables are allowed to ignore the initial skipped elements.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// final result = numbers.skip(4); // (6, 7)
  /// final skipAll = numbers.skip(100); // () - no elements.
  /// ```
  ///
  /// The [count] must not be negative.
  Iterable<T> skip(int count) {
    return _value.skip(count);
  }

  /// Wrapper for List method [skipWhile]
  /// Returns an `Iterable` that skips leading elements while [test] is satisfied.
  ///
  /// The filtering happens lazily. Every new [Iterator] of the returned
  /// iterable iterates over all elements of `this`.
  ///
  /// The returned iterable provides elements by iterating this iterable,
  /// but skipping over all initial elements where `test(element)` returns
  /// true. If all elements satisfy `test` the resulting iterable is empty,
  /// otherwise it iterates the remaining elements in their original order,
  /// starting with the first element for which `test(element)` returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.skipWhile((x) => x < 5); // (5, 6, 7)
  /// result = numbers.skipWhile((x) => x != 3); // (3, 5, 6, 7)
  /// result = numbers.skipWhile((x) => x != 4); // ()
  /// result = numbers.skipWhile((x) => x.isOdd); // (2, 3, 5, 6, 7)
  /// ```
  Iterable<T> skipWhile(bool Function(T value) test) {
    return _value.skipWhile(test);
  }

  /// Wrapper for List method [setAll]
  /// Notifies listeners
  /// Overwrites elements with the objects of [iterable].
  ///
  /// The elements of [iterable] are written into this list,
  /// starting at position [index].
  /// This operation does not increase the length of the list.
  ///
  /// The [index] must be non-negative and no greater than [length].
  ///
  /// The [iterable] must not have more elements than what can fit from [index]
  /// to [length].
  ///
  /// If `iterable` is based on this list, its values may change _during_ the
  /// `setAll` operation.
  /// ```dart
  /// final list = <String>['a', 'b', 'c', 'd'];
  /// list.setAll(1, ['bee', 'sea']);
  /// print(list); // [a, bee, sea, d]
  /// ```
  void setAll(int index, Iterable<T> iterable) {
    _value.setAll(index, iterable);
    notifyListeners();
  }

  /// Wrapper for List method [setRange]
  /// Notifies listeners
  /// Writes some elements of [iterable] into a range of this list.
  ///
  /// Copies the objects of [iterable], skipping [skipCount] objects first,
  /// into the range from [start], inclusive, to [end], exclusive, of this list.
  /// ```dart
  /// final list1 = <int>[1, 2, 3, 4];
  /// final list2 = <int>[5, 6, 7, 8, 9];
  /// // Copies the 4th and 5th items in list2 as the 2nd and 3rd items
  /// // of list1.
  /// const skipCount = 3;
  /// list1.setRange(1, 3, list2, skipCount);
  /// print(list1); // [1, 8, 9, 4]
  /// ```
  /// The provided range, given by [start] and [end], must be valid.
  /// A range from [start] to [end] is valid if 0 ≤ `start` ≤ `end` ≤ [length].
  /// An empty range (with `end == start`) is valid.
  ///
  /// The [iterable] must have enough objects to fill the range from `start`
  /// to `end` after skipping [skipCount] objects.
  ///
  /// If `iterable` is this list, the operation correctly copies the elements
  /// originally in the range from `skipCount` to `skipCount + (end - start)` to
  /// the range `start` to `end`, even if the two ranges overlap.
  ///
  /// If `iterable` depends on this list in some other way, no guarantees are
  /// made.
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _value.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  /// Wrapper for List method [sort]
  /// Notifies listeners
  /// Sorts this list according to the order specified by the [compare] function.
  ///
  /// The [compare] function must act as a [Comparator].
  /// ```dart
  /// final numbers = <String>['two', 'three', 'four'];
  /// // Sort from shortest to longest.
  /// numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers); // [two, four, three]
  /// ```
  /// The default [List] implementations use [Comparable.compare] if
  /// [compare] is omitted.
  /// ```dart
  /// final numbers = <int>[13, 2, -11, 0];
  /// numbers.sort();
  /// print(numbers); // [-11, 0, 2, 13]
  /// ```
  /// In that case, the elements of the list must be [Comparable] to
  /// each other.
  ///
  /// A [Comparator] may compare objects as equal (return zero), even if they
  /// are distinct objects.
  /// The sort function is not guaranteed to be stable, so distinct objects
  /// that compare as equal may occur in any order in the result:
  /// ```dart
  /// final numbers = <String>['one', 'two', 'three', 'four'];
  /// numbers.sort((a, b) => a.length.compareTo(b.length));
  /// print(numbers); // [one, two, four, three] OR [two, one, four, three]
  /// ```
  void sort([int Function(T, T)? compare]) {
    _value.sort(compare);
    notifyListeners();
  }

  /// Wrapper for List method [sortBy]
  /// Notifies listeners
  /// Sorts elements by the natural order of their [keyOf] property.
  ///
  /// Sorts elements from [start] to [end], defaulting to the entire list.
  void sortBy<K extends Comparable<K>>(K Function(T) keyOf) {
    _value.sortedBy(keyOf);
    notifyListeners();
  }

  /// Wrapper for List method [sortRange]
  /// Notifies listeners
  /// Sort a range of elements by [compare].
  void sortRange(int start, int end, int Function(T a, T b) compare) {
    _value.sortRange(start, end, compare);
    notifyListeners();
  }

  /// Wrapper for List method [subList]
  /// Returns a new list containing the elements between [start] and [end].
  ///
  /// The new list is a `List<E>` containing the elements of this list at
  /// positions greater than or equal to [start] and less than [end] in the same
  /// order as they occur in this list.
  ///
  /// ```dart
  /// final colors = <String>['red', 'green', 'blue', 'orange', 'pink'];
  /// print(colors.sublist(1, 3)); // [green, blue]
  /// ```
  ///
  /// If [end] is omitted, it defaults to the [length] of this list.
  ///
  /// ```dart
  /// final colors = <String>['red', 'green', 'blue', 'orange', 'pink'];
  /// print(colors.sublist(3)); // [orange, pink]
  /// ```
  ///
  /// The `start` and `end` positions must satisfy the relations
  /// 0 ≤ `start` ≤ `end` ≤ [length].
  /// If `end` is equal to `start`, then the returned list is empty.
  List<T> subList(int start, [int? end]) {
    return _value.sublist(start, end);
  }

  /// Wrapper for List method [swap]
  /// Notifies listeners
  /// Swaps two elements of this list.
  void swap(int index1, int index2) {
    _value.swap(index1, index2);
    notifyListeners();
  }

  /// Wrapper for List method [take]
  /// Returns a lazy iterable of the [count] first elements of this iterable.
  ///
  /// The returned `Iterable` may contain fewer than `count` elements, if `this`
  /// contains fewer than `count` elements.
  ///
  /// The elements can be computed by stepping through [iterator] until [count]
  /// elements have been seen.
  ///
  /// The `count` must not be negative.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// final result = numbers.take(4); // (1, 2, 3, 5)
  /// final takeAll = numbers.take(100); // (1, 2, 3, 5, 6, 7)
  /// ```
  Iterable<T> take(int count) {
    return _value.take(count);
  }

  /// Wrapper for List method [takeWhile]
  /// Returns a lazy iterable of the leading elements satisfying [test].
  ///
  /// The filtering happens lazily. Every new iterator of the returned
  /// iterable starts iterating over the elements of `this`.
  ///
  /// The elements can be computed by stepping through [iterator] until an
  /// element is found where `test(element)` is false. At that point,
  /// the returned iterable stops (its `moveNext()` returns false).
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.takeWhile((x) => x < 5); // (1, 2, 3)
  /// result = numbers.takeWhile((x) => x != 3); // (1, 2)
  /// result = numbers.takeWhile((x) => x != 4); // (1, 2, 3, 5, 6, 7)
  /// result = numbers.takeWhile((x) => x.isOdd); // (1)
  /// ```
  Iterable<T> takeWhile(bool Function(T value) test) {
    return _value.takeWhile(test);
  }

  /// Wrapper for List method [where]
  /// Returns a new lazy [Iterable] with all elements that satisfy the
  /// predicate [test].
  ///
  /// The matching elements have the same order in the returned iterable
  /// as they have in [iterator].
  ///
  /// This method returns a view of the mapped elements.
  /// As long as the returned [Iterable] is not iterated over,
  /// the supplied function [test] will not be invoked.
  /// Iterating will not cache results, and thus iterating multiple times over
  /// the returned [Iterable] may invoke the supplied
  /// function [test] multiple times on the same element.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.where((x) => x < 5); // (1, 2, 3)
  /// result = numbers.where((x) => x > 5); // (6, 7)
  /// result = numbers.where((x) => x.isEven); // (2, 6)
  /// ```
  Iterable<T> where(bool Function(T element) test) {
    return _value.where(test);
  }

  /// Wrapper for List method [whereType]
  /// Returns a new lazy [Iterable] with all elements that have type [T].
  ///
  /// The matching elements have the same order in the returned iterable
  /// as they have in [iterator].
  ///
  /// This method returns a view of the mapped elements.
  /// Iterating will not cache results, and thus iterating multiple times over
  /// the returned [Iterable] may yield different results,
  /// if the underlying elements change between iterations.
  Iterable<U> whereType<U>() {
    return _value.whereType<U>();
  }
}

class SetNotifier<T> extends Notifier implements SetListenable<T> {
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
}

class MapNotifier<K, V> extends Notifier implements MapListenable<K, V> {
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
