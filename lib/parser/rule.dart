import 'package:easy_nlu/parser/semanticFunction.dart';
import 'package:easy_nlu/parser/stringTuple.dart';
import 'package:easy_nlu/parser/semantics.dart' show Semantics;

class Rule {
  String _lhs;
  StringTuple _rhs;
  SemanticFunction _semantics;

  Rule(String lhs, StringTuple rhs, [SemanticFunction semantics])
      : _lhs = lhs,
        _rhs = rhs,
        _semantics = semantics {
    validate();
  }

  Rule.fromStrings(String lhs, String rhs, [SemanticFunction semantics])
      : _lhs = lhs,
        _rhs = StringTuple(rhs),
        _semantics = semantics {
    validate();
  }

  Rule.fromStringsWithTemplate(
      String lhs, String rhs, Map<String, Object> semantics)
      : _lhs = lhs,
        _rhs = StringTuple(rhs),
        _semantics = Semantics.parseTemplate(semantics) {
    validate();
  }

  Rule.fromStringWithParsedTemplate(String lhs, String rhs, String semantics)
      : _lhs = lhs,
        _rhs = StringTuple(rhs),
        _semantics = Semantics.parseSemantics(semantics) {
    validate();
  }

  String get getLHS => _lhs;
  StringTuple get getRHS => _rhs;

  SemanticFunction get getSemantics => _semantics;

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

  bool operator ==(Object o) =>
      o is Rule ? o._lhs == _lhs && o._rhs == _rhs : false;
  int get hashCode => _rhs.hashCode;

  static List<Rule> baseRules = [
    Rule.fromStrings("\$To", "to"),
    Rule.fromStrings("\$For", "for"),
    Rule.fromStrings("\$From", "from"),
    Rule.fromStrings("\$Of", "of"),
    Rule.fromStrings("\$On", "on"),
    Rule.fromStrings("\$In", "in"),
    Rule.fromStrings("\$The", "the"),
    Rule.fromStrings("\$I", "i"),
    Rule.fromStrings("\$As", "as"),
    Rule.fromStrings("\$An", "an"),
    Rule.fromStrings("\$A", "a"),
    Rule.fromStrings("\$By", "by"),
    Rule.fromStrings("\$At", "at"),
    Rule.fromStrings("\$And", "and"),
    Rule.fromStrings("\$After", "after")
  ];
}
