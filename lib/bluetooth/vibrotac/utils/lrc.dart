class LRC {

  int calculateLRC(List<int> bytes) {
    var lrc = 0;
    for (var byte in bytes) {
      lrc = (lrc + byte) & 0xFF;
    }
    lrc = ((lrc ^ 0xFF) + 1) & 0xFF;
    return lrc;
  }

  List<int> calculateAndAddLRC(List<int> bytes) {
    bytes.add(calculateLRC(bytes));
    return bytes;
  }
}