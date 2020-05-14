import 'dart:math';

class Gaussian {
  Random _random = Random();
  bool _haveNextNextGaussian = false;
  double _nextNextGaussian;

  //https://docs.oracle.com/javase/7/docs/api/java/util/Random.html#nextGaussian()
  double nextGaussian() {
    if (_haveNextNextGaussian) {
      _haveNextNextGaussian = false;
      return _nextNextGaussian;
    } else {
      double v1, v2, s;
      do {
        v1 = 2 * _random.nextDouble() - 1; // between -1.0 and 1.0
        v2 = 2 * _random.nextDouble() - 1; // between -1.0 and 1.0
        s = v1 * v1 + v2 * v2;
      } while (s >= 1 || s == 0);
      double multiplier = sqrt(-2 * log(s) / s);
      _nextNextGaussian = v2 * multiplier;
      _haveNextNextGaussian = true;
      return v1 * multiplier;
    }
  }
}
