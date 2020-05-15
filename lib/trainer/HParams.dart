class HParams {
  Map<String, double> _params = {};

  HParams();

  HParams withLearnRate(double learnRate) {
    _params["learnRate"] = learnRate;
    return this;
  }

  HParams withL2Penalty(double l2Penalty) {
    _params["l2Penalty"] = l2Penalty;
    return this;
  }

  HParams withLrDecay(double lrDecay) {
    _params["lrDecay"] = lrDecay;
    return this;
  }

  double learnRate(double defaultParam) {
    return _params["learnRate"] ?? defaultParam;
  }

  double l2Penalty(double defaultParam) {
    return _params["l2Penalty"] ?? defaultParam;
  }

  double lrDecay(double defaultParam) {
    return _params["lrDecay"] ?? defaultParam;
  }

  double get(String paramName, double defaultParam) {
    return _params[paramName] ?? defaultParam;
  }

  HParams set(String paramName, double value) {
    _params[paramName] = value;
    return this;
  }
}
