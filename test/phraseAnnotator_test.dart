import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/annotators/numberAnnotator.dart';
import 'package:easy_nlu/parser/annotators/phraseAnnotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/semantics.dart' as nlu;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("annotate", () async {
      Annotator annotator = PhraseAnnotator();
      List<String> tokens = ["The", "boy", "who", "cried"];
      String expected = "The boy who cried";
      List<Rule> actual = annotator.annotate(tokens);

      expect(1, actual.length);
      expect("\$PHRASE", actual[0].getLHS);
      expect(expected, actual[0].getRHS.toString());
      expect(
          expected, actual[0].getSemantics(null)[0][nlu.Semantics.KEY_UNNAMED]);
    });
  });
}
