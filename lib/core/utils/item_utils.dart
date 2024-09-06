String normaliseOption({
  required String chosenOption,
  required Iterable<String> existingValues,
}) {
  final normalisedOption = chosenOption.trim().toLowerCase();

  return existingValues.firstWhere(
      (value) => value.trim().toLowerCase() == normalisedOption,
      orElse: () => chosenOption);
}
