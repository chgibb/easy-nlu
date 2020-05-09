import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/stringTuple.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("get RHS", () async {
      Rule r = Rule.fromStrings("\$A", "B C D");
      expect(r.getRHS, StringTuple.fromList(["B", "C", "D"]));
    });

    test("isLexical", () async {
      Rule r1 = Rule.fromStrings("\$A", "B C D");
      Rule r2 = Rule.fromStrings("\$A", "B C \$D");
      Rule r3 = Rule.fromStrings("\$A", "B");
      Rule r4 = Rule.fromStrings("\$A", "\$B");

      expect(r1.isLexical(), true);
      expect(r2.isLexical(), false);
      expect(r3.isLexical(), true);
      expect(r4.isLexical(), false);
    });

    test("isUnary", () async {
      Rule r1 = Rule.fromStrings("\$A", "B C D");
      Rule r2 = Rule.fromStrings("\$A", "B C \$D");
      Rule r3 = Rule.fromStrings("\$A", "B");
      Rule r4 = Rule.fromStrings("\$A", "\$B");

      expect(r1.isUnary(), false);
      expect(r2.isUnary(), false);
      expect(r3.isUnary(), true);
      expect(r4.isUnary(), true);
    });

    test("isBinary", () async {
      Rule r1 = Rule.fromStrings("\$A", "B C");
      Rule r2 = Rule.fromStrings("\$A", "B C \$D");
      Rule r3 = Rule.fromStrings("\$A", "B");

      expect(r1.isBinary(), true);
      expect(r2.isBinary(), false);
      expect(r3.isBinary(), false);
    });

    test("isCategorical", () async {
      Rule r1 = Rule.fromStrings("\$A", "B C D");
      Rule r2 = Rule.fromStrings("\$A", "B C \$D");
      Rule r3 = Rule.fromStrings("\$A", "\$B \$C");
      Rule r4 = Rule.fromStrings("\$A", "\$B");

      expect(r1.isCategorical(), false);
      expect(r2.isCategorical(), false);
      expect(r3.isCategorical(), true);
      expect(r4.isCategorical(), true);
    });

    test("hasOptionals", () async {
      Rule r1 = Rule.fromStrings("\$A", "?B C");
      Rule r2 = Rule.fromStrings("\$A", "B C ?\$D");
      Rule r3 = Rule.fromStrings("\$A", "?B");
      Rule r4 = Rule.fromStrings("\$A", "\$B \$D");

      expect(r1.hasOptionals(), true);
      expect(r2.hasOptionals(), true);
      expect(r3.hasOptionals(), true);
      expect(r4.hasOptionals(), false);
    });
  });
}
