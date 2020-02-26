import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:test/test.dart' as tester;

@isTest
Future<void> rxBlocTest<B extends RxBlocBase, StateOutputType>(
  String message, {
  @required Future<B> Function() build,
  @required Stream<StateOutputType> Function(B) state,
  Future<void> Function(B) act,
  Iterable expect,
  int skip = 0,
}) {
  tester.test(message, () async {
    final bloc = await build();
    final checkingState = state(bloc);
    final states = <StateOutputType>[];
    final subscription = checkingState.skip(skip).listen(states.add);
    await act?.call(bloc);
    if (expect != null) tester.expect(states, expect);
    subscription.cancel();
  });
}
