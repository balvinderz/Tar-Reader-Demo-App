import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:tarreadersampleapp/tar_info.dart';
import 'package:tarreadersampleapp/tar_reader.dart';

void main() {
  runApp(TarReaderDemo());
}

class TarReaderDemo extends StatefulWidget {
  @override
  _TarReaderDemoState createState() => _TarReaderDemoState();
}

class _TarReaderDemoState extends State<TarReaderDemo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tar Reader Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Tar Reader Demo"),
        ),
        body: FutureBuilder(
          future: rootBundle.load("assets/images.tar.gz"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              ByteData data = snapshot.data;
              Uint8List content = data.buffer.asUint8List();
              print(content);
              TarReader tarReader = TarReader();
              tarReader.loadFromBytes(content);
              List<TarInfo> namesOfFiles = tarReader.readMembers();
              List<Widget> listTiles = namesOfFiles
                  .map((file) => ListTile(
                        leading: Icon(Icons.insert_drive_file),
                        title: Text(file.name),
                        onTap:  (){
                          if(isImage(file.name))
                            {
                              print("idhar aaya mai");
                              showDialog(context: context,
                              barrierDismissible: true,
                                builder: (context)=> Dialog(
                                  child: Image.memory(file.fileContents),
                                )
                              );
                            }
                          else
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Not Supported Right Now",style: TextStyle(
                              color: Colors.white
                            ),),backgroundColor: Colors.red,));
              },
                      ))
                  .toList();
              tarReader.closeTarFile();
              return ListView(children: listTiles);
            } else
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
          },
        ),
      ),
    );
  }
  bool isImage(String fileName)
  {
    fileName= fileName.toLowerCase();
    if(fileName.endsWith("png") || fileName.endsWith("jpeg") || fileName.endsWith("jpg"))
      return true;
    return false;
  }
}
