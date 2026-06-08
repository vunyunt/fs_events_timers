import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

/// A defined interface that represents a flame timer.
///
/// This is written because the flame timer has some members that are not
/// necessarily common to all timer implementations (for example, limit)
abstract interface class TimerInterface {
  double get current;
  bool get finished;
  bool isRunning();
  double get progress;

  void start();
  void stop();
  void reset();
  void pause();
  void resume();
  void update(double dt);
}

/// A mixin that provides an implementation of the [TimerInterface] using a flame
/// [Timer].
mixin InternalFlameTimer implements TimerInterface {
  @protected
  Timer get internalTimer;

  @override
  double get current => internalTimer.current;

  @override
  bool get finished => internalTimer.finished;

  @override
  bool isRunning() => internalTimer.isRunning();

  @override
  double get progress => internalTimer.progress;

  @override
  void start() => internalTimer.start();

  @override
  void stop() => internalTimer.stop();

  @override
  void reset() => internalTimer.reset();

  @override
  void pause() => internalTimer.pause();

  @override
  void resume() => internalTimer.resume();

  @override
  void update(double dt) => internalTimer.update(dt);
}

/// A simple component that mounts a flame timer to the game.
/// This is used to mount custom timers, which isn't available with flame's
/// built in [TimerComponent]
class CustomTimerComponent extends Component {
  final TimerInterface timer;
  final bool removeOnFinish;

  CustomTimerComponent({required this.timer, this.removeOnFinish = true});

  @override
  void update(double dt) {
    timer.update(dt);

    if (removeOnFinish && timer.finished) {
      removeFromParent();
    }
  }
}
