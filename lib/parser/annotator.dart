import 'package:easy_nlu/parser/rule.dart';

mixin Annotator {
  List<Rule> annotate(List<String> tokens);
}
