import 'package:easy_nlu/parser/rule.dart';

class Derivation {
  Rule rule;
  double score = 0.0;
  List<Derivation> children;

  Derivation(Rule rule, List<Derivation> children)
      : rule = rule,
        children = children;

  Map<String, int> getRuleFeatures() {
    return _getRuleFeatures(this);
  }

  Map<String, int> _getRuleFeatures(Derivation d) {
    Map<String, int> features = {};
    if (d.children == null) {
      return features;
    }
    features[d.rule.toString()] = 1;

    for (var child in d.children) {
      for (var entry in _getRuleFeatures(child).keys) {
        int count = features.containsKey(entry) ? features[entry] : 0;
        features[entry] =
            count + (features.containsKey(entry) ? features[entry] : 1);
      }
    }
    return features;
  }
}
