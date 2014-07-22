part of patsubst;

/**
 * String pattern substitution.
 */
class PatSubst {
  /**
   * Input pattern.
   */
  final String pattern;

  /**
   * Replacement pattern.
   */
  final String replacement;

  RegExp _expression;

  List<String> _parts;

  List<int> _wildcards;

  PatSubst(this.pattern, this.replacement) {
    if (pattern == null) {
      throw new ArgumentError("pattern: $pattern");
    }

    if (replacement == null) {
      throw new ArgumentError("replacement: $replacement");
    }

    _expression = _parse(pattern);
    _wildcards = <int>[];
    _parts = _split(replacement);
    var length = _parts.length;
    for (var i = 0; i < length; i++) {
      if (_parts[i] == "%") {
        _wildcards.add(i);
      }
    }
  }

  String replace(String string) {
    if (string == null) {
      return null;
    }

    var src = _expression.matchAsPrefix(string);
    if (src == null) {
      return null;
    }

    var length = _wildcards.length;
    var count = src.groupCount;
    if (count > length) {
      count = length;
    }

    var parts = _parts.toList();
    for (var i = 1; i < count + 1; i++) {
      var text = src.group(i);
      var wildcard = _wildcards[i - 1];
      parts[wildcard] = text;
    }

    return parts.join();
  }

  List<String> replaceAll(Iterable<String> strings) {
    if (strings == null) {
      return null;
    }

    var result = <String>[];
    for (var string in strings) {
      result.add(replace(string));
    }

    return result;
  }

  RegExp _parse(String text) {
    var parts = _split(text);
    var sb = new StringBuffer("^");
    for (var part in parts) {
      if (part == "%") {
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
    var parts = text.split("%");
    var length = parts.length;
    for (var i = 0; i < length; i++) {
      var part = parts[i];
      if (i == 0) {
        if (!part.isEmpty) {
          result.add(part);
        }

        if (length > 1) {
          result.add("%");
        }
      } else if (i < length - 1) {
        if (!part.isEmpty) {
          result.add(part);
        }

        result.add("%");
      } else {
        if (!part.isEmpty) {
          result.add(part);
        }
      }
    }

    return result;
  }
}
