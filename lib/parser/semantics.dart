import 'dart:convert';

import 'package:easy_nlu/parser/semanticFunction.dart';

extension ChainMap<K, V> on Map<K, V> {
  Map<K, V> named(K name, V value) {
    this[name] = value;
    return this;
  }
}

class Semantics {
  static const String IDENTITY = "@identity";
  static const String FIRST = "@first";
  static const String LAST = "@last";
  static const String MERGE = "@merge";
  static const String APPEND = "@append";
  static const String KEY_UNNAMED = "__unnamed";
  static RegExp PATTERN_PARAM = RegExp("^@(\\d+)([LF])?");

  static SemanticFunction identity = (params) => params;

  static String N(int item) => "@$item";
  static String N_LONG(int item) => "@${item}L";
  static String N_DOUBLE(int item) => "@${item}F";

  static Map<String, Object> named(String name, Object value) {
    Map<String, Object> map = {};
    map[name] = value;
    return map;
  }

  static Map<String, Object> value(Object value) {
    return Semantics.named(Semantics.KEY_UNNAMED, value);
  }

  static SemanticFunction valueFn(Object value) {
    return (params) => [Semantics.value(value)];
  }

  static List<Map<String, Object>> merge(List<Map<String, Object>> params) {
    Map<String, Object> map = {};
    for (var p in params) {
      if (!p.containsKey(Semantics.KEY_UNNAMED)) {
        map.addAll(p);
      }
    }
    return [map];
  }

  static List<Map<String, Object>> first(List<Map<String, Object>> params) {
    return [params[0]];
  }

  static List<Map<String, Object>> last(List<Map<String, Object>> params) {
    return [params[params.length - 1]];
  }

  static SemanticFunction parseSemantics(String semantics) {
    SemanticFunction fn;

    semantics = semantics.trim();
    if (semantics.startsWith("@")) {
      switch (semantics.toLowerCase()) {
        case Semantics.IDENTITY:
          fn = Semantics.identity;
          break;
        case Semantics.FIRST:
          fn = Semantics.first;
          break;
        case Semantics.LAST:
          fn = Semantics.last;
          break;
        case Semantics.MERGE:
          fn = Semantics.merge;
          break;
        default:
          if (Semantics.PATTERN_PARAM.hasMatch(semantics)) {
            int index = int.parse(
                Semantics.PATTERN_PARAM.firstMatch(semantics).group(1));
            fn = (params) => [params[index]];
          }
          break;
      }
    } else if (semantics.startsWith("{")) {
      Map<String, Object> template = json.decode(semantics);
      fn = Semantics.parseTemplate(template);
    } else {
      fn = Semantics.valueFn(semantics);
    }
    return fn;
  }

  static SemanticFunction parseTemplate(Map<String, Object> template) {
    return (params) {
      Map<String, Object> result = {};
      List<Map<String, Object>> queueIn = [];
      List<Map<String, Object>> queueOut = [];

      queueIn.add(template);
      queueOut.add(result);

      while (queueIn.isNotEmpty) {
        Map<String, Object> mapIn = queueIn.removeAt(0);
        Map<String, Object> mapOut = queueOut.removeAt(0);

        for (var entry in mapIn.entries) {
          mapOut[entry.key] = entry.value;

          if (entry.key == Semantics.MERGE) {
            if (entry.value is List) {
              List<dynamic> value = entry.value;
              List<int> indices = List<int>.from(value);
              for (var index in indices) {
                mapOut.addAll(params[index]);
              }
            }
            mapOut.removeWhere((x, _) => x == Semantics.MERGE);
          } else if (entry.value is Map) {
            Map<String, Object> child = {};
            mapOut[entry.key] = child;
            queueIn.add(entry.value);
            queueOut.add(child);
          } else if (entry.value is String) {
            String value = entry.value;
            value = value.trim();

            if (value.startsWith("@")) {
              switch (value) {
                case Semantics.FIRST:
                  Semantics.subsume(mapOut, params[0], entry.key);
                  break;
                case Semantics.LAST:
                  Semantics.subsume(
                      mapOut, params[params.length - 1], entry.key);
                  break;
                case Semantics.APPEND:
                  mapOut[entry.key] = Semantics.append(params, entry.key);
                  break;
                default:
                  Semantics.processNumberParams(
                      mapOut, entry.key, value, params);
                  break;
              }
            }
          }
        }
      }
      return [result];
    };
  }

  static bool processNumberParams(Map<String, Object> map, String key,
      String value, List<Map<String, Object>> params) {
    var m = Semantics.PATTERN_PARAM.firstMatch(value);
    if (m != null) {
      int index = int.parse(m.group(1));
      String numberType = m.group(2);

      Map<String, Object> param = params[index];

      if (numberType == null) {
        Semantics.subsume(map, params[index], key);
      } else if (params.firstWhere((x) => x.containsKey(Semantics.KEY_UNNAMED),
                  orElse: () => null) !=
              null &&
          param[Semantics.KEY_UNNAMED] is num) {
        int val = param[Semantics.KEY_UNNAMED];
        if (numberType == "L") {
          map[key] = val;
        } else if (numberType == "F") {
          map[key] = val.toDouble();
        }
      }
      return true;
    }
    return false;
  }

  static void subsume(
      Map<String, Object> parent, Map<String, Object> child, String key) {
    parent[key] = child.containsKey(Semantics.KEY_UNNAMED)
        ? child[Semantics.KEY_UNNAMED]
        : child;
  }

  static List<Object> append(List<Map<String, Object>> params, String key) {
    List<Object> list = [];
    for (var p in params) {
      if (p.containsKey(key)) {
        Object v = p[key];
        if (v is List) {
          list.addAll(v);
        }
      } else if (p.isNotEmpty && !p.containsKey(Semantics.KEY_UNNAMED)) {
        list.add(p);
      }
    }
    return list;
  }
}
