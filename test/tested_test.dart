import 'package:tested/tested.dart';

void main() {
  tests([
    expectTestCase(() => 1, 1),
    expectTestCase(() => throw 'kekw', null, true),
  ]);
}
