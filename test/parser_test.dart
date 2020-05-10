import 'package:easy_nlu/parser/annotators/phraseAnnotator.dart';
import 'package:easy_nlu/parser/chart.dart';
import 'package:easy_nlu/parser/derivation.dart';
import 'package:easy_nlu/parser/grammar.dart';
import 'package:easy_nlu/parser/logicalForm.dart';
import 'package:easy_nlu/parser/parser.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/tokenizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class SplitTokenizer with Tokenizer {
  List<String> tokenize(String input) {
    return input.split(" ");
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("chart", () async {
      Chart chart = Chart(10);

      expect(32, chart.mapSpan(2, 3));

      Derivation d = Derivation(null, null);
      chart.addDerivation(3, 5, d);
      expect(1, chart.getDerivations(3, 5).length);
      expect(d, chart.getDerivations(3, 5)[0]);
    });

    test("parse syntactic", () async {
      Rule r1 = Rule.fromStrings("\$A", "a");
      Rule r2 = Rule.fromStrings("\$B", "b");
      Rule r3 = Rule.fromStrings("\$C", "\$A \$B");

      Grammar grammar = Grammar([r1, r2, r3], "\$C");
      Parser p = Parser(grammar, SplitTokenizer(), []);

      Derivation dc1 = Derivation(r1, null);
      Derivation dc2 = Derivation(r2, null);

      Derivation expected = Derivation(r3, [dc1, dc2]);
      Derivation actual = p.parseSyntactic("a b")[0];

      expect(expected.rule, actual.rule);
      expect(expected.children[0].rule, actual.children[0].rule);
      expect(expected.children[1].rule, actual.children[1].rule);
    });

    test("parse", () async {
      List<Rule> rules = [
        Rule.fromStrings("\$A", "a"),
        Rule.fromStrings("\$B", "b"),
        Rule.fromStringWithParsedTemplate(
            "\$C", "\$A \$B", "{\"e\":\"@first\", \"f\":\"@last\"}")
      ];

      Grammar grammar = Grammar(rules, "\$C");

      Parser p = Parser(grammar, SplitTokenizer(), []);

      Map<String, Object> expected = {"e": "a", "f": "b"};

      List<LogicalForm> actual = p.parse("a b");
      expect(1, actual.length);
      expect(expected, actual[0].map);
    });

    test("apply semantics", () async {
      Rule r1 = Rule.fromStrings("\$A", "a");
      Rule r2 =
          Rule.fromStringWithParsedTemplate("\$B", "\$A \$A", "{\"b\":\"@1\"}");

      Derivation dc1 = Derivation(r1, null);
      Derivation dc2 = Derivation(r1, null);

      Derivation d = Derivation(r2, [dc1, dc2]);

      Map<String, Object> expected = {"b": "a"};

      Parser p = Parser(null, null, null);

      expect(expected, p.applySemantics(d)[0]);
    });

    test("apply annotators", () async {
      Parser p = Parser(null, null, [PhraseAnnotator()]);
      Chart chart = Chart(10);
      List<String> tokens = ["A", "B", "C"];
      Rule r = PhraseAnnotator().annotate(tokens)[0];

      p.applyAnnotators(chart, tokens, 0, 3);
      expect(r, chart.getDerivations(0, 3)[0].rule);
    });

    test("apply lexical rules", () async {
      List<Rule> rules = [Rule.fromStrings("\$A", "B C")];
      Grammar grammar = Grammar(rules, "\$ROOT");

      Parser p = Parser(grammar, null, null);
      Chart chart = Chart(10);
      List<String> tokens = ["A", "B", "C"];

      p.applyLexicalRules(chart, tokens, 1, 3);
      expect(rules[0], chart.getDerivations(1, 3)[0].rule);
    });

    test("apply unary rules", () async {
      List<Rule> rules = [
        Rule.fromStrings("\$F", "\$E"),
        Rule.fromStrings("\$E", "\$D")
      ];
      Grammar grammar = Grammar(rules, "\$ROOT");

      Parser p = Parser(grammar, null, null);
      Chart chart = Chart(10);

      chart.addDerivation(
          1, 3, Derivation(Rule.fromStrings("\$D", "\$B \$C"), null));

      p.applyUnaryRules(chart, 1, 3);

      expect(3, chart.getDerivations(1, 3).length);
      expect(rules[0], chart.getDerivations(1, 3)[2].rule);
      expect(rules[1], chart.getDerivations(1, 3)[1].rule);
    });

    test("apply binary rules", () async {
      List<Rule> rules = [Rule.fromStrings("\$C", "\$A \$B")];
      Grammar grammar = Grammar(rules, "\$ROOT");

      Parser p = Parser(grammar, null, null);
      Chart chart = Chart(10);

      chart.addDerivation(0, 1, Derivation(Rule.fromStrings("\$A", "A"), null));
      chart.addDerivation(1, 2, Derivation(Rule.fromStrings("\$B", "B"), null));

      p.applyBinaryRules(chart, 0, 2);
      expect(rules[0], chart.getDerivations(0, 2)[0].rule);
    });
  });
}
