import "package:patsubst/patsubst.dart";
import "package:unittest/unittest.dart";

void main() {
  var subst = new PatSubst("abc/%/%1.c", "baz/%/bar/%2.obj");
  var result = subst.replace("abc/foo/abc1.c");
  expect(result, "baz/foo/bar/abc2.obj");

  subst = new PatSubst("%.c", "foo.obj");
  result = subst.replace("baz.c");
  expect(result, "foo.obj");

  subst = new PatSubst("%.txt", "%.%.html");
  result = subst.replace("hello.txt");
  expect(result, "hello.%.html");
}
