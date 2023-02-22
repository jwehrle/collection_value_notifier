import 'package:collection_value_notifier/src/notifiers/map_notifier.dart';
import 'package:flutter/material.dart';

/// Builds a [Widget] when given a concrete map value of a [MapValueWidgetBuilder<T>].
///
/// If the `child` parameter provided to the [MapValueWidgetBuilder] is not
/// null, the same `child` widget is passed back to this [MapValueWidgetBuilder]
/// and should typically be incorporated in the returned widget tree.
///
/// See also:
///
///  * [MapListenableBuilder], a widget which invokes this builder each time
///    a [MapListenable] changes value.
typedef MapValueWidgetBuilder<K, V> = Widget Function(
    BuildContext context, Map<K, V> value, Widget? child);

/// A widget whose content stays synced with a [MapListenable].
///
/// Given a [MapListenable<K, V>] and a [builder] which builds widgets from
/// concrete values of Map<K, V>, this class will automatically register itself as a
/// listener of the [MapListenable] and call the [builder] with updated values
/// when the value changes.
///
/// ## Performance optimizations
///
/// If your [builder] function contains a subtree that does not depend on the
/// value of the [MapListenable], it's more efficient to build that subtree
/// once instead of rebuilding it on every animation tick.
///
/// If you pass the pre-built subtree as the [child] parameter, the
/// [MapListenableBuilder] will pass it back to your [builder] function so
/// that you can incorporate it into your build.
///
/// Using this pre-built child is entirely optional, but can improve
/// performance significantly in some cases and is therefore a good practice.
///
/// {@tool snippet}
///
/// This sample shows how you could use a [MapListenableBuilder] instead of
/// setting state on the whole [Scaffold] in the default `flutter create` app.
///
/// ```dart
/// class MyHomePage extends StatefulWidget {
///   const MyHomePage({super.key, required this.title});
///   final String title;
///
///   @override
///   State<MyHomePage> createState() => _MyHomePageState();
/// }
///
/// class _MyHomePageState extends State<MyHomePage> {
///   final MapNotifier<String, int> _counter = MapNotifier<String, int>({'num': 0});
///   final Widget goodJob = const Text('Good job!');
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(widget.title)
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: <Widget>[
///             const Text('You have pushed the button this many times:'),
///             MapListenableBuilder<String, int>(
///               builder: (BuildContext context, Map<String, int> value, Widget? child) {
///                 // This builder will only get called when the _counter
///                 // is updated.
///                 return Row(
///                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///                   children: <Widget>[
///                     Text('${value['num']}'),
///                     child!,
///                   ],
///                 );
///               },
///               valueListenable: _counter,
///               // The child parameter is most helpful if the child is
///               // expensive to build and does not depend on the value from
///               // the notifier.
///               child: goodJob,
///             )
///           ],
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         child: const Icon(Icons.plus_one),
///         onPressed: () => _counter.syncEditBlock((map) {
///           return map['num'] += 1;
///         },
///       ),
///     );
///   }
///
///   @override
///   void dispose() {
///     _counter.dispose();
///     super.dispose();
///   }
/// }
/// ```
/// {@end-tool}
class MapValueListenableBuilder<K, V> extends StatefulWidget {
  /// Creates a [MapValueListenableBuilder].
  ///
  /// The [valueListenable] and [builder] arguments must not be null.
  /// The [child] is optional but is good practice to use if part of the widget
  /// subtree does not depend on the value of the [valueListenable].
  const MapValueListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.builder,
    this.child,
  }) : super(key: key);

  /// The [MapListenable] whose value you depend on in order to build.
  ///
  /// This widget does not ensure that the [MapListenable]'s value is not
  /// null, therefore your [builder] may need to handle null values.
  ///
  /// This [MapListenable] itself must not be null.
  final MapListenable<K, V> valueListenable;

  /// A [MapValueWidgetBuilder] which builds a widget depending on the
  /// [valueListenable]'s value.
  ///
  /// Can incorporate a [valueListenable] value-independent widget subtree
  /// from the [child] parameter into the returned widget tree.
  ///
  /// Must not be null.
  final MapValueWidgetBuilder<K, V> builder;

  /// A [valueListenable]-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree
  /// the [builder] builds depends on the value of the [valueListenable].
  final Widget? child;

  @override
  State<StatefulWidget> createState() =>
      _MapValueListenableBuilderState<K, V>();
}

class _MapValueListenableBuilderState<K, V>
    extends State<MapValueListenableBuilder<K, V>> {
  late Map<K, V> value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(MapValueListenableBuilder<K, V> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      value = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = widget.valueListenable.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, widget.child);
  }
}