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
    insert(oldIndex < newIndex ? newIndex - 1 : newIndex, removeAt(oldIndex));
  }

  /// Extension method on List that returns either the first element matching
  /// test or null if no elements match test.
  T? findFirstWhere(bool Function(T item) test) {
    T? result;
    for (var item in this) {
      if (test(item)) {
        result = item;
        break;
      }
    }
    return result;
  }
}
