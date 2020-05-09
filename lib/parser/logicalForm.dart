import 'package:collection/collection.dart';
import 'package:easy_nlu/parser/derivation.dart';

class LogicalForm {
  Map<String, Object> _map;
  Derivation _derivation;
  List<String> _fields;
  double _score;

  LogicalForm(Derivation derivation, Map<String, Object> map)
      : _derivation = derivation,
        _map = map {
    _fields = LogicalForm.fields(map);
    _score = derivation.score;
  }

  bool match(Map<String, Object> map) {
    return MapEquality().equals(_map, map);
  }

  void updateScore(Map<String, double> weights) {
    for (var field in _fields) {
      _score += weights.containsKey(field) ? weights[field] : 0.0;
    }
  }

  static List<String> fields(Map<String, Object> hashMap) {
    List<String> keys = hashMap.keys.toList().cast<String>();
    for (var entry in hashMap.entries) {
      if (entry.value is Map) {
        for (var f in LogicalForm.fields(entry.value)) {
          keys.add("${entry.key}:$f");
        }
      }
    }
    return keys;
  }

  String toString() => _map.toString();
}
