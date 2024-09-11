String normaliseOption({
  required String chosenOption,
  required Iterable<String> existingValues,
}) {
  final trimmedOption = chosenOption.trim();
  final normalisedOption = trimmedOption.toLowerCase();

  return existingValues.firstWhere(
      (value) => value.trim().toLowerCase() == normalisedOption,
      orElse: () => trimmedOption);
}
