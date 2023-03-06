class LoggerUtil {
  /// Checks whether two lists of strings have common words.
  ///
  /// Compares each string in the first list ([list1]) with every string in the second list ([list2]) and
  /// returns true if any words are found in both lists. The comparison is case-insensitive. If either
  /// [list1] or [list2] is `null`, this method throws a [TypeError].
  ///
  /// Example:
  ///
  /// ```dart
  /// final list1 = ['apple', 'banana', 'cherry'];
  /// final list2 = ['cherry', 'durian', 'apple'];
  /// final result = haveCommonWords(list1, list2);
  ///
  /// print(result); // Output: true
  /// ```
  ///
  /// Returns true if any words are found in both lists, false otherwise.
  bool haveCommonWords(List<String> list1, List<String> list2) {
    for (String word1 in list1) {
      for (String word2 in list2) {
        if (word1.toLowerCase() == word2.toLowerCase()) {
          return true;
        }
      }
    }
    return false;
  }
}
