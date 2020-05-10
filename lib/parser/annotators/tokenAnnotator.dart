import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/stringTuple.dart';
import 'package:easy_nlu/parser/semantics.dart' show Semantics;

class TokenAnnotator with Annotator {
  static const String SYMBOL = "\$TOKEN";

  List<Rule> annotate(List<String> tokens) {
    if (tokens.length == 1) {
      return [
        Rule(TokenAnnotator.SYMBOL, StringTuple.fromList(tokens),
            Semantics.valueFn(tokens[0]))
      ];
    }
    return [];
  }
}
