import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/annotators/numberAnnotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/semantics.dart' as nlu;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("annotate", () async {
      Annotator annotator = NumberAnnotator();
      List<String> tokens = ["123"];
      List<Rule> actual = annotator.annotate(tokens);

      expect(1, actual.length);
      expect("\$NUMBER", actual[0].getLHS);
      expect("123", actual[0].getRHS.toString());
      expect(123.0, actual[0].getSemantics(null)[0][nlu.Semantics.KEY_UNNAMED]);
    });
  });
}
