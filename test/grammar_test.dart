import 'package:easy_nlu/parser/grammar.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/stringTuple.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("should split optionals", () async {
      List<Rule> rules = [Rule.fromStrings("\$A", "?\$B \$C")];

      Grammar g = Grammar(rules, null);

      expect(g.binaryRules.containsKey(StringTuple("\$B \$C")), true);
      expect(g.unaryRules.containsKey(StringTuple("\$C")), true);

      expect(g.binaryRules[StringTuple("\$B \$C")][0].getLHS, "\$A");
      expect(g.unaryRules[StringTuple("\$C")][0].getLHS, "\$A");
    });

    test("should split N-ary rule", () async {
      List<Rule> rules = [Rule.fromStrings("\$A", "\$B \$C \$D")];

      Grammar g = Grammar(rules, null);

      expect(g.binaryRules.containsKey(StringTuple("\$C \$D")), true);
      expect(g.binaryRules.containsKey(StringTuple("\$B \$A_\$B")), true);

      expect(g.binaryRules[StringTuple("\$C \$D")][0].getLHS, "\$A_\$B");
      expect(g.binaryRules[StringTuple("\$B \$A_\$B")][0].getLHS, "\$A");
    });
  });
}
