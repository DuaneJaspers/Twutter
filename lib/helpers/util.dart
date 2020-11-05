List<String> extractTags(String postContent) {
  List<String> tags = [];
  RegExp exp = new RegExp(r"\B(\#[a-zA-Z]+\b)(?!;)");

  Iterable<Match> matches = exp.allMatches(postContent);
  if (matches == null) {
    return null;
  }
  for (Match m in matches) {
    String match = m.group(0);
    tags.add(match);
  }

  return tags;
}
