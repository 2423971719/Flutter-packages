// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:json_annotation/json_annotation.dart';

/// Context information provided in calls to [TypeHelper.serialize] and
/// [TypeHelper.deserialize].
abstract class TypeHelperContext {
  /// The annotated class that code is being generated for.
  ClassElement get classElement;

  /// The field that code is being generated for.
  FieldElement get fieldElement;

  /// Returns `true` if [fieldElement] could potentially contain a `null` value.
  bool get nullable;

  /// [expression] may be just the name of the field or it may an expression
  /// representing the serialization of a value.
  Object serialize(DartType fieldType, String expression);

  /// [expression] may be just the name of the field or it may an expression
  /// representing the serialization of a value.
  Object deserialize(DartType fieldType, String expression);

  /// Adds [memberContent] to the set of generated, top-level members.
  void addMember(String memberContent);
}

abstract class TypeHelperContextWithEmptyCollectionLogic
    extends TypeHelperContext {
  /// Returns `true` if `this` is being used in the first (or "root") invocation
  /// of a [TypeHelper.serialize] or [TypeHelper.deserialize] call.
  bool get skipEncodingEmptyCollection;

  static bool isSkipEncodingEmptyCollection(TypeHelperContext context) =>
      context is TypeHelperContextWithEmptyCollectionLogic &&
      context.skipEncodingEmptyCollection;
}

/// Extended context information with includes configuration values
/// corresponding to `JsonSerializableGenerator` settings.
abstract class TypeHelperContextWithConfig extends TypeHelperContext {
  JsonSerializable get config;
}

abstract class TypeHelper<T extends TypeHelperContext> {
  const TypeHelper();

  /// Returns Dart code that serializes an [expression] representing a Dart
  /// object of type [targetType].
  ///
  /// If [targetType] is not supported, returns `null`.
  ///
  /// Let's say you want to serialize a class `Foo` as just its `id` property
  /// of type `int`.
  ///
  /// Treating [expression] as a opaque Dart expression, the [serialize]
  /// implementation could be a simple as:
  ///
  /// ```dart
  /// String serialize(DartType targetType, String expression) =>
  ///   "$expression.id";
  /// ```.
  Object serialize(DartType targetType, String expression, T context);

  /// Returns Dart code that deserializes an [expression] representing a JSON
  /// literal to into [targetType].
  ///
  /// If [targetType] is not supported, returns `null`.
  ///
  /// Let's say you want to deserialize a class `Foo` by taking an `int` stored
  /// in a JSON literal and calling the `Foo.fromInt` constructor.
  ///
  /// Treating [expression] as a opaque Dart expression representing a JSON
  /// literal, the [deserialize] implementation could be a simple as:
  ///
  /// ```dart
  /// String deserialize(DartType targetType, String expression) =>
  ///   "new Foo.fromInt($expression)";
  /// ```.
  ///
  /// Note that [targetType] is not used here. If you wanted to support many
  /// types of [targetType] you could write:
  ///
  /// ```dart
  /// String deserialize(DartType targetType, String expression) =>
  ///   "new ${targetType.name}.fromInt($expression)";
  /// ```.
  Object deserialize(DartType targetType, String expression, T context);
}

class LambdaResult {
  final String expression;
  final String lambda;

  LambdaResult(this.expression, this.lambda);

  @override
  String toString() => '$lambda($expression)';

  static String process(Object subField, String closureArg) =>
      (subField is LambdaResult && closureArg == subField.expression)
          ? subField.lambda
          : '($closureArg) => $subField';
}

class UnsupportedTypeError extends Error {
  final String expression;
  final DartType type;
  final String reason;

  UnsupportedTypeError(this.type, this.expression, this.reason);
}

Object commonNullPrefix(
        bool nullable, String expression, Object unsafeExpression) =>
    nullable
        ? '$expression == null ? null : $unsafeExpression'
        : unsafeExpression;

/// Returns `true` if [context] represents a field where
/// `encodeEmptyCollection` is `false` and the caller is running on the
/// "root" value and not for a nested type.
///
/// This ensures we don't add wrapper functions for the nested lists within
/// `Map<String, List<String>`, for instance.
bool encodeEmptyAsNullRoot(TypeHelperContext context) =>
    TypeHelperContextWithEmptyCollectionLogic.isSkipEncodingEmptyCollection(
        context);