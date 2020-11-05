List<String> extractTags(String post) {
  List<String> tags = [];
  RegExp exp = new RegExp(r"\B(\#[a-zA-Z]+\b)(?!;)");

  Iterable<Match> matches = exp.allMatches(post);
  if (matches == null) {
    return null;
  }
  for (Match m in matches) {
    String match = m.group(0);
    tags.add(match);
  }

  return tags;
}
