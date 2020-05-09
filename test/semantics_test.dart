import 'package:easy_nlu/parser/semantics.dart' as nlu;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("named chain", () async {
      Map<String, Object> target = {
        "a": 1,
        "b": {"c": 3}
      };

      Map<String, Object> map =
          nlu.Semantics.named("a", 1).named("b", nlu.Semantics.named("c", 3));

      expect(target, map);
    });

    test("merge", () async {
      List<Map<String, Object>> params = [
        nlu.Semantics.named("a", 1),
        nlu.Semantics.named("b", 2),
        nlu.Semantics.named("c", 3)
      ];

      List<Map<String, Object>> merged = [
        {"a": 1, "b": 2, "c": 3}
      ];

      expect(merged, nlu.Semantics.merge(params));
    });

    test("first", () async {
      List<Map<String, Object>> params = [
        nlu.Semantics.named("a", 1),
        nlu.Semantics.named("b", 2),
        nlu.Semantics.named("c", 3)
      ];

      List<Map<String, Object>> first = [nlu.Semantics.named("a", 1)];

      expect(first, nlu.Semantics.first(params));
    });

    test("last", () async {
      List<Map<String, Object>> params = [
        nlu.Semantics.named("a", 1),
        nlu.Semantics.named("b", 2),
        nlu.Semantics.named("c", 3)
      ];

      List<Map<String, Object>> last = [nlu.Semantics.named("c", 3)];

      expect(last, nlu.Semantics.last(params));
    });

    test("append single", () async {
      List<Map<String, Object>> params = [nlu.Semantics.named("a", 1)];

      List<Object> expected = [nlu.Semantics.named("a", 1)];

      expect(expected, nlu.Semantics.append(params, "x"));
    });

    test("append two", () async {
      List<Map<String, Object>> params = [
        nlu.Semantics.named("x", [nlu.Semantics.named("a", 1)]),
        nlu.Semantics.named("b", 2)
      ];

      List<Object> expected = [
        nlu.Semantics.named("a", 1),
        nlu.Semantics.named("b", 2)
      ];

      expect(expected, nlu.Semantics.append(params, "x"));
    });

    test("append multi", () async {
      List<Map<String, Object>> params = [
        nlu.Semantics.named("x", [nlu.Semantics.named("a", 1)]),
        nlu.Semantics.named("b", 2),
        nlu.Semantics.named(nlu.Semantics.KEY_UNNAMED, 4),
        nlu.Semantics.named("c", 3)
      ];

      List<Object> expected = [
        nlu.Semantics.named("a", 1),
        nlu.Semantics.named("b", 2),
        nlu.Semantics.named("c", 3)
      ];

      expect(expected, nlu.Semantics.append(params, "x"));
    });

    test("parse semantics", () async {
      List<Map<String, Object>> params = [
        nlu.Semantics.named("a", 1),
        nlu.Semantics.named("b", 2),
        nlu.Semantics.named("c", 3)
      ];

      List<Map<String, Object>> first = [nlu.Semantics.named("a", 1)];

      List<Map<String, Object>> mid = [nlu.Semantics.named("b", 2)];

      expect(first, nlu.Semantics.parseSemantics("@first")(params));
      expect(mid, nlu.Semantics.parseSemantics("@1")(params));
    });
  });
}
