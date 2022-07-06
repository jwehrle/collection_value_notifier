library collection_notifier;

import 'dart:collection';

import 'package:collection/collection.dart';
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

  void notify() {
    notifyListeners();
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
