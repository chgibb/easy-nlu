import 'package:easy_nlu/trainer/dataset.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("", () async {
      Dataset dataset = Dataset.fromText("""
      call John tomorrow morning	{"task":"call John", "startTime":{"offset": {"day":1}, "shift":"morning"}}
      call John in the morning tomorrow	{"task":"call John", "startTime":{"offset": {"day":1}, "shift":"morning"}}
call John next day morning	{"task":"call John", "startTime":{"offset": {"day":1}, "shift":"morning"}}
call John tomorrow in the morning	{"task":"call John", "startTime":{"offset": {"day":1}, "shift":"morning"}}
get milk and bread at 7	{"task":"get milk and bread", "startTime":{"hour":7}}
      """);

      expect(dataset.examples[0].input, "call John tomorrow morning");
      expect(dataset.examples[0].label, {
        "task": "call John",
        "startTime": {
          "offset": {"day": 1},
          "shift": "morning"
        }
      });

      expect(dataset.examples[1].input, "call John in the morning tomorrow");
      expect(dataset.examples[1].label, {
        "task": "call John",
        "startTime": {
          "offset": {"day": 1},
          "shift": "morning"
        }
      });

      expect(dataset.examples[2].input, "call John next day morning");
      expect(dataset.examples[2].label, {
        "task": "call John",
        "startTime": {
          "offset": {"day": 1},
          "shift": "morning"
        }
      });

      expect(dataset.examples[3].input, "call John tomorrow in the morning");
      expect(dataset.examples[3].label, {
        "task": "call John",
        "startTime": {
          "offset": {"day": 1},
          "shift": "morning"
        }
      });

      expect(dataset.examples[4].input, "get milk and bread at 7");
      expect(dataset.examples[4].label, {
        "task": "get milk and bread",
        "startTime": {"hour": 7}
      });
    });
  });
}
