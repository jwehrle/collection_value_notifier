A Flutter package for using Lists, Sets, and Maps in ChangeNotifiers with built-in builders triggered by collection modifications. These make perfect base classes for custom controllers.

Works with all Flutter use-cases since it has no platform plugins and does not require Material or Cupertino parent widgets.

![](assets/release.gif)

## Features

Use this package in your Flutter app to:
- Listen for changes to an underlying data set.
- Rebuild widgets only when a deep equivalence evaluation shows a list, set, map has been modified.
- Inject collections to child widgets and intelligently propagate those changes to any other listeners.
- Maintain one complex collection-based state throughout the app.
- Use more StatelessWidgets with collection builder widgets.

## Usage

    //Import
    import 'package:collection_value_notifier/collections.dart';

    // Declare 
    final ListNotifier<int> listNotifier = ListNotifier([0, 1, 2]);
    
    // Add listener
    listNotifier.addListener(() {});
    // Remove listener
    listNotifier.removeListener(() {});

    // Builder
    ListListenableBuilder<int>(
      valueListenable: listNotifier,
      builder: (context, list, _) {
        < do something with list >
      },
    );

    // Modifcations such as
    listNotifier[0] = 10;
    or    
    listNotifier.removeAt(1);
    // will notify listeners.

    // Remember to dispose just as you would for a ValueNotifier
    listNotifier.dispose();

## Installing

    flutter pub add collection_value_notifier

## Repository (Github)

[https://github.com/jwehrle/collection_value_notifier.git](https://github.com/jwehrle/collection_value_notifier.git)