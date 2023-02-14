import 'dart:math';

extension ListExtensions<T> on List<T> {
  /// Extension method on List that reorders one element of a list.
  /// [oldIndex] is the current index of the element to be moved.
  /// [newIndex] is the destination index for the element to be moved.
  /// If list:
  ///    has less than 2 members,
  ///    oldIndex or newIndex are out of bounds,
  ///    oldIndex equals newIndex,
  /// this method returns without making any changes.
  void reorder(int oldIndex, int newIndex) {
    if (length < 2) {
      return;
    }
    if (oldIndex >= length) {
      return;
    }
    if (newIndex >= length) {
      return;
    }
    if (oldIndex.isNegative) {
      return;
    }
    if (newIndex.isNegative) {
      return;
    }
    if (oldIndex == newIndex) {
      return;
    }
    final moving = removeAt(oldIndex);
    insert(newIndex, moving);
  }
}

abstract class ExtendedIterable<T> {
  /// The first element, or `null` if the iterable is empty.
  T? get firstOrNull;

  /// The last element, or `null` if the iterable is empty.
  T? get lastOrNull;

  /// The single element of the iterable, or `null`.
  ///
  /// The value is `null` if the iterable is empty
  /// or it contains more than one element.
  T? get singleOrNull;

  /// Expands each element and index to a number of elements in a new iterable.
  ///
  /// Like [Iterable.expand] except that the callback function is supplied with
  /// both the index and the element.
  Iterable<R> expandIndexed<R>(
      Iterable<R> Function(int index, T element) expand);

  /// Whether the elements are sorted by the [compare] ordering.
  ///
  /// Compares pairs of elements using `compare` to check that
  /// the elements of this iterable to check
  /// that earlier elements always compare
  /// smaller than or equal to later elements.
  ///
  /// An single-element or empty iterable is trivially in sorted order.
  bool isSorted(Comparator<T> compare);

  /// Whether the elements are sorted by their [keyOf] property.
  ///
  /// Applies [keyOf] to each element in iteration order,
  /// then checks whether the results are in non-decreasing [Comparable] order.
  bool isSortedBy<K extends Comparable<K>>(K Function(T element) keyOf);

  /// Whether the elements are [compare]-sorted by their [keyOf] property.
  ///
  /// Applies [keyOf] to each element in iteration order,
  /// then checks whether the results are in non-decreasing order
  /// using the [compare] [Comparator]..
  bool isSortedByCompare<K>(K Function(T element) keyOf, Comparator<K> compare);

  /// The first element whose value and index satisfies [test].
  ///
  /// Returns `null` if there are no element and index satisfying [test].
  T? firstWhereIndexedOrNull(bool Function(int index, T element) test);

  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test);

  /// Combine the elements with a value and the current index.
  ///
  /// Calls [combine] for each element with the current index,
  /// the result of the previous call, or [initialValue] for the first element,
  /// and the current element.
  ///
  /// Returns the result of the last call to [combine],
  /// or [initialValue] if there are no elements.
  R foldIndexed<R>(
      R initialValue, R Function(int index, R previous, T element) combine);

  /// Takes an action for each element.
  ///
  /// Calls [action] for each element along with the index in the
  /// iteration order.
  void forEachIndexed(void Function(int index, T element) action);

  /// Takes an action for each element and index as long as desired.
  ///
  /// Calls [action] for each element along with the index in the
  /// iteration order.
  /// Stops iteration if [action] returns `false`.
  void forEachIndexedWhile(bool Function(int index, T element) action);

  /// Takes an action for each element as long as desired.
  ///
  /// Calls [action] for each element.
  /// Stops iteration if [action] returns `false`.
  void forEachWhile(bool Function(T element) action);

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
      K Function(T element) keyOf, G Function(G? previous, T element) combine);

  /// Groups elements into lists by [keyOf].
  Map<K, List<T>> groupListsBy<K>(K Function(T element) keyOf);

  /// Groups elements into sets by [keyOf].
  Map<K, Set<T>> groupSetsBy<K>(K Function(T element) keyOf);

  /// The last element whose index and value satisfies [test].
  ///
  /// Returns `null` if no element and index satisfies [test].
  T? lastWhereIndexedOrNull(bool Function(int index, T element) test);

  /// The last element satisfying [test], or `null` if there are none.
  T? lastWhereOrNull(bool Function(T element) test);

  /// Maps each element and its index to a new value.
  Iterable<R> mapIndexed<R>(R Function(int index, T element) convert);

  /// Whether no element satisfies [test].
  ///
  /// Returns true if no element satisfies [test],
  /// and false if at least one does.
  ///
  /// Equivalent to `iterable.every((x) => !test(x))` or
  /// `!iterable.any(test)`.
  bool none(bool Function(T) test);

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
  T reduceIndexed(T Function(int index, T previous, T element) combine);

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
  List<T> sample(int count, [Random? random]);

  /// The single element satisfying [test].
  ///
  /// Returns `null` if there are either none
  /// or more than one element and index satisfying [test].
  T? singleWhereIndexedOrNull(bool Function(int index, T element) test);

  /// The single element satisfying [test].
  ///
  /// Returns `null` if there are either no elements
  /// or more than one element satisfying [test].
  ///
  /// **Notice**: This behavior differs from [Iterable.singleWhere]
  /// which always throws if there are more than one match,
  /// and only calls the `orElse` function on zero matches.
  T? singleWhereOrNull(bool Function(T element) test);

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
  Iterable<List<T>> slices(int length);

  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the [compare] [Comparator].
  List<T> sorted(Comparator<T> compare);

  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the natural ordering of the
  /// property [keyOf] of the element.
  List<T> sortedBy<K extends Comparable<K>>(K Function(T element) keyOf);

  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the [compare] [Comparator] of the
  /// property [keyOf] of the element.
  List<T> sortedByCompare<K>(
      K Function(T element) keyOf, Comparator<K> compare);

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
  Iterable<List<T>> splitAfter(bool Function(T element) test);

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
  Iterable<List<T>> splitAfterIndexed(bool Function(int index, T element) test);

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
  Iterable<List<T>> splitBefore(bool Function(T element) test);

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
      bool Function(int index, T element) test);

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
  Iterable<List<T>> splitBetween(bool Function(T first, T second) test);

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
      bool Function(int index, T first, T second) test);

  /// The elements whose value and index satisfies [test].
  Iterable<T> whereIndexed(bool Function(int index, T element) test);

  /// The elements that do not satisfy [test].
  Iterable<T> whereNot(bool Function(T element) test);

  /// The elements whose value and index do not satisfy [test].
  Iterable<T> whereNotIndexed(bool Function(int index, T element) test);
}

/// See ListExtensions<T> in:
///   collection-1.16.0/lib/src/extensions.dart,
///   extensions.dart
/// And IterableExtension<T> in:
///   collection-1.16.0/lib/src/iterable_extensions.dart
abstract class ExtendedList<T> {
  /// Extension method on List that reorders one element of a list.
  /// [oldIndex] is the current index of the element to be moved.
  /// [newIndex] is the destination index for the element to be moved.
  /// If list:
  ///    has less than 2 members,
  ///    oldIndex or newIndex are out of bounds,
  ///    oldIndex equals newIndex,
  /// this method returns without making any changes.
  void reorder(int oldIndex, int newIndex);

  /// Reverses the elements in a range of the list.
  void reverseRange(int start, int end);

  /// Shuffle a range of elements.
  void shuffleRange(int start, int end, [Random? random]);

  /// Creates a sorted list of the elements of the iterable.
  ///
  /// The elements are ordered by the natural ordering of the
  /// property [keyOf] of the element.
  void sortBy<K extends Comparable<K>>(K Function(T) keyOf);

  /// Sort a range of elements by [compare].
  void sortRange(int start, int end, int Function(T a, T b) compare);

  /// Swaps two elements of this list.
  void swap(int index1, int index2);
}
