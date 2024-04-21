List<String> parseInput(String input) {
  RegExp regex = RegExp('"([^"]*)"');
  List<String> rtnval = [];
  Iterable<Match> matches = regex.allMatches(input);

  for (Match match in matches) rtnval.add(match.group(1)!);

  return rtnval;
}

List<String> parseThree(String input) {
  List<String> result = [];
  List<String> lines = input.split('\n');

  for (int i = 0; i < lines.length; i++) {
    List<String> parts = lines[i].split(':');
    result
        .add(parts[0].trim().replaceAll('*', '')); // Add the word in asterisks

    if (parts.length > 1) {
      result.add(parts[1].trim()); // Add the rest of the sentence
    } else {
      if (i + 1 < lines.length) {
        result
            .add(lines[i + 1].trim()); // If there's no colon, add the next line
      }
    }
  }
  return result;
}
