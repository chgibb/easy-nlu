import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/annotators/dateTimeAnnotator.dart';
import 'package:easy_nlu/parser/annotators/numberAnnotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/semantics.dart' as nlu;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("annotate month", () async {
      List<String> tokens = ["May"];
      List<Rule> rules = DateTimeAnnotator().annotate(tokens);

      expect(rules[0].getLHS, "\$DATE_MONTH");
      List<Map<String, Object>> result = rules[0].getSemantics([]);
      expect(result[0].containsKey("month"), true);
      expect(result[0]["month"], 5.0);
    });

    test("annotate dow", () async {
      List<String> tokens = ["Sunday"];
      List<Rule> rules = DateTimeAnnotator().annotate(tokens);

      expect(rules[0].getLHS, "\$DATE_DOW");
      List<Map<String, Object>> result = rules[0].getSemantics([]);

      expect(result[0].containsKey("dow"), true);
      expect(result[0]["dow"], 7.0);
    });
  });
}
