// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@experimental
library build_runner.src.generate.performance_tracker;

import 'dart:async';

import 'package:build/build.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:timing/timing.dart';

import 'phase.dart';

part 'performance_tracker.g.dart';

/// The [TimeSlice] of an entire build, including all its [actions].
@JsonSerializable()
class BuildPerformance extends TimeSlice {
  /// The [TimeSlice] of each phase ran in this build.
  final Iterable<BuildPhasePerformance> phases;

  /// The [TimeSlice] of running an individual [Builder] on an individual input.
  final Iterable<BuilderActionPerformance> actions;

  BuildPerformance(
      this.phases, this.actions, DateTime startTime, DateTime stopTime)
      : super(startTime, stopTime);

  factory BuildPerformance.fromJson(Map<String, dynamic> json) =>
      _$BuildPerformanceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BuildPerformanceToJson(this);
}

/// The [TimeSlice] of a full [BuildPhase] within a larger build.
@JsonSerializable()
class BuildPhasePerformance extends TimeSlice {
  final List<String> builderKeys;

  BuildPhasePerformance(this.builderKeys, DateTime startTime, DateTime stopTime)
      : super(startTime, stopTime);

  factory BuildPhasePerformance.fromJson(Map<String, dynamic> json) =>
      _$BuildPhasePerformanceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BuildPhasePerformanceToJson(this);
}

/// The [TimeSlice] of a [builderKey] running on [primaryInput] within a build.
@JsonSerializable()
class BuilderActionPerformance extends TimeSlice {
  final String builderKey;

  @JsonKey(fromJson: _assetIdFromJson, toJson: _assetIdToJson)
  final AssetId primaryInput;

  final Iterable<BuilderActionStagePerformance> stages;

  Duration get innerDuration => stages.fold(
      Duration.zero, (duration, stage) => duration + stage.innerDuration);

  BuilderActionPerformance(this.builderKey, this.primaryInput, this.stages,
      DateTime startTime, DateTime stopTime)
      : super(startTime, stopTime);

  factory BuilderActionPerformance.fromJson(Map<String, dynamic> json) =>
      _$BuilderActionPerformanceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BuilderActionPerformanceToJson(this);
}

/// The [TimeSlice] of a particular task within a builder action.
///
/// This is some slice of overall [BuilderActionPerformance].
@JsonSerializable()
class BuilderActionStagePerformance extends TimeSliceGroup {
  final String label;

  BuilderActionStagePerformance(this.label, List<TimeSlice> slices)
      : super(slices);

  factory BuilderActionStagePerformance.fromJson(Map<String, dynamic> json) =>
      _$BuilderActionStagePerformanceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BuilderActionStagePerformanceToJson(this);
}

/// Interface for tracking the overall performance of a build.
abstract class BuildPerformanceTracker
    implements TimeTracker, BuildPerformance {
  /// Tracks [runPhase] which performs [action] on all inputs in a phase, and
  /// return the outputs generated.
  Future<Iterable<AssetId>> trackBuildPhase(
      BuildPhase action, Future<Iterable<AssetId>> runPhase());

  /// Returns a [BuilderActionTracker] for tracking [builderKey] on
  /// [primaryInput] and adds it to [actions].
  BuilderActionTracker addBuilderAction(
      AssetId primaryInput, String builderKey);

  factory BuildPerformanceTracker() => _BuildPerformanceTrackerImpl();

  /// A [BuildPerformanceTracker] with as little overhead as possible. Does no
  /// actual tracking and does not implement many fields/methods.
  factory BuildPerformanceTracker.noOp() =>
      _NoOpBuildPerformanceTracker.sharedInstance;
}

/// Real implementation of [BuildPerformanceTracker].
///
/// Use [BuildPerformanceTracker] factory to get an instance.
class _BuildPerformanceTrackerImpl extends SimpleAsyncTimeTracker
    implements BuildPerformanceTracker {
  @override
  Iterable<BuildPhaseTracker> get phases => _phases;
  final _phases = <BuildPhaseTracker>[];

  @override
  Iterable<BuilderActionTracker> get actions => _actions;
  final _actions = <BuilderActionTracker>[];

  /// Tracks [action] which is ran with [runPhase].
  ///
  /// This represents running a [Builder] on a group of sources.
  ///
  /// Returns all the outputs generated by the phase.
  @override
  Future<Iterable<AssetId>> trackBuildPhase(
      BuildPhase action, Future<Iterable<AssetId>> runPhase()) {
    assert(isTracking);
    var tracker = BuildPhaseTracker(action);
    _phases.add(tracker);
    return tracker.track(runPhase);
  }

  /// Returns a new [BuilderActionTracker] and adds it to [actions].
  ///
  /// The [BuilderActionTracker] will already be started, but you must stop it.
  @override
  BuilderActionTracker addBuilderAction(
      AssetId primaryInput, String builderKey) {
    assert(isTracking);
    var tracker = BuilderActionTracker(primaryInput, builderKey);
    _actions.add(tracker);
    return tracker;
  }

  @override
  Map<String, dynamic> toJson() => _$BuildPerformanceToJson(this);
}

/// No-op implementation of [BuildPerformanceTracker].
///
/// Read-only fields will throw, and tracking methods just directly invoke their
/// closures without tracking anything.
///
/// Use [BuildPerformanceTracker.noOp] to get an instance.
class _NoOpBuildPerformanceTracker extends NoOpTimeTracker
    implements BuildPerformanceTracker {
  static final _NoOpBuildPerformanceTracker sharedInstance =
      _NoOpBuildPerformanceTracker();

  @override
  Iterable<BuilderActionTracker> get actions => throw UnimplementedError();

  @override
  Iterable<BuildPhaseTracker> get phases => throw UnimplementedError();

  @override
  BuilderActionTracker addBuilderAction(
          AssetId primaryInput, String builderKey) =>
      BuilderActionTracker.noOp();

  @override
  Future<Iterable<AssetId>> trackBuildPhase(
          BuildPhase action, Future<Iterable<AssetId>> runPhase()) =>
      runPhase();

  @override
  Map<String, dynamic> toJson() => _$BuildPerformanceToJson(this);
}

/// Internal class that tracks the [TimeSlice] of an entire [BuildPhase].
///
/// Tracks total time it took to run on all inputs available to that action.
///
/// Use [track] to start actually tracking an operation.
///
/// This is only meaningful for non-lazy phases.
class BuildPhaseTracker extends SimpleAsyncTimeTracker
    implements BuildPhasePerformance {
  @override
  List<String> get builderKeys => _builderKeys;
  final List<String> _builderKeys;

  BuildPhaseTracker(BuildPhase action)
      : _builderKeys = action is InBuildPhase
            ? [action.builderLabel]
            : (action as PostBuildPhase)
                .builderActions
                .map((action) => action.builderLabel)
                .toList();

  @override
  Map<String, dynamic> toJson() => _$BuildPhasePerformanceToJson(this);
}

/// Interface for tracking the [TimeSlice] of an individual [Builder] on a given
/// primary input.
abstract class BuilderActionTracker
    implements TimeTracker, BuilderActionPerformance, StageTracker {
  /// Tracks the time of [runStage] and associates it with [label].
  ///
  /// You can specify [runStage] as [isExternal] (waiting for some external
  /// resource like network, process or file IO). In that case [runStage] will
  /// be tracked as single time slice from the beginning of the stage till
  /// completion of Future returned by [runStage].
  ///
  /// Otherwise all separate time slices of asynchronous execution will be
  /// tracked, but waiting for external resources will be a gap.
  @override
  T trackStage<T>(String label, T runStage(), {bool isExternal = false});

  factory BuilderActionTracker(AssetId primaryInput, String builderKey) =>
      _BuilderActionTrackerImpl(primaryInput, builderKey);

  /// A [BuilderActionTracker] with as little overhead as possible. Does no
  /// actual tracking and does not implement many fields/methods.
  factory BuilderActionTracker.noOp() =>
      _NoOpBuilderActionTracker._sharedInstance;
}

/// Real implementation of [BuilderActionTracker] which records timings.
///
/// Use the [BuilderActionTracker] factory to get an instance.
class _BuilderActionTrackerImpl extends SimpleAsyncTimeTracker
    implements BuilderActionTracker {
  @override
  final String builderKey;
  @override
  final AssetId primaryInput;

  @override
  final List<BuilderActionStageTracker> stages = [];

  @override
  Duration get innerDuration => stages.fold(
      Duration.zero, (duration, stage) => duration + stage.innerDuration);

  _BuilderActionTrackerImpl(this.primaryInput, this.builderKey);

  @override
  T trackStage<T>(String label, T action(), {bool isExternal = false}) {
    var tracker = isExternal
        ? BuilderActionStageSimpleTracker(label)
        : BuilderActionStageAsyncTracker(label);
    stages.add(tracker);
    return tracker.track(action);
  }

  @override
  Map<String, dynamic> toJson() => _$BuilderActionPerformanceToJson(this);
}

/// No-op instance of [BuilderActionTracker] which does nothing and throws an
/// unimplemented error for everything but [trackStage], which delegates directly to
/// the wrapped function.
///
/// Use the [BuilderActionTracker.noOp] factory to get an instance.
class _NoOpBuilderActionTracker extends NoOpTimeTracker
    implements BuilderActionTracker {
  static final _NoOpBuilderActionTracker _sharedInstance =
      _NoOpBuilderActionTracker();

  @override
  String get builderKey => throw UnimplementedError();

  @override
  Duration get duration => throw UnimplementedError();

  @override
  Iterable<BuilderActionStagePerformance> get stages =>
      throw UnimplementedError();

  @override
  Duration get innerDuration => throw UnimplementedError();

  @override
  AssetId get primaryInput => throw UnimplementedError();

  @override
  T trackStage<T>(String label, T runStage(), {bool isExternal = false}) =>
      runStage();

  @override
  Map<String, dynamic> toJson() => _$BuilderActionPerformanceToJson(this);
}

/// Tracks the [TimeSliceGroup] of an individual task.
///
/// These represent a slice of the [BuilderActionPerformance].
abstract class BuilderActionStageTracker
    implements BuilderActionStagePerformance {
  T track<T>(T Function() action);
}

class BuilderActionStageAsyncTracker extends AsyncTimeTracker
    implements BuilderActionStageTracker {
  @override
  final String label;

  BuilderActionStageAsyncTracker(this.label) : super(trackNested: false);

  @override
  Map<String, dynamic> toJson() => _$BuilderActionStagePerformanceToJson(this);
}

class BuilderActionStageSimpleTracker extends BuilderActionStagePerformance
    implements BuilderActionStageTracker {
  final _tracker = SimpleAsyncTimeTracker();

  BuilderActionStageSimpleTracker(String label) : super(label, []) {
    slices.add(_tracker);
  }

  @override
  T track<T>(T Function() action) => _tracker.track(action);
}

AssetId _assetIdFromJson(String json) => AssetId.parse(json);

String _assetIdToJson(AssetId id) => id.toString();