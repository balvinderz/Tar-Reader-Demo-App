import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:tarreadersampleapp/tar_info.dart';
import 'package:tarreadersampleapp/tar_utils.dart';

import 'tar_headers_constants.dart' as TarHeadersConstants;
class TarReader{
  int _filePointer = 0;
  String path = "";
  bool _loaded = false;
  RandomAccessFile tarFile;

  List<TarInfo> memberNames=[];
  File f;

  Uint8List _fileContents;
  void loadFromBytes(Uint8List bytes) // can't get assets folder directly so had to use the bytes directly
  {
    this._fileContents = bytes;
  }
  Future<bool> loadFromFile(String path) async
  {
    try {

      f= File(path);
      tarFile =await  f.open();
      _fileContents = await f.readAsBytes();
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
  List<TarInfo> readMembers(){
    try{
      while(true)
        {
          TarInfo member = next(); // TODO Make it return TarFileObject
          print(member);
          memberNames.add(member);

        }
    }catch(e)
    {
      print(e);
    }
    return memberNames;
  }

  TarInfo next() {
    final subList  = _fileContents.sublist(_filePointer,_filePointer+TarHeadersConstants.BLOCKSIZE);
    String nameOfFile = utf8.decode(subList.sublist(TarHeadersConstants.nameOffset,TarHeadersConstants.nameOffset+TarHeadersConstants.nameBytes)).replaceAll("\x00", "");
    int size = octToDecimal(int.parse(utf8.decode(subList.sublist(TarHeadersConstants.sizeOffset,TarHeadersConstants.sizeOffset+TarHeadersConstants.sizeBytes))));
    Uint8List tarFileContent = _fileContents.sublist(_filePointer+TarHeadersConstants.BLOCKSIZE,_filePointer+TarHeadersConstants.BLOCKSIZE+size);
      TarInfo currentFile = TarInfo(name: nameOfFile,size: size,fileContents: tarFileContent);
    _filePointer+=TarHeadersConstants.BLOCKSIZE+size;
    if(_filePointer%TarHeadersConstants.BLOCKSIZE!=0)
      _filePointer=_filePointer-_filePointer%TarHeadersConstants.BLOCKSIZE+TarHeadersConstants.BLOCKSIZE;
    //print(_filePointer);
    return currentFile;
  }

}
