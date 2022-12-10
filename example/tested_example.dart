import 'package:tested/tested.dart';

int goodAdd(int a, int b) {
  return a + b;
}

int badAdd(int a, int b) {
  return a * b;
}

TestCase addTestCase(int Function(int, int) addFunc, List<int> c) =>
    expectTestCase(() => addFunc(c[0], c[1]), c[2]);

void main() {
  const cases = [
    [1, 2, 3],
    [40, 2, 42],
    [-1, -12, -13],
  ];
  tests(cases.map((c) => addTestCase(goodAdd, c)), 'good'); // doesn't fail
  tests(cases.map((c) => addTestCase(badAdd, c)), 'bad'); // fails
}
