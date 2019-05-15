import 'dart:typed_data';

class Utils {
  List<int> xOrBytes(List<int> bytes) {
    // sanity check if the given parameter is no Uint8List
    if (bytes is Uint8List) {
      List<int> bytesList = List<int>();
      bytesList.addAll(bytes);
      bytes = bytesList;
    }
    bytes.insert(0, 0);
    bytes.add(0);
    bytes = bytes.map((byte) => byte ^= 0x2B).toList();
    return bytes;
  }

  List<int> largeIntToUint8List(int i, int length) {
    // create byte buffers
    var buffer = new Uint8List(length).buffer;
    var bdata = new ByteData.view(buffer);

    // insert Uint16 into buffer
    bdata.setUint16(0, i);

    // iterate over buffer and receive all Uint8
    List<int> bytes = List<int>();
    // Note: must be in reversed?
    for (var i = length-1; i >= 0; i--) {
      bytes.add(bdata.getUint8(i));
    }
    return bytes;
  }


}