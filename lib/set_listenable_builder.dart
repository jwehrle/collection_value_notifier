import 'package:flutter/material.dart';
import 'package:collection_value_notifier/collection_notifier.dart';

typedef SetWidgetBuilder<T> = Widget Function(
    BuildContext context, Set<T> value, Widget? child);

class SetListenableBuilder<T> extends StatefulWidget {
  const SetListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.builder,
    this.child,
  }) : super(key: key);

  final SetListenable<T> valueListenable;
  final SetWidgetBuilder<T> builder;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _SetListenableBuilderState<T>();
}

class _SetListenableBuilderState<T> extends State<SetListenableBuilder<T>> {
  late Set<T> value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(SetListenableBuilder<T> oldWidget) {
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
