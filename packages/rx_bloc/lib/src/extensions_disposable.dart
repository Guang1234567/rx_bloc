part of 'bloc/rx_bloc_base.dart';

///
mixin Disposable {
  bool _isDisposed = false;

  ///
  bool get isDisposed => _isDisposed;

  ///
  void dispose() {
    _isDisposed = true;
  }
}

///
class CompositeDisposer with Disposable {
  final Set<Disposable> _disposableList = {};

  ///
  int get length => _disposableList.length;

  ///
  bool get isEmpty => _disposableList.isEmpty;

  ///
  bool get isNotEmpty => _disposableList.isNotEmpty;

  ///
  bool get allDisposed => _disposableList.isNotEmpty
      ? _disposableList.every((it) => it.isDisposed)
      : false;

  ///
  Disposable add(Disposable disposable) {
    if (isDisposed) {
      // ignore: lines_longer_than_80_chars
      throw Exception(
          'This composite was disposed, try to use new instance instead');
    }
    _disposableList.add(disposable);
    return disposable;
  }

  ///
  void remove(Disposable disposable) {
    if (!disposable.isDisposed) {
      disposable.dispose();
    }
    _disposableList.remove(disposable);
  }

  @override
  void dispose() {
    // ignore: avoid_function_literals_in_foreach_calls
    _disposableList.forEach((it) {
      if (!it.isDisposed) {
        it.dispose();
      }
    });

    // ignore: cascade_invocations
    _disposableList.clear();
    super.dispose();
  }
}

///
extension DisposableAddToCompositeDisposer on Disposable {
  ///
  void addTo(CompositeDisposer compositeDisposer) =>
      compositeDisposer.add(this);
}

///
extension DisposableDisposedByCompositeDisposer on Disposable {
  ///
  Disposable disposedBy(CompositeDisposer compositeDisposer) =>
      compositeDisposer.add(this);
}

class _CompositeSubscriptionDisposer with Disposable {
  _CompositeSubscriptionDisposer(this.compositeSubscription);

  final CompositeSubscription compositeSubscription;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _CompositeSubscriptionDisposer &&
          runtimeType == other.runtimeType &&
          compositeSubscription == other.compositeSubscription;

  @override
  int get hashCode => compositeSubscription.hashCode;

  @override
  bool get isDisposed => compositeSubscription.isDisposed;

  @override
  void dispose() {
    if (isDisposed) {
      return;
    }
    compositeSubscription.dispose();
    super.dispose();
  }
}

extension _ToCompositeSubscriptionDisposer on CompositeSubscription {
  _CompositeSubscriptionDisposer toCompositeSubscriptionDisposer() =>
      _CompositeSubscriptionDisposer(this);
}

///
extension ToCompositeDisposer on CompositeSubscription {
  ///
  CompositeDisposer toCompositeDisposer() =>
      CompositeDisposer()..add(toCompositeSubscriptionDisposer());
}

///
extension ToCompositeDisposerNullable on CompositeSubscription? {
  ///
  CompositeDisposer toCompositeDisposer() {
    var to = CompositeDisposer();
    if (this != null) {
      to.add(this!.toCompositeSubscriptionDisposer());
    }
    return to;
  }
}

class _SinkDisposer<T> with Disposable {
  _SinkDisposer(this.sink);

  final Sink<T> sink;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SinkDisposer &&
          runtimeType == other.runtimeType &&
          sink == other.sink;

  @override
  int get hashCode => sink.hashCode;

  @override
  void dispose() {
    if (isDisposed) {
      return;
    }
    sink.close();
    super.dispose();
  }
}

extension _ToSinkDisposer<T> on Sink<T> {
  _SinkDisposer toSinkDisposer() => _SinkDisposer<T>(this);
}

///
extension SinkAddToCompositeDisposer<T> on Sink<T> {
  ///
  void addTo(CompositeDisposer compositeDisposer) =>
      compositeDisposer.add(toSinkDisposer());
}

///
extension SinkDisposedByCompositeDisposer<T> on Sink<T> {
  ///
  Sink disposedBy(CompositeDisposer compositeDisposer) {
    compositeDisposer.add(toSinkDisposer());
    return this;
  }
}

class _StreamSubscriptionDisposer<T> with Disposable {
  _StreamSubscriptionDisposer(this.streamSubscription);

  final StreamSubscription<T> streamSubscription;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _StreamSubscriptionDisposer &&
          runtimeType == other.runtimeType &&
          streamSubscription == other.streamSubscription;

  @override
  int get hashCode => streamSubscription.hashCode;

  @override
  void dispose() {
    if (isDisposed) {
      return;
    }
    streamSubscription.cancel();
    super.dispose();
  }
}

extension _ToStreamSubscriptionDisposer<T> on StreamSubscription<T> {
  _StreamSubscriptionDisposer toStreamSubscriptionDisposer() =>
      _StreamSubscriptionDisposer<T>(this);
}

///
extension StreamSubscriptionAddToCompositeDisposer<T> on StreamSubscription<T> {
  ///
  void addTo(CompositeDisposer compositeDisposer) =>
      compositeDisposer.add(toStreamSubscriptionDisposer());
}

///
extension StreamSubscriptionDisposedByCompositeDisposer<T>
    on StreamSubscription<T> {
  ///
  StreamSubscription<T> disposedBy(CompositeDisposer compositeDisposer) {
    compositeDisposer.add(toStreamSubscriptionDisposer());
    return this;
  }
}

///
class RxValue<T> with Disposable {
  ///
  RxValue(T initValue) : _sink = BehaviorSubject.seeded(initValue);

  final BehaviorSubject<T> _sink;

  ///
  T get value => _sink.value!;

  ///
  set value(T v) => _sink.add(v);

  ///
  get valueStream => _sink;

  @override
  void dispose() {
    _sink.close();
    super.dispose();
  }
}
