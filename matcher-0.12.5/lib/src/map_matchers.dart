// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'interfaces.dart';
import 'util.dart';

/// Returns a matcher which matches maps containing the given [value].
Matcher containsValue(value) => _ContainsValue(value);

class _ContainsValue extends Matcher {
  final Object _value;

  const _ContainsValue(this._value);

  @override
  bool matches(item, Map matchState) => item.containsValue(_value);
  @override
  Description describe(Description description) =>
      description.add('contains value ').addDescriptionOf(_value);
}

/// Returns a matcher which matches maps containing the key-value pair
/// with [key] => [value].
Matcher containsPair(key, value) => _ContainsMapping(key, wrapMatcher(value));

class _ContainsMapping extends Matcher {
  final Object _key;
  final Matcher _valueMatcher;

  const _ContainsMapping(this._key, this._valueMatcher);

  @override
  bool matches(item, Map matchState) =>
      item.containsKey(_key) && _valueMatcher.matches(item[_key], matchState);

  @override
  Description describe(Description description) {
    return description
        .add('contains pair ')
        .addDescriptionOf(_key)
        .add(' => ')
        .addDescriptionOf(_valueMatcher);
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (!item.containsKey(_key)) {
      return mismatchDescription
          .add(" doesn't contain key ")
          .addDescriptionOf(_key);
    } else {
      mismatchDescription
          .add(' contains key ')
          .addDescriptionOf(_key)
          .add(' but with value ');
      _valueMatcher.describeMismatch(
          item[_key], mismatchDescription, matchState, verbose);
      return mismatchDescription;
    }
  }
}
