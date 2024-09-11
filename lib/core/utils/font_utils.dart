/// Adjusts the font size based on the number of characters in the given text.
///
/// The font size is calculated by starting with a maximum font size and
/// reducing it based on the number of characters in the text. The reduction
/// is controlled by a scaling factor and an optional offset.
///
/// Parameters:
/// - [text]: The text whose length determines the font size. The length of this
///   string is used to calculate the adjusted font size.
/// - [maxFontSize]: The starting font size used when the number of characters
///   is less than or equal to [fontAdjustOffset]. This represents the maximum
///   font size the text can have.
/// - [fontAdjustOffset]: The number of characters at which the scaling starts.
///   If the number of characters is less than or equal to this value, the font size
///   will be [maxFontSize]. Defaults to 1.
/// - [minFontSize]: The smallest font size that the function will return, even if
///   the calculated size is lower. Defaults to 1.0.
/// - [scaleFactor]: The amount by which the font size decreases for each character
///   beyond [fontAdjustOffset]. This controls how quickly the font size scales down.
///   Defaults to 1.0.
///
/// Returns:
/// A [double] representing the adjusted font size, which is clamped between
/// [minFontSize] and [maxFontSize].
double getAdjustedFontSizeByCharacters({
  required String text,
  required double maxFontSize,
  int fontAdjustOffset = 1,
  double minFontSize = 1.0,
  double scaleFactor = 1.0,
}) {
  // Calculate adjusted font size by scaling down with the number of characters
  final adjustedFontSize =
      maxFontSize - (text.length - fontAdjustOffset) * scaleFactor;

  // Ensure that font size does not go below the minimum or above the maximum
  return adjustedFontSize.clamp(minFontSize, maxFontSize);
}
