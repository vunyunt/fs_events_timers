import 'package:flame/timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:fs_random/fs_random.dart';
import 'package:protobuf_serializable_components/protobuf_serializable_components.dart';
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart';
import 'timer_interface.dart';

class DynamicIntervalTimer with InternalFlameTimer {
  VoidCallback? onTick;
  bool repeat;
  final double Function() intervalGenerator;
  final int? tickCount;

  late final Timer _internalTimer;

  @override
  Timer get internalTimer => _internalTimer;

  DynamicIntervalTimer({
    required this.intervalGenerator,
    this.onTick,
    this.repeat = true,
    bool autoStart = true,
    this.tickCount,
  }) {
    _internalTimer = Timer(
      intervalGenerator(),
      onTick: () {
        _internalTimer.limit = intervalGenerator();
        onTick?.call();
      },
      repeat: repeat,
      autoStart: autoStart,
      tickCount: tickCount,
    );
  }

  static Future<DynamicIntervalTimer> random({
    required FrogsoupRandom random,
    required SerializableComponentRegistry registry,
    required Any intervalRandomVariable,
    VoidCallback? onTick,
    bool repeat = true,
    bool autoStart = true,
    int? tickCount,
  }) async {
    final realizer = await RandomVariableRealizer.fromAny(
      random: random,
      data: intervalRandomVariable,
      registry: registry,
    );

    return DynamicIntervalTimer(
      intervalGenerator: () => realizer.realize(),
      onTick: onTick,
      repeat: repeat,
      autoStart: autoStart,
      tickCount: tickCount,
    );
  }
}
