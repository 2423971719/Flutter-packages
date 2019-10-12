// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../driver_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AssertWithNnbdTest);
    defineReflectiveTests(DoWithNnbdTest);
    defineReflectiveTests(ForWithNnbdTest);
    defineReflectiveTests(IfWithNnbdTest);
    defineReflectiveTests(WhileWithNnbdTest);
  });
}

@reflectiveTest
class AssertWithNnbdTest extends DriverResolutionTest {
  @override
  AnalysisOptionsImpl get analysisOptions => AnalysisOptionsImpl()
    ..contextFeatures = new FeatureSet.forTesting(
        sdkVersion: '2.3.0', additionalFeatures: [Feature.non_nullable]);

  @override
  bool get typeToStringWithNullability => true;

  @failingTest
  test_downward() async {
    addTestFile('''
void f() {
  assert(a());
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(findNode.methodInvocation('a('), 'bool Function()');
  }
}

@reflectiveTest
class DoWithNnbdTest extends DriverResolutionTest {
  @override
  AnalysisOptionsImpl get analysisOptions => AnalysisOptionsImpl()
    ..contextFeatures = new FeatureSet.forTesting(
        sdkVersion: '2.3.0', additionalFeatures: [Feature.non_nullable]);

  @override
  bool get typeToStringWithNullability => true;

  @failingTest
  test_downward() async {
    addTestFile('''
void f() {
  do {} while(a())
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(findNode.methodInvocation('a('), 'bool Function()');
  }
}

@reflectiveTest
class ForWithNnbdTest extends DriverResolutionTest {
  @override
  AnalysisOptionsImpl get analysisOptions => AnalysisOptionsImpl()
    ..contextFeatures = new FeatureSet.forTesting(
        sdkVersion: '2.3.0', additionalFeatures: [Feature.non_nullable]);

  @override
  bool get typeToStringWithNullability => true;

  @failingTest
  test_awaitForIn_dynamic_downward() async {
    addTestFile('''
void f() async {
  await for (var e in a()) {}
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(
        findNode.methodInvocation('a('), 'Stream<dynamic> Function()');
  }

  @failingTest
  test_awaitForIn_int_downward() async {
    addTestFile('''
void f() async {
  await for (int e in a()) {}
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(findNode.methodInvocation('a('), 'Stream<int> Function()');
  }

  @failingTest
  test_for_downward() async {
    addTestFile('''
void f() {
  for (int i = 0; a(); i++) {}
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(findNode.methodInvocation('a('), 'bool Function()');
  }

  @failingTest
  test_forIn_dynamic_downward() async {
    addTestFile('''
void f() {
  for (var e in a()) {}
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(
        findNode.methodInvocation('a('), 'Iterable<dynamic> Function()');
  }

  @failingTest
  test_forIn_int_downward() async {
    addTestFile('''
void f() {
  for (int e in a()) {}
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(
        findNode.methodInvocation('a('), 'Iterable<int> Function()');
  }
}

@reflectiveTest
class IfWithNnbdTest extends DriverResolutionTest {
  @override
  AnalysisOptionsImpl get analysisOptions => AnalysisOptionsImpl()
    ..contextFeatures = new FeatureSet.forTesting(
        sdkVersion: '2.3.0', additionalFeatures: [Feature.non_nullable]);

  @override
  bool get typeToStringWithNullability => true;

  @failingTest
  test_downward() async {
    addTestFile('''
void f() {
  if (a()) {}
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(findNode.methodInvocation('a('), 'bool Function()');
  }
}

@reflectiveTest
class WhileWithNnbdTest extends DriverResolutionTest {
  @override
  AnalysisOptionsImpl get analysisOptions => AnalysisOptionsImpl()
    ..contextFeatures = new FeatureSet.forTesting(
        sdkVersion: '2.3.0', additionalFeatures: [Feature.non_nullable]);

  @override
  bool get typeToStringWithNullability => true;

  @failingTest
  test_downward() async {
    addTestFile('''
void f() {
  while (a()) {}
}
T a<T>() => throw '';
''');
    await resolveTestFile();
    assertInvokeType(findNode.methodInvocation('a('), 'bool Function()');
  }
}
