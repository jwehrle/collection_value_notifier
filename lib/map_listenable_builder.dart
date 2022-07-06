import 'package:flutter/material.dart';
import 'package:collection_value_notifier/collection_notifier.dart';

typedef MapValueWidgetBuilder<K, V> = Widget Function(
    BuildContext context, Map<K, V> value, Widget? child);

class MapValueListenableBuilder<K, V> extends StatefulWidget {
  const MapValueListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.builder,
    this.child,
  }) : super(key: key);

  final MapListenable<K, V> valueListenable;
  final MapValueWidgetBuilder<K, V> builder;
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
