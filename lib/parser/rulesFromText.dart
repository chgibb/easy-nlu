import 'package:easy_nlu/parser/rule.dart';

List<Rule> rulesFromText(String text) {
  List<Rule> result = [];

  List<String> lines = text.split("\n");
  for (var line in lines) {
    line = line.trim();
    if (line.isEmpty) {
      continue;
    }
    List<String> items = line.split("\t");

    assert(items.length == 2 || items.length == 3, "Malformed line: $items");

    if (items.length == 3) {
      result.add(Rule.fromStringWithParsedTemplate(
          items[0].trim(), items[1].trim(), items[2].trim()));
    } else if (items.length == 2) {
      result.add(Rule.fromStrings(items[0].trim(), items[1].trim()));
    }
  }

  return result;
}
