import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection_value_notifier/collection_notifier.dart';

typedef ListValueWidgetBuilder<T> = Widget Function(
    BuildContext context, List<T> value, Widget? child);

class ListValueListenableBuilder<T> extends StatefulWidget {
  const ListValueListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ListListenable<T> valueListenable;
  final ListValueWidgetBuilder<T> builder;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _ListValueListenableBuilderState<T>();
}

class _ListValueListenableBuilderState<T>
    extends State<ListValueListenableBuilder<T>> {
  late List<T> value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(ListValueListenableBuilder<T> oldWidget) {
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
