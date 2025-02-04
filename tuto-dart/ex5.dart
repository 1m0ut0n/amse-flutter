void main() {
  var listA = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89];
  var listB = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

  var doublons = <int>{};
  for (final elementA in listA) for (final elementB in listB) if (elementA == elementB) doublons.add(elementA);

  print(doublons.toList());
}