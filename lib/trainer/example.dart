import 'dart:convert';

class Example {
  final String input;
  final Map<String, Object> label;

  Example(String input, String json)
      : input = input,
        label = jsonDecode(json);
}
