part of subst;

class Subst {
  final String from;

  final String to;

  Pattern _pattern;

  List<String> _parts;

  List<int> _wildcards;

  Subst(this.from, this.to) {
    if (from == null) {
      throw new ArgumentError("from: $from");
    }

    if (to == null) {
      throw new ArgumentError("to: $to");
    }

    _pattern = _parse(from);
    _wildcards = <int>[];
    _parts = _split(to);
    var length = _parts.length;
    for (var i = 0; i < length; i++) {
      if (_parts[i] == "*") {
        _wildcards.add(i);
      }
    }
  }

  String replace(String text) {
    if (text == null) {
      return null;
    }

    var src = _pattern.matchAsPrefix(text);
    if (src == null) {
      return null;
    }

    var length = _wildcards.length;
    var groupCount = src.groupCount;
    if (groupCount != length) {
      return null;
    }

    var parts = _parts.toList();
    for (var i = 1; i < groupCount + 1; i++) {
      var text = src.group(i);
      var wildcard = _wildcards[i - 1];
      parts[wildcard] = text;
    }

    return parts.join();
  }

  Pattern _parse(String text) {
    var parts = _split(text);
    var sb = new StringBuffer("^");
    for (var part in parts) {
      if (part == "*") {
        sb.write("(.*)");
      } else {
        var length = part.length;
        var temp = new StringBuffer();
        for (var i = 0; i < length; i++) {
          var s = part[i];
          switch (s) {
            case ".":
            case "^":
            case "\$":
            case "+":
            case "?":
            case "(":
            case ")":
            case "[":
            case "]":
            case "{":
            case "}":
            case "\\":
            case "|":
            case "-":
            case "/":
              temp.write("\\$s");
              break;
            default:
              temp.write(s);
          }
        }

        sb.write("(?:$temp)");
      }
    }

    sb.write("\$");
    var source = sb.toString();
    return new RegExp(source);
  }

  List<String> _split(String text) {
    var result = <String>[];
    var parts = text.split("*");
    var length = parts.length;
    for (var i = 0; i < length; i++) {
      var part = parts[i];
      if (i == 0) {
        if (!part.isEmpty) {
          result.add(part);
        }

        if (length > 1) {
          result.add("*");
        }
      } else if (i < length - 1) {
        if (!part.isEmpty) {
          result.add(part);
        }

        result.add("*");
      } else {
        if (!part.isEmpty) {
          result.add(part);
        }
      }
    }

    return result;
  }
}
