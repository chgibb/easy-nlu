import 'dart:collection';

import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/semanticFunction.dart';
import 'package:easy_nlu/parser/semantics.dart';
import 'package:easy_nlu/parser/stringTuple.dart';

class Grammar {
  HashMap<StringTuple, List<Rule>> _lexicalRules;
  HashMap<StringTuple, List<Rule>> _unaryRules;
  HashMap<StringTuple, List<Rule>> _binaryRules;
  HashSet<String> _combinedCategories;
  HashSet<Rule> _nonTerminals;

  HashMap<StringTuple, List<Rule>> get lexicalRules => _lexicalRules;
  HashMap<StringTuple, List<Rule>> get unaryRules => _unaryRules;
  HashMap<StringTuple, List<Rule>> get binaryRules => _binaryRules;
  HashSet<String> get combinedCategories => _combinedCategories;
  HashSet<Rule> get nonTerminals => _nonTerminals;

  String _rootCategory;

  Grammar(List<Rule> rules, String rootCategory) {
    _lexicalRules = HashMap();
    _unaryRules = HashMap();
    _binaryRules = HashMap();
    _combinedCategories = HashSet();
    _nonTerminals = HashSet();
    _rootCategory = rootCategory;

    for (var rule in rules) {
      _addRule(rule);
    }
  }

  bool isRoot(Rule rule) {
    return rule.getLHS == _rootCategory;
  }

  List<Rule> getLexicalRules(List<String> rhs) {
    StringTuple tuple = StringTuple.fromList(rhs);
    return lexicalRules.containsKey(tuple) ? lexicalRules[tuple] : [];
  }

  List<Rule> getUnaryRules(String rhs) {
    StringTuple tuple = StringTuple.fromList([rhs]);
    return unaryRules.containsKey(tuple) ? unaryRules[tuple] : [];
  }

  List<Rule> getBinaryRules(String left, String right) {
    StringTuple tuple = StringTuple.fromList([left, right]);
    return binaryRules.containsKey(tuple) ? binaryRules[tuple] : [];
  }

  Set<Rule> getNonTerminalRules() {
    return nonTerminals;
  }

  void _addRule(Rule rule) {
    if (rule.hasOptionals()) {
      _processOptionals(rule);
    } else if (rule.isLexical()) {
      _addLexicalRule(rule);
    } else if (rule.isCategorical()) {
      if (rule.isUnary()) {
        _addUnaryRule(rule);
      } else if (rule.isBinary()) {
        _addBinaryRule(rule);
      } else {
        _processNAryRule(rule);
      }
    } else {
      throw new Exception("Cannot mix terminals and non-terminals");
    }
  }

  void _addLexicalRule(Rule rule) {
    _computeIfAbsent(_lexicalRules, rule.getRHS, [rule]);
  }

  void _addUnaryRule(Rule rule) {
    _nonTerminals.add(rule);
    _computeIfAbsent(_unaryRules, rule.getRHS, [rule]);
  }

  void _addBinaryRule(Rule rule) {
    _nonTerminals.add(rule);
    _computeIfAbsent(_binaryRules, rule.getRHS, [rule]);
  }

  void _processOptionals(Rule rule) {
    StringTuple rhs = rule.getRHS;
    int index = rhs.indexWhere((x) => rule.isOptional(x));
    assert(index != -1);

    StringTuple withOptional = rhs.modify(index, (s) => s.substring(1));
    StringTuple withoutOptional = rhs.removeItem(index);

    assert(withOptional.length > 0, "Cannot have all optionals in rule: $rule");

    _addRule(Rule(rule.getLHS, withOptional, rule.getSemantics));
    SemanticFunction fn = (params) {
      params.insert(index, HashMap());
      return rule.getSemantics(params);
    };

    _addRule(Rule(rule.getLHS, withoutOptional, fn));
  }

  void _processNAryRule(Rule rule) {
    StringTuple rhs = rule.getRHS;

    String lhsUpper = rule.getLHS;
    String lhsLower = "${lhsUpper}_${rhs.getItem(0)}";

    while (_combinedCategories.contains(lhsLower)) {
      lhsLower = lhsLower + "_";
    }

    _combinedCategories.add(lhsLower);

    StringTuple rhsLower = rhs.removeItem(0);
    StringTuple rhsUpper = StringTuple.fromList([rhs.getItem(0), lhsLower]);

    _addRule(Rule(lhsLower, rhsLower, Semantics.identity));
    _addRule(Rule(lhsUpper, rhsUpper, rule.getSemantics));
  }

  V _computeIfAbsent<K, V>(Map<K, V> map, K key, V initialValue) {
    if (!map.containsKey(key)) {
      map[key] = initialValue;
      return initialValue;
    }

    return map[key];
  }
}
