import 'package:easy_nlu/parser/semanticFunction.dart';
import 'package:easy_nlu/parser/stringTuple.dart';

class Rule {
  String lhs;
  StringTuple rhs;
  SemanticFunction semantics;

  Rule(String lhs, StringTuple rhs)
      : lhs = lhs,
        rhs = rhs {
    validate();
  }

  Rule.fromStrings(String lhs, String rhs)
      : lhs = lhs,
        rhs = StringTuple(rhs) {
    validate();
  }

  bool isLexical() {
    for (var item in rhs) {
      if (item.startsWith("\$")) {
        return false;
      }
    }
    return true;
  }

  bool isUnary() {
    return rhs.length == 1;
  }

  bool isBinary() {
    return rhs.length == 2;
  }

  bool isCategorical() {
    for (var item in rhs) {
      if (!isCat(item)) {
        return false;
      }
    }

    return true;
  }

  bool hasOptionals() {
    for (var item in rhs) {
      if (isOptional(item)) {
        return true;
      }
    }
    return false;
  }

  void validate() {
    assert(isCat(lhs), "Invalid Rule: $lhs->$rhs");
  }

  bool isCat(String label) {
    return label.startsWith("\$");
  }

  bool isOptional(String label) {
    return label.startsWith("?") && label.length > 1;
  }

  String toString() {
    return "Rule($lhs->$rhs)";
  }
}
