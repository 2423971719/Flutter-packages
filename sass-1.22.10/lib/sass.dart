// Copyright 2016 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// We strongly recommend importing this library with the prefix `sass`.
library sass;

import 'dart:async';

import 'package:source_maps/source_maps.dart';

import 'src/async_import_cache.dart';
import 'src/callable.dart';
import 'src/compile.dart' as c;
import 'src/exception.dart';
import 'src/import_cache.dart';
import 'src/importer.dart';
import 'src/logger.dart';
import 'src/sync_package_resolver.dart';
import 'src/syntax.dart';
import 'src/visitor/serialize.dart';

export 'src/callable.dart' show Callable, AsyncCallable;
export 'src/exception.dart' show SassException;
export 'src/importer.dart';
export 'src/logger.dart';
export 'src/syntax.dart';
export 'src/value.dart' show ListSeparator;
export 'src/value/external/value.dart';
export 'src/visitor/serialize.dart' show OutputStyle;
export 'src/warn.dart' show warn;

/// Loads the Sass file at [path], compiles it to CSS, and returns the result.
///
/// If [color] is `true`, this will use terminal colors in warnings. It's
/// ignored if [logger] is passed.
///
/// If [logger] is passed, it's used to emit all messages that are generated by
/// Sass code. Users may pass custom subclasses of [Logger].
///
/// Imports are resolved by trying, in order:
///
/// * Loading a file relative to [path].
///
/// * Each importer in [importers].
///
/// * Each load path in [loadPaths]. Note that this is a shorthand for adding
///   [FilesystemImporter]s to [importers].
///
/// * Each load path specified in the `SASS_PATH` environment variable, which
///   should be semicolon-separated on Windows and colon-separated elsewhere.
///
/// * `package:` resolution using [packageResolver], which is a
///   [`SyncPackageResolver`][] from the `package_resolver` package. Note that
///   this is a shorthand for adding a [PackageImporter] to [importers].
///
/// [`SyncPackageResolver`]: https://www.dartdocs.org/documentation/package_resolver/latest/package_resolver/SyncPackageResolver-class.html
///
/// Dart functions that can be called from Sass may be passed using [functions].
/// Each [Callable] defines a top-level function that will be invoked when the
/// given name is called from Sass.
///
/// The [style] parameter controls the style of the resulting CSS.
///
/// If [sourceMap] is passed, it's passed a [SingleMapping] that indicates which
/// sections of the source file(s) correspond to which in the resulting CSS.
/// It's called immediately before this method returns, and only if compilation
/// succeeds. Note that [SingleMapping.targetUrl] will always be `null`. Users
/// using the [SourceMap] API should be sure to add the [`source_maps`][]
/// package to their pubspec.
///
/// [`source_maps`]: https://pub.dartlang.org/packages/source_maps
///
/// If [charset] is `true`, this will include a `@charset` declaration or a
/// UTF-8 [byte-order mark][] if the stylesheet contains any non-ASCII
/// characters. Otherwise, it will never include a `@charset` declaration or a
/// byte-order mark.
///
/// [byte-order mark]: https://en.wikipedia.org/wiki/Byte_order_mark#UTF-8
///
/// This parameter is meant to be used as an out parameter, so that users who
/// want access to the source map can get it. For example:
///
/// ```dart
/// SingleMapping sourceMap;
/// var css = compile(sassPath, sourceMap: (map) => sourceMap = map);
/// ```
///
/// Throws a [SassException] if conversion fails.
String compile(String path,
    {bool color = false,
    Logger logger,
    Iterable<Importer> importers,
    Iterable<String> loadPaths,
    SyncPackageResolver packageResolver,
    Iterable<Callable> functions,
    OutputStyle style,
    void sourceMap(SingleMapping map),
    bool charset = true}) {
  logger ??= Logger.stderr(color: color);
  var result = c.compile(path,
      logger: logger,
      importCache: ImportCache(importers,
          logger: logger,
          loadPaths: loadPaths,
          packageResolver: packageResolver),
      functions: functions,
      style: style,
      sourceMap: sourceMap != null,
      charset: charset);
  if (sourceMap != null) sourceMap(result.sourceMap);
  return result.css;
}

/// Compiles [source] to CSS and returns the result.
///
/// This parses the stylesheet as [syntax], which defaults to [Syntax.scss].
///
/// If [color] is `true`, this will use terminal colors in warnings. It's
/// ignored if [logger] is passed.
///
/// If [logger] is passed, it's used to emit all messages that are generated by
/// Sass code. Users may pass custom subclasses of [Logger].
///
/// Imports are resolved by trying, in order:
///
/// * The given [importer], with the imported URL resolved relative to [url].
///
/// * Each importer in [importers].
///
/// * Each load path in [loadPaths]. Note that this is a shorthand for adding
///   [FilesystemImporter]s to [importers].
///
/// * Each load path specified in the `SASS_PATH` environment variable, which
///   should be semicolon-separated on Windows and colon-separated elsewhere.
///
/// * `package:` resolution using [packageResolver], which is a
///   [`SyncPackageResolver`][] from the `package_resolver` package. Note that
///   this is a shorthand for adding a [PackageImporter] to [importers].
///
/// [`SyncPackageResolver`]: https://www.dartdocs.org/documentation/package_resolver/latest/package_resolver/SyncPackageResolver-class.html
///
/// Dart functions that can be called from Sass may be passed using [functions].
/// Each [Callable] defines a top-level function that will be invoked when the
/// given name is called from Sass.
///
/// The [style] parameter controls the style of the resulting CSS.
///
/// The [url] indicates the location from which [source] was loaded. It may be a
/// [String] or a [Uri]. If [importer] is passed, [url] must be passed as well
/// and `importer.load(url)` should return `source`.
///
/// If [sourceMap] is passed, it's passed a [SingleMapping] that indicates which
/// sections of the source file(s) correspond to which in the resulting CSS.
/// It's called immediately before this method returns, and only if compilation
/// succeeds. Note that [SingleMapping.targetUrl] will always be `null`. Users
/// using the [SourceMap] API should be sure to add the [`source_maps`][]
/// package to their pubspec.
///
/// [`source_maps`]: https://pub.dartlang.org/packages/source_maps
///
/// If [charset] is `true`, this will include a `@charset` declaration or a
/// UTF-8 [byte-order mark][] if the stylesheet contains any non-ASCII
/// characters. Otherwise, it will never include a `@charset` declaration or a
/// byte-order mark.
///
/// [byte-order mark]: https://en.wikipedia.org/wiki/Byte_order_mark#UTF-8
///
/// This parameter is meant to be used as an out parameter, so that users who
/// want access to the source map can get it. For example:
///
/// ```dart
/// SingleMapping sourceMap;
/// var css = compile(sassPath, sourceMap: (map) => sourceMap = map);
/// ```
///
/// Throws a [SassException] if conversion fails.
String compileString(String source,
    {Syntax syntax,
    bool color = false,
    Logger logger,
    Iterable<Importer> importers,
    SyncPackageResolver packageResolver,
    Iterable<String> loadPaths,
    Iterable<Callable> functions,
    OutputStyle style,
    Importer importer,
    url,
    void sourceMap(SingleMapping map),
    bool charset = true,
    @Deprecated("Use syntax instead.") bool indented = false}) {
  logger ??= Logger.stderr(color: color);
  var result = c.compileString(source,
      syntax: syntax ?? (indented ? Syntax.sass : Syntax.scss),
      logger: logger,
      importCache: ImportCache(importers,
          logger: logger,
          packageResolver: packageResolver,
          loadPaths: loadPaths),
      functions: functions,
      style: style,
      importer: importer,
      url: url,
      sourceMap: sourceMap != null,
      charset: charset);
  if (sourceMap != null) sourceMap(result.sourceMap);
  return result.css;
}

/// Like [compile], except it runs asynchronously.
///
/// Running asynchronously allows this to take [AsyncImporter]s rather than
/// synchronous [Importer]s. However, running asynchronously is also somewhat
/// slower, so [compile] should be preferred if possible.
Future<String> compileAsync(String path,
    {bool color = false,
    Logger logger,
    Iterable<AsyncImporter> importers,
    SyncPackageResolver packageResolver,
    Iterable<String> loadPaths,
    Iterable<AsyncCallable> functions,
    OutputStyle style,
    void sourceMap(SingleMapping map)}) async {
  logger ??= Logger.stderr(color: color);
  var result = await c.compileAsync(path,
      logger: logger,
      importCache: AsyncImportCache(importers,
          logger: logger,
          loadPaths: loadPaths,
          packageResolver: packageResolver),
      functions: functions,
      style: style,
      sourceMap: sourceMap != null);
  if (sourceMap != null) sourceMap(result.sourceMap);
  return result.css;
}

/// Like [compileString], except it runs asynchronously.
///
/// Running asynchronously allows this to take [AsyncImporter]s rather than
/// synchronous [Importer]s. However, running asynchronously is also somewhat
/// slower, so [compileString] should be preferred if possible.
Future<String> compileStringAsync(String source,
    {Syntax syntax,
    bool color = false,
    Logger logger,
    Iterable<AsyncImporter> importers,
    SyncPackageResolver packageResolver,
    Iterable<String> loadPaths,
    Iterable<AsyncCallable> functions,
    OutputStyle style,
    AsyncImporter importer,
    url,
    void sourceMap(SingleMapping map),
    bool charset = true,
    @Deprecated("Use syntax instead.") bool indented = false}) async {
  logger ??= Logger.stderr(color: color);
  var result = await c.compileStringAsync(source,
      syntax: syntax ?? (indented ? Syntax.sass : Syntax.scss),
      logger: logger,
      importCache: AsyncImportCache(importers,
          logger: logger,
          packageResolver: packageResolver,
          loadPaths: loadPaths),
      functions: functions,
      style: style,
      importer: importer,
      url: url,
      sourceMap: sourceMap != null,
      charset: charset);
  if (sourceMap != null) sourceMap(result.sourceMap);
  return result.css;
}