library tested;
import 'dart:async';

import 'package:test/test.dart';

typedef TestCase = FutureOr<void> Function();

// TODO: expectTestCase(() async => throw 'kekw', Error)
TestCase expectTestCase<T>(
  FutureOr<T> Function() tfunc,
  T expct,
  bool error,
) =>
    () async {
      T res;
      try {
        res = await tfunc();
      } catch (e) {
        if (!error) {
          rethrow;
        } else {
          return;
        }
      }
      if (error) throw '[expectTestCase($tfunc, $expct)] No error.';
      expect(res, expct);
    };

TestCase testAssert(bool b) => () async {
      assert(b);
    };

TestCase testExpect<T>(T actual, T matcher) =>
    () async => expect(actual, matcher);

void tests(String groupName, Iterable<TestCase> testCases, [TestCase? setup]) =>
    group(groupName, () {
      if (setup != null) setUp(setup);
      var i = 1;
      for (final testCase in testCases) {
        test('case ${i++}', testCase);
      }
    });
