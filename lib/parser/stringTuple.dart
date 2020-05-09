import 'dart:collection';

class StringTuple extends ListBase<String> {
  List<String> _items;
  String _repr;

  StringTuple(String s) {
    _repr = s;
    _items = _stringToItems(s);
  }

  StringTuple.withList(String s, List<String> items) {
    _repr = s;
    _items = items;
  }

  factory StringTuple.fromList(List<String> parts) {
    String repr = parts.join(" ");
    return StringTuple.withList(repr, parts);
  }

  static List<String> _stringToItems(String s) {
    return s.split(" ");
  }

  set length(int newLength) {}
  int get length => _items.length;
  String operator [](int index) => _items[index];
  void operator []=(int index, String value) {
    List<String> copy = _stringToItems(_repr);
    copy[index] = value;
    String modifiedRepr = copy.join(" ");

    _repr = modifiedRepr;
    _items = copy;
  }

  String toString() {
    return _repr;
  }
}
