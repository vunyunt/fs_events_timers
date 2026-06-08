import 'dart:async';

class Event<T> {
  final StreamController<T> _controller = StreamController.broadcast();

  late final stream = _controller.stream;

  void emit(T value) {
    _controller.add(value);
  }

  void close() {
    _controller.close();
  }
}
