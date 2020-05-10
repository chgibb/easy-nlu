import 'package:easy_nlu/parser/annotator.dart';
import 'package:easy_nlu/parser/rule.dart';
import 'package:easy_nlu/parser/semantics.dart' show Semantics;

class DateTimeAnnotator with Annotator {
  static const String CAT_DATE = "\$DATE";

  static const List<String> MONTHS = [
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december",
    "jan",
    "feb",
    "mar",
    "apr",
    "jun",
    "jul",
    "aug",
    "sep",
    "oct",
    "nov",
    "dec"
  ];

  static const List<String> DOW = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
    "mon",
    "tue",
    "wed",
    "thu",
    "fri",
    "sat",
    "sun"
  ];

  static const Map<String, String> SHIFT_MAP = {
    "morning": "morning",
    "noon": "noon",
    "afternoon": "afternoon",
    "evening": "evening",
    "tonight": "night",
    "night": "night",
    "am": "am",
    "pm": "pm"
  };

  static RegExp PATTERN_NUMBER = RegExp("(\\d+)(st\$|rd\$|th\$)?");

  static List<Rule> DATE_RULES = [
    Rule.fromStrings("\$Hour", "hour"),
    Rule.fromStrings("\$Hour", "hours"),
    Rule.fromStrings("\$Hour", "hr"),
    Rule.fromStrings("\$Hour", "h"),
    Rule.fromStrings("\$Hour", "hrs"),
    Rule.fromStrings("\$Hourly", "hourly"),
    Rule.fromStrings("\$Second", "second"),
    Rule.fromStrings("\$Second", "seconds"),
    Rule.fromStrings("\$Second", "sec"),
    Rule.fromStrings("\$Second", "secs"),
    Rule.fromStrings("\$Second", "s"),
    Rule.fromStrings("\$Minute", "minute"),
    Rule.fromStrings("\$Minute", "minutes"),
    Rule.fromStrings("\$Minute", "min"),
    Rule.fromStrings("\$Minute", "m"),
    Rule.fromStrings("\$Minute", "mins"),
    Rule.fromStrings("\$Morning", "morning"),
    Rule.fromStrings("\$Noon", "noon"),
    Rule.fromStrings("\$Afternoon", "afternoon"),
    Rule.fromStrings("\$Evening", "evening"),
    Rule.fromStrings("\$Night", "night"),
    Rule.fromStrings("\$Day", "day"),
    Rule.fromStrings("\$Day", "days"),
    Rule.fromStrings("\$Daily", "daily"),
    Rule.fromStrings("\$Week", "week"),
    Rule.fromStrings("\$Week", "weeks"),
    Rule.fromStrings("\$Weekly", "weekly"),
    Rule.fromStrings("\$Month", "month"),
    Rule.fromStrings("\$Month", "months"),
    Rule.fromStrings("\$Monthly", "monthly"),
    Rule.fromStrings("\$Year", "year"),
    Rule.fromStrings("\$Year", "years"),
    Rule.fromStrings("\$Yearly", "yearly"),
    Rule.fromStrings("\$AtBy", "\$At", Semantics.first),
    Rule.fromStrings("\$AtBy", "\$By", Semantics.first),
    Rule.fromStrings(CAT_DATE, "?\$In \$DATE_MONTH", Semantics.last),
    Rule.fromStrings(CAT_DATE, "?\$On ?\$The \$DATE_DAY", Semantics.last),
    Rule.fromStrings(CAT_DATE, "?\$On ?\$The \$DATE_DAY ?\$Of \$DATE_MONTH",
        Semantics.merge),
    Rule.fromStrings(
        CAT_DATE, "?\$On \$DATE_MONTH \$DATE_DAY", Semantics.merge),
    Rule.fromStrings(
        CAT_DATE,
        "?\$On ?\$The \$DATE_DAY ?\$Of \$DATE_MONTH \$DATE_YEAR",
        Semantics.merge),
    Rule.fromStrings(
        CAT_DATE, "?\$On \$DATE_MONTH \$DATE_DAY \$DATE_YEAR", Semantics.merge),
    Rule.fromStrings(CAT_DATE, "\$DATE_ELEMENT ?\$DATE", Semantics.merge),
    Rule.fromStrings(
        "\$DATE_ELEMENT", "?\$In ?\$The \$DATE_SHIFT", Semantics.last),
    Rule.fromStringsWithTemplate("\$DATE_ELEMENT", "?\$AtBy \$NUMBER",
        Semantics.named("hour", Semantics.LAST)),
    Rule.fromStringsWithTemplate(
        "\$DATE_ELEMENT", "?\$AtBy \$Noon", Semantics.named("shift", "noon")),
    Rule.fromStringsWithTemplate(
        "\$DATE_ELEMENT", "?\$AtBy \$Night", Semantics.named("shift", "night")),
    Rule.fromStrings("\$DATE_ELEMENT", "?\$AtBy \$DATE_TIME", Semantics.last),
    Rule.fromStrings("\$DATE_ELEMENT", "\$DATE_OFFSET", Semantics.first),
    Rule.fromStrings("\$DATE_ELEMENT", "?\$On \$DATE_DOW", Semantics.last),
    Rule.fromStrings("\$DATE_ELEMENT", "\$NextDate", Semantics.first),
    Rule.fromStrings("\$DATE_ELEMENT", "\$AfterDuration", Semantics.first),
    Rule.fromStringsWithTemplate("\$NextDate", "\$Next \$Week",
        Semantics.named("offset", Semantics.named("week", 1.0))),
    Rule.fromStringsWithTemplate("\$NextDate", "\$Next \$Day",
        Semantics.named("offset", Semantics.named("day", 1.0))),
    Rule.fromStringsWithTemplate("\$NextDate", "\$Next \$Month",
        Semantics.named("offset", Semantics.named("month", 1.0))),
    Rule.fromStringsWithTemplate("\$NextDate", "\$Next \$Hour",
        Semantics.named("offset", Semantics.named("hour", 1.0))),
    Rule.fromStringsWithTemplate("\$NextDate", "\$Next \$Minute",
        Semantics.named("offset", Semantics.named("minute", 1.0))),
    Rule.fromStringsWithTemplate("\$AfterDuration", "\$After \$DATE_DURATION",
        Semantics.named("offset", Semantics.LAST)),
    Rule.fromStringsWithTemplate("\$AfterDuration", "\$In \$DATE_DURATION",
        Semantics.named("offset", Semantics.LAST)),
    Rule.fromStringsWithTemplate("\$DATE_DURATION", "\$NUMBER \$Second",
        Semantics.named("second", Semantics.FIRST)),
    Rule.fromStringsWithTemplate(
        "\$DATE_DURATION", "\$A \$Second", Semantics.named("second", 1.0)),
    Rule.fromStringsWithTemplate("\$DATE_DURATION", "\$NUMBER \$Minute",
        Semantics.named("minute", Semantics.FIRST)),
    Rule.fromStringsWithTemplate(
        "\$DATE_DURATION", "\$A \$Minute", Semantics.named("minute", 1.0)),
    Rule.fromStringsWithTemplate("\$DATE_DURATION", "\$NUMBER \$Hour",
        Semantics.named("hour", Semantics.FIRST)),
    Rule.fromStringsWithTemplate(
        "\$DATE_DURATION", "\$An \$Hour", Semantics.named("hour", 1.0)),
    Rule.fromStringsWithTemplate("\$DATE_DURATION", "\$NUMBER \$Day",
        Semantics.named("day", Semantics.FIRST)),
    Rule.fromStringsWithTemplate(
        "\$DATE_DURATION", "\$A \$Day", Semantics.named("day", 1.0)),
    Rule.fromStringsWithTemplate("\$DATE_DURATION", "\$NUMBER \$Week",
        Semantics.named("week", Semantics.FIRST)),
    Rule.fromStringsWithTemplate(
        "\$DATE_DURATION", "\$A \$Week", Semantics.named("week", 1.0)),
    Rule.fromStringsWithTemplate("\$DATE_DURATION", "\$NUMBER \$Month",
        Semantics.named("month", Semantics.FIRST)),
    Rule.fromStringsWithTemplate(
        "\$DATE_DURATION", "\$A \$Month", Semantics.named("month", 1.0)),
    Rule.fromStringsWithTemplate("\$DATE_DURATION", "\$NUMBER \$Year",
        Semantics.named("year", Semantics.FIRST)),
    Rule.fromStringsWithTemplate(
        "\$DATE_DURATION", "\$A \$Year", Semantics.named("year", 1.0))
  ];

  Map<String, double> _mapMonths;
  Map<String, double> _mapDow;

  DateTimeAnnotator() {
    _mapMonths = {};
    _mapDow = {};

    for (var i = 0; i < DateTimeAnnotator.MONTHS.length; ++i) {
      _mapMonths[DateTimeAnnotator.MONTHS[i]] = (i % 12) + 1.0;
    }

    for (var i = 0; i < DOW.length; ++i) {
      _mapDow[DateTimeAnnotator.DOW[i]] = (i % 7) + 1.0;
    }
  }

  List<Rule> annotate(List<String> tokens) {
    if (tokens.length == 1) {
      String s = tokens[0].toLowerCase();
      Rule r = _parseMonth(s);
      if (r == null) {
        r = _parseDay(s);
      }
      if (r == null) {
        r = _parseTime(s);
      }

      if (r != null) {
        return [r];
      } else {
        return _parseNumber(s);
      }
    }

    return [];
  }

  Rule _parseMonth(String s) {
    Rule r;

    if (_mapMonths.containsKey(s.toLowerCase())) {
      r = Rule.fromStringsWithTemplate(
          "\$DATE_MONTH", s, Semantics.named("month", _mapMonths[s]));
    }

    return r;
  }

  Rule _parseDay(String s) {
    Rule r;

    if (s == "today") {
      r = Rule.fromStringsWithTemplate("\$DATE_OFFSET", s,
          Semantics.named("offset", Semantics.named("day", 0.0)));
    } else if (s == "tomorrow") {
      r = Rule.fromStringsWithTemplate("\$DATE_OFFSET", s,
          Semantics.named("offset", Semantics.named("day", 1.0)));
    } else if (_mapDow.containsKey(s)) {
      r = Rule.fromStringsWithTemplate(
          "\$DATE_DOW", s, Semantics.named("dow", _mapDow[s]));
    }

    return r;
  }

  List<Rule> _parseNumber(String s) {
    List<Rule> rules = [];

    RegExpMatch m = DateTimeAnnotator.PATTERN_NUMBER.firstMatch(s);

    if (m != null) {
      var val = int.parse(m.group(1));
      if (val >= 1 && val <= 31) {
        rules.add(Rule.fromStringsWithTemplate(
            "\$DATE_DAY", s, Semantics.named("day", val.toDouble())));
      }

      if (val >= 1 && val <= 12) {
        rules.add(Rule.fromStringsWithTemplate(
            "\$DATE_MONTH", s, Semantics.named("month", val.toDouble())));
      }

      if (val >= 1 && val <= 99 || (val >= 1970 && val <= 2100)) {
        rules.add(Rule.fromStringsWithTemplate(
            "\$DATE_YEAR", s, Semantics.named("year", val.toDouble())));
      }

      if (val >= 100 && val <= 1259) {
        var min = val % 100;
        var hr = val / 100;
        Map<String, Object> template = Semantics.named("hour", hr.toDouble());
        if (min > 0) {
          template["minute"] = min.toDouble();
        }
        rules.add(Rule.fromStringsWithTemplate("\$DATE_TIME", s, template));
      }
    }

    return rules;
  }

  Rule _parseTime(String s) {
    Rule rule;

    if (DateTimeAnnotator.SHIFT_MAP.containsKey(s)) {
      rule = Rule.fromStringsWithTemplate("\$DATE_SHIFT", s,
          Semantics.named("shift", DateTimeAnnotator.SHIFT_MAP[s]));
    }

    return rule;
  }
}
