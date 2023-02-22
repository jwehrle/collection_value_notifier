library collection_notifier;

import 'dart:async';
import 'dart:collection';
import 'package:collection_value_notifier/collections.dart';
import 'package:flutter/foundation.dart';

/// Adapted from ChangeNotifier and ValueListenable and ValueNotifier for Lists,
/// Sets, and Maps and to expose notifyListeners().

/// A VoidCallback wrapper element for a LinkedList of listeners
class _ListenerEntry extends LinkedListEntry<_ListenerEntry> {
  _ListenerEntry(this.listener);
  final VoidCallback listener;
}

/// Copied from ChangeNotifier
/// A class that can be extended or mixed in that provides a change notification
/// API using [VoidCallback] for notifications.
///
/// It is O(1) for adding listeners and O(N) for removing listeners and dispatching
/// notifications (where N is the number of listeners).
///
/// {@macro flutter.flutter.animatedbuilder_changenotifier.rebuild}
///
/// See also:
///
///  * [ListNotifier], [SetNotifier], and [MapNotifier]
class CollectionNotifier implements Listenable {
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

  @protected
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
            yield DiagnosticsProperty<CollectionNotifier>(
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

/// An abstract class providing method signatures for modifying an underlying
/// collection.
/// See:
/// [ListNotifier], [SetNotifier], and [MapNotifier]
abstract class CollectionController<C> {
  /// Asynchronously evaluates whether the new value is different from current
  /// value using DeepCollectionEquality during a scheduled task between frames
  /// and, if different, assigns new value and notifies listeners otherwise does
  /// nothing.
  set value(C collection);

  /// Sets underlying collection data and notifies listeners immediately  as
  /// opposed to value setter which schedules a deep equivalence check between
  /// frames. This is best used when you know the underlying data has changed
  /// and want listeners to rebuild immediately.
  set collection(C collection);

  /// Calls [action] and directly assigns result to value without evaluating
  /// equality and notifies listeners unless there is an error, in which case
  /// [onError] is called if it has been supplied
  void asyncEditBlock(Future<C> Function(C collection) asyncAction,
      {Function? onError});

  /// Awaits completion and directly assigns result to value without evaluating
  /// equality and notifies listeners unless there is an error, in which case
  /// [onError] is called if it has been supplied
  void completerEditBlock(Completer<C> completer, {Function? onError});

  /// Calls [action] and directly assigns result to value without evaluating
  /// equality and notifies listeners
  void syncEditBlock(C Function(C collection) action);
}
