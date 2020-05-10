import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/stringTuple.dart';
import 'package:easy_nlu/parser/semantics.dart' show Semantics;

class PhraseAnnotator with Annotator {
  static const String SYMBOL = "\$PHRASE";

  List<Rule> annotate(List<String> tokens) {
    String phrase = tokens.join(" ");
    return [
      Rule(PhraseAnnotator.SYMBOL, StringTuple.fromList(tokens),
          Semantics.valueFn(phrase))
    ];
  }
}
