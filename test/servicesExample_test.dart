import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/annotators/dateTimeAnnotator.dart';
import 'package:easy_nlu/parser/annotators/numberAnnotator.dart';
import 'package:easy_nlu/parser/grammar.dart';
import 'package:easy_nlu/parser/logicalForm.dart';
import 'package:easy_nlu/parser/parser.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/semantics.dart' as nlu;
import 'package:easy_nlu/parser/tokenizer.dart';
import 'package:easy_nlu/parser/tokenizers/basicTokenizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("services example", () async {
      List<Rule> rules = [
        Rule.fromStringWithParsedTemplate("\$ROOT", "\$Setting", "@identity"),
        Rule.fromStringWithParsedTemplate(
            "\$Setting", "\$Feature \$Action", "@merge"),
        Rule.fromStringWithParsedTemplate(
            "\$Setting", "\$Action \$Feature", "@merge"),
        Rule.fromStringWithParsedTemplate(
            "\$Feature", "\$Bluetooth", "{\"feature\": \"bluetooth\"}"),
        Rule.fromStringWithParsedTemplate(
            "\$Feature", "\$Wifi", "{\"feature\": \"wifi\"}"),
        Rule.fromStringWithParsedTemplate(
            "\$Feature", "\$Gps", "{\"feature\": \"gps\"}"),
        Rule.fromStrings("\$Bluetooth", "bt"),
        Rule.fromStrings("\$Bluetooth", "bluetooth"),
        Rule.fromStrings("\$Wifi", "wifi"),
        Rule.fromStrings("\$Gps", "gps"),
        Rule.fromStrings("\$Gps", "location"),
        Rule.fromStringWithParsedTemplate(
            "\$Action", "\$EnableDisable", "{\"action\": \"@first\"}"),
        Rule.fromStringWithParsedTemplate(
            "\$EnableDisable", "?\$Switch \$OnOff", "@last"),
        Rule.fromStringWithParsedTemplate(
            "\$EnableDisable", "\$Enable", "enable"),
        Rule.fromStringWithParsedTemplate(
            "\$EnableDisable", "\$Disable", "disable"),
        Rule.fromStringWithParsedTemplate("\$OnOff", "on", "enable"),
        Rule.fromStringWithParsedTemplate("\$OnOff", "off", "disable"),
        Rule.fromStrings("\$Switch", "switch"),
        Rule.fromStrings("\$Switch", "turn"),
        Rule.fromStrings("\$Enable", "enable"),
        Rule.fromStrings("\$Disable", "disable"),
        Rule.fromStrings("\$Disable", "kill")
      ];

      Grammar grammar = Grammar(rules, "\$ROOT");
      Parser parser = Parser(grammar, BasicTokenizer(), []);

      List<LogicalForm> logicalForm = parser.parse("kill bt");
      expect(logicalForm[0].map["action"], "disable");
      expect(logicalForm[0].map["feature"], "bluetooth");

      logicalForm = parser.parse("wifi on");
      expect(logicalForm[0].map["action"], "enable");
      expect(logicalForm[0].map["feature"], "wifi");

      logicalForm = parser.parse("enable location");
      expect(logicalForm[0].map["action"], "enable");
      expect(logicalForm[0].map["feature"], "gps");

      logicalForm = parser.parse("turn off gps");
      expect(logicalForm[0].map["action"], "disable");
      expect(logicalForm[0].map["feature"], "gps");
    });
  });
}
