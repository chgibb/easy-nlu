import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/annotators/dateTimeAnnotator.dart';
import 'package:easy_nlu/parser/annotators/numberAnnotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/semantics.dart' as nlu;
import 'package:easy_nlu/parser/tokenizer.dart';
import 'package:easy_nlu/parser/tokenizers/basicTokenizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("tokenize", () async {
      Tokenizer tokenizer = BasicTokenizer();

      String example = "\$100, 10:45 1/2/3 4-5-6 1st 2nd 3RD 4th 10pm 3May";
      List<String> expected = [
        "\$100",
        "1045",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "1",
        "2",
        "3",
        "4",
        "10",
        "pm",
        "3",
        "May"
      ];

      expect(expected, tokenizer.tokenize(example));
    });
  });
}
