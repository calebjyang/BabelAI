List<String>parseInput(String input)
{
  RegExp regex = RegExp('"([^"]*)"');
  List<String> rtnval = [];
  Iterable<Match> matches = regex.allMatches(input);

  for(Match match in matches)
    rtnval.add(match.group(1)!);

  return rtnval;
}