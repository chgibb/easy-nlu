import 'dart:math';

import 'package:easy_nlu/trainer/example.dart';

class Dataset {
  List<Example> examples = [];
  Random random = Random();

  Dataset();

  factory Dataset.fromText(String text) {
    Dataset d = Dataset();
    d.examples = d._parseText(text, "\t");
    return d;
  }

  List<Example> _parseText(String text, String separator) {
    List<Example> result = [];

    List<String> lines = text.split("\n");
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) {
        continue;
      }
      List<String> items = line.split(separator);
      assert(items.length == 2, "Malformed line: $line");

      result.add(Example(items[0], items[1]));
    }

    return result;
  }

  Dataset shuffle() {
    examples.shuffle(random);
    return this;
  }

  List<Dataset> split(double trainFraction, bool shuffleFirst) {
    if (shuffleFirst) {
      shuffle();
    }

    int offset = (examples.length * trainFraction).floor();
    Dataset train = Dataset();
    Dataset test = Dataset();

    train.examples = examples.sublist(0, offset);
    test.examples = examples.sublist(offset, examples.length);

    return [train, test];
  }

  Example randomExample() {
    return examples[random.nextInt(examples.length)];
  }
}
