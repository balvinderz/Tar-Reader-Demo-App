import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:tarreadersampleapp/tar_utils.dart';

import 'tar_headers_constants.dart' as TarHeadersConstants;
import 'package:tarreadersampleapp/tar_headers_constants.dart';
class TarReader{
  int _filePointer = 0;
  String path = "";
  bool _loaded = false;
  RandomAccessFile tarFile;

  List<String> memberNames=[];
  File f;

  Uint8List fileContents;
  void loadFromBytes(Uint8List bytes) // can't get assets folder directly so had to use the bytes directly
  {
    this.fileContents = bytes;
  }
  Future<bool> loadFromFile(String path) async
  {
    try {

      f= File(path);
      tarFile =await  f.open();
      fileContents = await f.readAsBytes();
      _loaded = true;
          return true;
    }
    catch(e)
    {
      return false;
    }
  }
  void closeTarFile() {
    if (_loaded) {
      _loaded = false;
      if(tarFile!=null)
      tarFile.close();

      tarFile = null;
      memberNames = [];
      _filePointer=0;
    }

  }
  List<String> readMembers(){
    try{
      while(true)
        {
          String member = next(); // TODO Make it return TarFileObject
          print(member);
          memberNames.add(member);

        }
    }catch(e)
    {
      print(e);
    }
    return memberNames;
  }

  String next() {
    final subList  = fileContents.sublist(_filePointer,_filePointer+512);
    String nameOfFile = utf8.decode(subList.sublist(TarHeadersConstants.nameOffset,TarHeadersConstants.nameOffset+TarHeadersConstants.nameBytes));
    int size = octToDecimal(int.parse(utf8.decode(subList.sublist(TarHeadersConstants.sizeOffset,TarHeadersConstants.sizeOffset+TarHeadersConstants.sizeBytes))));
    _filePointer+=512+size;
    if(_filePointer%512!=0)
      _filePointer=_filePointer-_filePointer%512+512;
    //print(_filePointer);
    return nameOfFile;
  }

}
