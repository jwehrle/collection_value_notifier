library collection_notifier;

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  LinkedList<_ListenerEntry>? _listeners = LinkedList<_ListenerEntry>();

  bool _debugAssertNotDisposed() {
    assert(() {
      if (_listeners == null) {
        throw FlutterError('A $runtimeType was used after being disposed.\n'
            'Once you have called dispose() on a $runtimeType, it can no longer be used.');
      }
      return true;
    }());
    return true;
  }

  bool get hasListeners {
    assert(_debugAssertNotDisposed());
    return _listeners!.isNotEmpty;
  }

  @override
  void addListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    _listeners!.add(_ListenerEntry(listener));
  }

  @override
  void removeListener(VoidCallback listener) {
    assert(_debugAssertNotDisposed());
    for (final _ListenerEntry entry in _listeners!) {
      if (entry.listener == listener) {
        entry.unlink();
        return;
      }
    }
  }

  @mustCallSuper
  void dispose() {
    assert(_debugAssertNotDisposed());
    _listeners = null;
  }

  void notifyListeners() {
    assert(_debugAssertNotDisposed());
    if (_listeners!.isEmpty) return;

    final List<_ListenerEntry> localListeners =
        List<_ListenerEntry>.from(_listeners!);

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

class ListNotifier<T> extends ValueNotifier implements ListListenable<T> {
  List<T> _value;

  ListNotifier(this._value) : super(_value);

  @override
  List<T> get value => _value;
  set value(newValue) {
    SchedulerBinding.instance?.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = List<T>.from(newValue as List);
      notifyListeners();
    }, Priority.animation);
  }

  void notify() {
    notifyListeners();
  }
}

class SetNotifier<T> extends ValueNotifier implements SetListenable<T> {
  Set<T> _value;

  SetNotifier(this._value) : super(_value);

  @override
  Set<T> get value => _value;
  set value(newValue) {
    SchedulerBinding.instance?.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = Set<T>.from(newValue);
      notifyListeners();
    }, Priority.animation);
  }

  void notify() {
    notifyListeners();
  }
}

class MapNotifier<K, V> extends ValueNotifier implements MapListenable<K, V> {
  Map<K, V> _value;

  MapNotifier(this._value) : super(_value);

  @override
  Map<K, V> get value => _value;
  set value(newValue) {
    SchedulerBinding.instance?.scheduleTask(() {
      if (DeepCollectionEquality().equals(_value, newValue)) return;
      _value = Map<K, V>.from(newValue);
      notifyListeners();
    }, Priority.animation);
  }

  void notify() {
    notifyListeners();
  }
}
