library tested;

import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:test/test.dart';

typedef TestCase = FutureOr<void> Function();

/// Thrown by [expectTestCase], when it expected an error, but didn't get one.
class NotThrownError extends Error {}

/// Returns a [TestCase] that tries to run [tfunc].
///
/// If [tfunc] throws and [error] is `false`, it `rethrow`s.
/// If [tfunc] doesn't throw and [error] is `true`, it throws a `NotThrownError`.
/// If [tfunc] throws, [error] is `true` and [expct] is not `null`, it checks
/// whether the thrown error is equal to [expct].
///
/// If [expct] is an instance of [error] or [Exception] and [error] is `null`,
/// a warning is printed to `stderr`.
///
/// If the throwing behavior is as expected, it checks whether the returned
/// value is equal to [expct].
TestCase expectTestCase<T>(
  FutureOr<T> Function() tfunc,
  T expct, [
  bool? error,
]) =>
    () async {
      if (error == null && (expct is Error || expct is Exception)) {
        stderr.writeln(
            '[WARN] You\'re passing an \'$expct\' to `expectTestCase`, '
            'but don\'t say you\'re trying to get an error.');
        stderr.writeln(
            'If this is intended, please tag a `false` onto the end of the call.');
      }
      T res;
      try {
        res = await tfunc();
      } catch (e) {
        if (!(error ?? false)) {
          rethrow;
        } else {
          if (expct != null) expect(e, expct);
          return;
        }
      }
      if (error ?? false) throw NotThrownError();
      expect(res, expct);
    };

/// Returns a [TestCase] that calls [assert] with the given argument.
TestCase testAssert(bool b) => () {
      assert(b);
    };

/// Returns a [TestCase] that calls [expect] with the given arguments.
TestCase testExpect<T>(T actual, T matcher,
        {String? reason, Object? /* String|bool */ skip}) =>
    () => expect(actual, matcher, reason: reason, skip: skip);

var _gid = 1;

/// Runs all [testCases] inside a [group] called [groupName].
///
/// If a [setup] is given, it is registered using [setUp].
///
/// See also: [test], [group] and [setUp] (from `package:test`)
@isTestGroup
void tests(Iterable<TestCase> testCases,
        [String? groupName, TestCase? setup]) =>
    group(groupName ?? 'tested group ${_gid++}', () {
      if (setup != null) setUp(setup);
      var i = 1;
      for (final testCase in testCases) {
        test('case ${i++}', testCase);
      }
    });
