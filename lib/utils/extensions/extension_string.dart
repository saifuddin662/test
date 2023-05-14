extension StringExtensions on String {
  String replaceWhiteSpaceWith_() {
    return replaceAll(' ', '_');
  }

  String processAppVersion() {
    return replaceAll('.', '');
  }
}