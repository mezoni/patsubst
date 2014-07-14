import "package:patsubst/patsubst.dart";
import "package:unittest/unittest.dart";

void main() {
  var subst = new PatSubst("abc/%/%1.c", "baz/%/bar/%2.obj");
  var result = subst.replace("abc/foo/abc1.c");
  expect(result, "baz/foo/bar/abc2.obj");
}
