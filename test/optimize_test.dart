import 'dart:io';

import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/annotators/numberAnnotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/rulesFromText.dart';
import 'package:easy_nlu/parser/semantics.dart' as nlu;
import 'package:easy_nlu/trainer/HParams.dart';
import 'package:easy_nlu/trainer/SVMOptimizer.dart';
import 'package:easy_nlu/trainer/dataset.dart';
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
          File("fixtures/exmple-reminders.txt").readAsStringSync());

      List<Rule> rules = [];
      rules.addAll(Rule.baseRules);
      rules.addAll(
          rulesFromText(File("fixtures/reminders.rules").readAsStringSync()));
    });
  });
}
