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
    return StringTuple.withList(repr, List.from(parts));
  }

  static List<String> _stringToItems(String s) {
    return s.split(" ");
  }

  String getItem(int index) {
    return _items[index];
  }

  StringTuple modify(int index, String Function(String) modifier) {
    List<String> copy = _stringToItems(_repr);

    copy[index] = modifier(_items[index]);

    String modifiedRepr = copy.join(" ");

    return StringTuple.withList(modifiedRepr, copy);
  }

  StringTuple removeItem(int index) {
    List<String> copy = _stringToItems(_repr);

    copy.removeAt(index);

    String modifiedRepr = copy.join(" ");

    return StringTuple.withList(modifiedRepr, copy);
  }

  StringTuple insertItem(int index, String value) {
    List<String> copy = _stringToItems(_repr);

    copy.insert(0, value);

    String modifiedRepr = copy.join(" ");

    return StringTuple.withList(modifiedRepr, copy);
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

  bool operator ==(Object o) => o is StringTuple ? _repr == o._repr : false;
  int get hashCode => _repr.hashCode;

  String toString() {
    return _repr;
  }
}
