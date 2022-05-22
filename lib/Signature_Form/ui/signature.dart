import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;

class signatureform extends StatefulWidget {
  signatureform({Key? key}) : super(key: key);

  @override
  State<signatureform> createState() => _signatureformState();
}

class _signatureformState extends State<signatureform> {
  GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 10, color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: SfSignaturePad(
                  key: signaturePadKey,
                  backgroundColor: Colors.transparent,
                  strokeColor: Colors.black,
                  minimumStrokeWidth: 2.0,
                  maximumStrokeWidth: 4.0,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Text("Confirmar"),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 40, 144, 214),
                        onPrimary: Colors.white,
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontStyle: FontStyle.italic)),
                    onPressed: () async {
                      ui.Image data = await signaturePadKey.currentState!
                          .toImage(pixelRatio: 2.0);

                      final ByteData =
                          await data.toByteData(format: ui.ImageByteFormat.png);
                      final Uint8List imageBytes = ByteData!.buffer.asUint8List(
                          ByteData.offsetInBytes, ByteData.lengthInBytes);

                      if (kIsWeb) {
                        AnchorElement(
                            href:
                                'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(imageBytes)}')
                          ..setAttribute('download', 'Output.png')
                          ..click();
                      } else {
                        final String path =
                            (await getApplicationSupportDirectory()).path;
                        final String fileName = Platform.isWindows
                            ? '$path\\Output.png'
                            : '$path/Output.png';
                        final File file = File(fileName);
                        await file.writeAsBytes(imageBytes, flush: true);
                        OpenFile.open(fileName);
                      }
                    },
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 40, 144, 214),
                          onPrimary: Colors.white,
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontStyle: FontStyle.italic)),
                      onPressed: () {
                        signaturePadKey.currentState!.clear();
                      },
                      child: Text('Limpiar'))
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              )
            ],
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      )),
    );
  }
}