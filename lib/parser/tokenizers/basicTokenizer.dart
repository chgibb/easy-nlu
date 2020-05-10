import 'package:easy_nlu/parser/tokenizer.dart';

class BasicTokenizer with Tokenizer {
  List<String> tokenize(String input) {
    String cleaned = input
        .trim()
        .replaceAllMapped(RegExp("[:,]"), (m) => "")
        .replaceAllMapped(RegExp("[/\\-]"), (m) => " ")
        .replaceAllMapped(
            RegExp("(\\d)(st|nd|rd|th|ST|ND|RD|TH)?"), (m) => m.group(1))
        .replaceAllMapped(
            RegExp("(\\d)([a-zA-Z])"), (m) => "${m.group(1)} ${m.group(2)}");
    return cleaned.split(" ");
  }
}
