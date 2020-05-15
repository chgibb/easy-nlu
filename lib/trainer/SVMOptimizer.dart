import 'dart:math';

import 'package:easy_nlu/parser/derivation.dart';
import 'package:easy_nlu/parser/logicalForm.dart';
import 'package:easy_nlu/parser/parser.dart';
import 'package:easy_nlu/trainer/HParams.dart';
import 'package:easy_nlu/trainer/example.dart';
import 'package:easy_nlu/trainer/gaussian.dart';
import 'package:easy_nlu/trainer/model.dart';
import 'package:easy_nlu/trainer/optimizer.dart';

class SVMOptimizer with Optimizer {
  static const String CORRECT_PROB = "correctProb";

  double _learnRate;
  double _l2Penalty;
  double _lrDecay;
  double _correctProb;
  Parser _parser;
  Map<String, double> _weights;
  Random _random = Random();
  Gaussian _gaussian = Gaussian();

  SVMOptimizer(Model model, HParams hParams) {
    _parser = model.parser;
    _weights = model.weights;

    _learnRate = hParams.learnRate(0.1).toDouble();
    _l2Penalty = hParams.l2Penalty(0.0).toDouble();
    _lrDecay = hParams.lrDecay(1.0).toDouble();
    _correctProb = hParams.get(SVMOptimizer.CORRECT_PROB, 0.5).toDouble();
  }

  void onEpochStart() {}

  double optimize(Example e) {
    List<LogicalForm> candidates = _parser.parse(e.input);
    if (candidates.isEmpty) {
      return 1;
    }

    LogicalForm lf = randomCandidate(e, candidates);
    Derivation d = lf.derivation;

    Map<String, int> features = d.getRuleFeatures();

    features.keys.forEach((x) {
      features[x] = 1;
    });

    double target = computeTarget(lf, e);
    double loss = hingeLoss(features, target);

    if (loss > 0) {
      updateWeights(features, target, _learnRate);
    }

    updateL2Penalty(_learnRate, _l2Penalty);

    return loss;
  }

  void onEpochComplete(int numExamples) {
    _learnRate *= _lrDecay;
  }

  double computeScore(Map<String, int> features) {
    double y = 0;
    for (var entry in features.entries) {
      y += _weights.putIfAbsent(entry.key, () => _gaussian.nextGaussian()) *
          entry.value;
    }

    return y;
  }

  double hingeLoss(Map<String, int> features, double target) {
    double y = computeScore(features);
    return max(0, 1 - target * y);
  }

  double l2Loss(double l2Penalty) {
    return _weights.values.map((x) => x * x).toList().reduce((a, b) => a + b);
  }

  double computeTarget(LogicalForm lf, Example e) {
    return lf.match(e.label) ? 1 : -1;
  }

  void updateWeights(
      Map<String, int> features, double target, double learnRate) {
    features.forEach(
        (k, v) => _weights.update(k, (x) => x + learnRate * v * target));
  }

  void updateL2Penalty(double learnRate, double l2Penalty) {
    _weights.keys.forEach((x) {
      _weights[x] = _weights[x] * (1 - learnRate * l2Penalty);
    });
  }

  LogicalForm randomCandidate(Example e, List<LogicalForm> candidates) {
    LogicalForm correct;
    if (_random.nextDouble() < _correctProb) {
      for (var lf in candidates) {
        if (lf.match(e.label)) {
          correct = lf;
          break;
        }
      }
    }
    if (correct != null) {
      return correct;
    } else {
      return candidates[_random.nextInt(candidates.length)];
    }
  }
}
