import 'package:easy_nlu/parser/derivation.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("", () async {
      Rule r1 = Rule.fromStrings("\$A", "a");
      Rule r2 = Rule.fromStrings("\$B", "\$A \$A");

      Derivation dc1 = Derivation(r1, []);
      Derivation dc2 = Derivation(r1, []);
      Derivation d = Derivation(r2, [dc1, dc2]);

      Map<String, int> expected = {r1.toString(): 2, r2.toString(): 1};

      expect(expected, d.getRuleFeatures());
    });
  });
}
