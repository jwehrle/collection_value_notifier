extension ListExtensions<T> on List<T> {
  void reorder(int oldIndex, int newIndex) {
    insert(oldIndex < newIndex ? newIndex - 1 : newIndex, removeAt(oldIndex));
  }
}
