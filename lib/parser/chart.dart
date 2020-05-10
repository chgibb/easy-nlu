import 'package:easy_nlu/parser/derivation.dart';

class Chart {
  static const int MAX_CAPACITY_PER_SPAN = 2000;

  Map<int, List<Derivation>> _chart;
  int _base;

  Chart(int size)
      : _base = size,
        _chart = {};

  List<Derivation> getDerivations(int start, int end) {
    int span = mapSpan(start, end);
    if (!_chart.containsKey(span)) {
      List<Derivation> d = [];
      _chart[span] = d;
      return d;
    }
    return _chart[span];
  }

  void addDerivation(int start, int end, Derivation derivation) {
    getDerivations(start, end).add(derivation);
  }

  bool isSpanFull(int start, int end) {
    List<Derivation> dl = getDerivations(start, end);
    int size = dl.length;
    if (size > Chart.MAX_CAPACITY_PER_SPAN) {
      return true;
    }
    return false;
  }

  int mapSpan(int s, int e) {
    return e * _base + s;
  }
}
