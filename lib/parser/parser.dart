import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/chart.dart';
import 'package:easy_nlu/parser/derivation.dart';
import 'package:easy_nlu/parser/grammar.dart';
import 'package:easy_nlu/parser/logicalForm.dart';
import 'package:easy_nlu/parser/semanticFunction.dart';
import 'package:easy_nlu/parser/semantics.dart';
import 'package:easy_nlu/parser/tokenizer.dart';

class Parser {
  Grammar _grammar;
  Tokenizer _tokenizer;
  List<Annotator> _annotators;
  Map<String, double> weights;

  Parser(Grammar grammar, Tokenizer tokenizer, List<Annotator> annotators)
      : _grammar = grammar,
        _tokenizer = tokenizer,
        _annotators = annotators,
        weights = {};

  List<Derivation> parseSyntactic(String input) {
    List<String> tokens = _tokenizer.tokenize(input);
    List<String> tokensLower = [];

    for (var token in tokens) {
      tokensLower.add(token.toLowerCase());
    }

    int N = tokens.length;
    Chart chart = Chart(N + 1);

    for (var i = 1; i <= N; ++i) {
      for (var k = i - 1; k >= 0; --k) {
        applyAnnotators(chart, tokens, k, i);
        applyLexicalRules(chart, tokens, k, i);
        applyBinaryRules(chart, k, i);
        applyUnaryRules(chart, k, i);
      }
    }

    List<Derivation> derivations = [];
    for (var d in chart.getDerivations(0, N)) {
      if (_grammar.isRoot(d.rule)) {
        derivations.add(d);
      }
    }
    return derivations;
  }

  List<LogicalForm> parse(String input) {
    List<LogicalForm> lfs = [];

    for (var d in parseSyntactic(input)) {
      lfs.add(computeLogicalForm(d));
    }

    return lfs.reversed.toList().cast<LogicalForm>();
  }

  LogicalForm computeLogicalForm(Derivation d) {
    LogicalForm lf = LogicalForm(d, applySemantics(d)[0]);
    lf.updateScore(weights);

    return lf;
  }

  List<Map<String, Object>> applySemantics(Derivation d) {
    SemanticFunction fn = d.rule.getSemantics;

    if (d.children == null) {
      if (fn == null) {
        return [Semantics.value(d.rule.getRHS.toString())];
      } else {
        return fn([]);
      }
    }

    String rule = d.rule.toString();
    d.score = weights.containsKey(rule) ? weights[rule] : 0.0;
    List<Map<String, Object>> params = [];

    for (var child in d.children) {
      params.addAll(applySemantics(child));
      d.score += child.score;
    }

    return fn(params);
  }

  void applyAnnotators(Chart chart, List<String> tokens, int start, int end) {
    for (var annotator in _annotators) {
      for (var rule in annotator.annotate(tokens.sublist(start, end))) {
        if (chart.isSpanFull(start, end)) {
          return;
        }
        chart.addDerivation(start, end, Derivation(rule, null));
      }
    }
  }

  void applyLexicalRules(Chart chart, List<String> tokens, int start, int end) {
    for (var rule in _grammar.getLexicalRules(tokens.sublist(start, end))) {
      chart.addDerivation(start, end, Derivation(rule, null));
    }
  }

  void applyUnaryRules(Chart chart, int start, int end) {
    List<Derivation> queue = List.from(chart.getDerivations(start, end));

    while (queue.isNotEmpty) {
      Derivation d = queue.removeAt(0);

      for (var rule in _grammar.getUnaryRules(d.rule.getLHS)) {
        if (chart.isSpanFull(start, end)) {
          return;
        }

        Derivation parent = Derivation(rule, [d]);

        queue.add(parent);
        chart.addDerivation(start, end, parent);
      }
    }
  }

  void applyBinaryRules(Chart chart, int start, int end) {
    if (end > start - 1) {
      for (var mid = start + 1; mid < end; ++mid) {
        List<Derivation> left = chart.getDerivations(start, mid);
        List<Derivation> right = chart.getDerivations(mid, end);

        for (var l in left) {
          for (var r in right) {
            for (var rule
                in _grammar.getBinaryRules(l.rule.getLHS, r.rule.getLHS)) {
              if (chart.isSpanFull(start, end)) {
                return;
              }

              chart.addDerivation(start, end, Derivation(rule, [l, r]));
            }
          }
        }
      }
    }
  }
}
