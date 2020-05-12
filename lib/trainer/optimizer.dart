import 'package:easy_nlu/trainer/example.dart';

mixin Optimizer {
  void onEpochStart();
  double optimize(Example e);
  void onEpochComplete(int numExamples);
}
