import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
//import 'package:rx_bloc/rx_bloc.dart';

/// Used as a DI widget where an instance of a [bloc] can be provided
/// to multiple widgets within a subtree.
/// Takes a [ValueBuilder] that is responsible for creating the [bloc]
/// and a [child] which will have access to the [bloc]
/// via `RxBlocProvider.of(context)`.
///
/// Automatically handles disposing of the [bloc] when used with [create]
/// and lazily creates the [bloc] if [lazy] is not explicitly set to `false`.
///
/// ```dart
/// RxBlocProvider(
///   create: (BuildContext context) => BlocA(),
///   dispose: (BuildContext context, BlocA bloc) => bloc.dispose(),
///   child: ChildA(),
/// );
/// ```
class RxBlocProvider<T> extends SingleChildStatelessWidget {
  /// Takes a [bloc] and a [child] which will have access to the [bloc]
  /// via `RxBlocProvider.of(context)`.
  /// When `RxBlocProvider.value` is used, the [bloc] will not be
  /// automatically disposed.
  /// As a result, `RxBlocProvider.value` should mainly be used for
  /// providing existing [bloc]s
  /// to new routes.
  ///
  /// A new [bloc] should not be created in `RxBlocProvider.value`.
  /// [bloc]s should always be created using the default constructor
  /// within [create].
  ///
  /// ```dart
  /// RxBlocProvider.value(
  ///   value: RxBlocProvider.of<BlocA>(context),
  ///   child: ScreenA(),
  /// );
  RxBlocProvider.value({
    required T value,
    required Dispose<T> dispose,
    Key? key,
    Widget? child,
  }) : this._(
          key: key,
          create: (_) => value,
          dispose: dispose,
          child: child,
        );

  /// Internal constructor responsible for creating the [RxBlocProvider].
  /// Used by the [RxBlocProvider] default and value constructors.
  RxBlocProvider._({
    required Create<T> create,
    required Dispose<T> dispose,
    Key? key,
    this.child,
    this.lazy,
  })  : _create = create,
        _dispose = dispose,
        super(key: key, child: child);

  /// {@macro blocprovider}
  RxBlocProvider({
    required Create<T> create,
    required Dispose<T> dispose,
    Key? key,
    Widget? child,
    bool? lazy,
  }) : this._(
          key: key,
          create: create,
          dispose: dispose,
          child: child,
          lazy: lazy,
        );

  /// [child] and its descendants which will have access to the [bloc].
  final Widget? child;

  /// Whether or not the [bloc] being provided should be lazily created.
  /// Defaults to `true`.
  final bool? lazy;

  final Dispose<T> _dispose;

  final Create<T> _create;

  /// Method that allows widgets to access a [bloc] instance as
  /// long as their `BuildContext`
  /// contains a [RxBlocProvider] instance.
  ///
  /// If we want to access an instance of `BlocA` which was
  /// provided higher up in the widget tree
  /// we can do so via:
  ///
  /// ```dart
  /// RxBlocProvider.of<BlocA>(context)
  /// ```
  static T of<T>(BuildContext context) {
    try {
      return Provider.of<T>(context, listen: false);
    } on ProviderNotFoundException catch (_) {
      throw FlutterError(
        """
        RxBlocProvider.of() called with a context that does not contain a Bloc of type $T.
        No ancestor could be found starting from the context that was passed to RxBlocProvider.of<$T>().

        This can happen if:
        1. The context you used comes from a widget above the RxBlocProvider.
        2. You used MultiRxBlocProvider and didn\'t explicity provide the RxBlocProvider types.

        Good: RxBlocProvider<$T>(create: (context) => $T())
        Bad: RxBlocProvider(create: (context) => $T()).

        The context used was: $context
        """,
      );
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return InheritedProvider<T>(
      create: _create,
      dispose: _dispose,
      child: child,
      lazy: lazy,
    );
  }
}
