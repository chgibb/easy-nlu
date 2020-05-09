import 'package:easy_nlu/parser/logicalForm.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("", () async {
      Map<String, Object> map = {
        "a": 1,
        "b": 2,
        "c": {
          "d": 4,
          "e": {"f": 5}
        }
      };

      List<String> expected = ["a", "b", "c", "c:d", "c:e", "c:e:f"];

      expect(expected, LogicalForm.fields(map));
    });
  });
}
