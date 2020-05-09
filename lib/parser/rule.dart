import 'package:easy_nlu/parser/semanticFunction.dart';
import 'package:easy_nlu/parser/stringTuple.dart';

class Rule {
  String _lhs;
  StringTuple _rhs;
  SemanticFunction semantics;

  Rule(String lhs, StringTuple rhs)
      : _lhs = lhs,
        _rhs = rhs {
    validate();
  }

  Rule.fromStrings(String lhs, String rhs)
      : _lhs = lhs,
        _rhs = StringTuple(rhs) {
    validate();
  }

  String get getLHS => _lhs;
  StringTuple get getRHS => _rhs;

  bool isLexical() {
    for (var item in _rhs) {
      if (item.startsWith("\$")) {
        return false;
      }
    }
    return true;
  }

  bool isUnary() {
    return _rhs.length == 1;
  }

  bool isBinary() {
    return _rhs.length == 2;
  }

  bool isCategorical() {
    for (var item in _rhs) {
      if (!isCat(item)) {
        return false;
      }
    }

    return true;
  }

  bool hasOptionals() {
    for (var item in _rhs) {
      if (isOptional(item)) {
        return true;
      }
    }
    return false;
  }

  void validate() {
    assert(isCat(_lhs), "Invalid Rule: $_lhs->$_rhs");
  }

  bool isCat(String label) {
    return label.startsWith("\$");
  }

  bool isOptional(String label) {
    return label.startsWith("?") && label.length > 1;
  }

  String toString() {
    return "Rule($_lhs->$_rhs)";
  }
}
