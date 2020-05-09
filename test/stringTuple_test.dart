import 'package:easy_nlu/parser/stringTuple.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("", () {
    test("test modification", () async {
      StringTuple s = StringTuple("1 2 3");
      StringTuple changed = s.modify(1, (s) => "4");

      expect(changed, StringTuple("1 4 3"));
      expect(changed, isNot(s));
    });

    test("test removal", () async {
      StringTuple s = StringTuple("1 2 3");
      StringTuple changed = s.removeItem(0);

      expect(changed, StringTuple("2 3"));
      expect(changed, isNot(s));
    });

    test("test insertion", () async {
      StringTuple s = StringTuple("2 3");
      StringTuple changed = s.insertItem(0, "X");

      expect(changed, StringTuple("X 2 3"));
      expect(changed, isNot(s));
    });

    test("test hashing", () async {
      Map<StringTuple, String> map = {StringTuple("A B C"): "Test"};

      expect(map.containsKey(StringTuple("A B C")), true);
    });

    test("test hashing single", () async {
      Map<StringTuple, String> map = {StringTuple("A"): "Test"};

      expect(map.containsKey(StringTuple("A")), true);
    });
  });
}
