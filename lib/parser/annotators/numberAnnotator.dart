import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/semantics.dart' show Semantics;

class NumberAnnotator with Annotator {
  static const String SYMBOL = "\$NUMBER";

  List<Rule> annotate(List<String> tokens) {
    if (tokens.length == 1) {
      try {
        return [
          Rule.fromStringsWithTemplate(NumberAnnotator.SYMBOL, tokens[0],
              Semantics.value(double.parse(tokens[0])))
        ];
      } catch (err) {
        print(err);
      }
    }
    return [];
  }
}
