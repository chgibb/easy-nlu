import 'dart:convert';

import 'package:easy_nlu/parser/semanticFunction.dart';

extension ChainMap<K, V> on Map<K, V> {
  Map<K, V> named(K name, V value) {
    this[name] = value;
    return this;
  }
}

class Semantics {
  static const String _IDENTITY = "@identity";
  static const String _FIRST = "@first";
  static const String _LAST = "@last";
  static const String _MERGE = "@merge";
  static const String _APPEND = "@append";
  static const String KEY_UNNAMED = "__unnamed";
  static RegExp PATTERN_PARAM = RegExp("^@(\\d+)([LF])?");

  static SemanticFunction identity = (params) => params;

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
        case Semantics._IDENTITY:
          fn = Semantics.identity;
          break;
        case Semantics._FIRST:
          fn = Semantics.first;
          break;
        case Semantics._LAST:
          fn = Semantics.last;
          break;
        case Semantics._MERGE:
          fn = Semantics.merge;
          break;
        default:
          if (Semantics.PATTERN_PARAM.hasMatch(semantics)) {
            int index = Semantics.PATTERN_PARAM.firstMatch(semantics).start;
            fn = (params) => [params[index]];
          }
          break;
      }
    } else if (semantics.startsWith("{")) {
      Map<String, Object> template = json.decode(semantics);
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

        for (var entry in mapIn.keys) {
          mapOut[entry] = mapIn[entry];

          if (entry == Semantics._MERGE) {
            if (mapIn[entry] is List) {
              List<int> indices = mapIn[entry];
              for (var index in indices) {
                mapOut.addAll(params[index]);
              }
            }
            mapOut.removeWhere((x, _) => x == Semantics._MERGE);
          } else if (mapIn[entry] is Map) {
            Map<String, Object> child = {};
            mapOut[entry] = child;
            queueIn.add(Map.from(mapIn[entry]));
            queueOut.add(child);
          } else if (mapIn[entry] is String) {
            String value = mapIn[entry];
            value = value.trim();

            if (value.startsWith("@")) {
              switch (value) {
                case Semantics._FIRST:
                  Semantics.subsume(mapOut, params[0], mapIn[entry]);
                  break;
                case Semantics._LAST:
                  Semantics.subsume(
                      mapOut, params[params.length - 1], mapIn[entry]);
                  break;
                case Semantics._APPEND:
                  mapOut[mapIn[entry]] = Semantics.append(params, mapIn[entry]);
                  break;
                default:
                  Semantics.processNumberParams(
                      mapOut, mapIn[entry], value, params);
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
      } else if (params.contains(Semantics.KEY_UNNAMED) &&
          param[Semantics.KEY_UNNAMED] is int) {
        int num = param[Semantics.KEY_UNNAMED];
        if (numberType == "L") {
          map[key] = num;
        } else if (numberType == "F") {
          map[key] = num.toDouble();
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
