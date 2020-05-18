import 'dart:io';

import 'package:easy_nlu/parser/logicalForm.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/rulesFromText.dart';
import 'package:easy_nlu/trainer/model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("services example from file", () async {
      List<Rule> rulesFromFile = rulesFromText(
          File("fixtures/services.rules").readAsStringSync());

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

      expect(rules.length, rulesFromFile.length);

      for (var i = 0; i != rules.length; ++i) {
        expect(rules[i], rulesFromFile[i]);
      }

      Model model = Model.fromFiles("fixtures/services");

      List<LogicalForm> logicalForm = model.parser.parse("kill bt");
      expect(logicalForm[0].map["action"], "disable");
      expect(logicalForm[0].map["feature"], "bluetooth");

      logicalForm = model.parser.parse("wifi on");
      expect(logicalForm[0].map["action"], "enable");
      expect(logicalForm[0].map["feature"], "wifi");

      logicalForm = model.parser.parse("enable location");
      expect(logicalForm[0].map["action"], "enable");
      expect(logicalForm[0].map["feature"], "gps");

      logicalForm = model.parser.parse("turn off gps");
      expect(logicalForm[0].map["action"], "disable");
      expect(logicalForm[0].map["feature"], "gps");
    });
  });
}
