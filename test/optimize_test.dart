import 'dart:io';

import 'package:easy_nlu/parser/annotators/dateTimeAnnotator.dart';
import 'package:easy_nlu/parser/annotators/numberAnnotator.dart';
import 'package:easy_nlu/parser/annotators/phraseAnnotator.dart';
import 'package:easy_nlu/parser/annotators/tokenAnnotator.dart';
import 'package:easy_nlu/parser/grammar.dart';
import 'package:easy_nlu/parser/parser.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/rulesFromText.dart';
import 'package:easy_nlu/parser/tokenizers/basicTokenizer.dart';
import 'package:easy_nlu/trainer/HParams.dart';
import 'package:easy_nlu/trainer/SVMOptimizer.dart';
import 'package:easy_nlu/trainer/dataset.dart';
import 'package:easy_nlu/trainer/model.dart';
import 'package:easy_nlu/trainer/optimizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("optimize", () async {
      HParams hParams = HParams()
          .withLearnRate(0.08)
          .withL2Penalty(0.01)
          .set(SVMOptimizer.CORRECT_PROB, 0.4);

      Dataset d = Dataset.fromText(
          File("fixtures/example-reminders.txt").readAsStringSync());

      List<Rule> rules = [];
      rules.addAll(Rule.baseRules);
      rules.addAll(
          rulesFromText(File("fixtures/reminders.rules").readAsStringSync()));

      rules.addAll(DateTimeAnnotator.DATE_RULES);

      Grammar grammar = Grammar(rules, "\$ROOT");
      Parser parser = Parser(grammar, BasicTokenizer(), [
        TokenAnnotator(),
        PhraseAnnotator(),
        NumberAnnotator(),
        DateTimeAnnotator()
      ]);

      Model m = Model(parser);

      Optimizer optimizer = SVMOptimizer(m, hParams);

      m.train(d, optimizer, 30);

      double acc = m.evaluate(d, 0);

      expect(acc, greaterThan(0.834));
    });
  });
}
