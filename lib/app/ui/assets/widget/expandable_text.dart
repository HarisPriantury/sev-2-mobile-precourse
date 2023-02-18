class ExpandableText {
  String text;
  late String _fullText;
  late String _collapsedText;
  final int charLimit;
  final String delimiter;
  final bool isCollapsedAtStart;

  bool isCollapsed = false;
  bool isAbleToExpand = true;

  ExpandableText(
    this.text, {
    required this.charLimit,
    this.delimiter = "...",
    this.isCollapsedAtStart = true,
  }) {
    _fullText = text;
    _collapsedText = _collapseString();
    if (isCollapsedAtStart) {
      collapse();
    }
    if (text.length < charLimit) {
      isAbleToExpand = false;
    }
  }

  void expand() {
    text = _fullText;
    isCollapsed = false;
  }

  void collapse() {
    text = _collapsedText;
    isCollapsed = true;
  }

  String _collapseString() {
    if (text.length > charLimit) {
      String _temp = text.substring(0, charLimit);
      return "$_temp $delimiter";
    } else {
      return text;
    }
  }
}
