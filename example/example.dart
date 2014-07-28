import "package:patsubst/patsubst.dart";

void main() {
  var subst = patsubst("foo/%/%1.cc", "wow/%/with/kara_%2.obj");
  var source = "foo/bar/baz1.cc";
  var result = subst.replace(source);
  print("$source => $result");
  // foo/bar/baz1.cc => wow/bar/with/kara_baz2.obj
}
