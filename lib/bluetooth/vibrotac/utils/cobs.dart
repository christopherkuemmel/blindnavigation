class COBS {
  List<int> encode(List<int> bytes) {

    if (bytes.length > 254) {
      throw RangeError.range(bytes.length, 1, 254);
    }

    List<int> result = List<int>();
    int distanceIndex = 0;
    int byteDistance = 1;

    for (var byte in bytes) {
      if (byte == 0) {
        result.insert(distanceIndex, byteDistance);
        distanceIndex = result.length;
        byteDistance = 1;
      } else {
        result.add(byte);
        byteDistance++;

        if (byteDistance == 0xFF) {
          result.insert(distanceIndex, byteDistance);
          distanceIndex = result.length;
          byteDistance = 1;
        }
      }
    }

    if (result.length != 255 && result.length > 0) {
      result.insert(distanceIndex, byteDistance);
    }

    return result;
  }
}