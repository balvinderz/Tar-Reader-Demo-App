import 'dart:typed_data';

class TarInfo{
  // Incomplete Implementation and may change
  final String name;
  final int size;
  final Uint8List fileContents;
  TarInfo({this.name,this.size,this.fileContents});
}