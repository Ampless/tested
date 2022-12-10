import 'package:tested/tested.dart';

void main() {
  tests('test', [
    expectTestCase(() => 1, 1, false),
    expectTestCase(() => throw 'kekw', 0, true),
  ]);
}
