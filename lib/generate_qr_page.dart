import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRPage extends StatefulWidget {
  const GenerateQRPage({Key? key}) : super(key: key);

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  String qrData = "www.google.com";

  Future<String> createQrPicture(String qr) async {
    final qrValidationResult = QrValidator.validate(
      data: qr,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    final qrCode = qrValidationResult.qrCode!;

    final painter = QrPainter.withQr(
      qr: qrCode,
      color: const Color(0xFF000000),
      emptyColor: Colors.white,
      gapless: true,
      embeddedImageStyle: null,
      embeddedImage: null,
    );

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';

    final picData =
        await painter.toImageData(2048, format: ImageByteFormat.png);
    await writeToFile(picData!, path);

    return path;
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future saveToGallery() async {
    String path = await createQrPicture(qrData);

    final success = await GallerySaver.saveImage(path);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: success!
          ? Text('Image saved to Gallery')
          : Text('Error saving image'),
    ));
  }

  final qrdataFeed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar having title
      appBar: AppBar(
        title: Text("Generate QR Code"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          //Scroll view given to Column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QrImage(data: qrData),
              SizedBox(height: 20),
              Text(
                "Generate QR Code",
                style: TextStyle(fontSize: 20),
              ),

              //TextField for input link
              TextField(
                controller: qrdataFeed,
                decoration:
                    InputDecoration(hintText: "Enter your link here..."),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                //Button for generating QR code
                child: ElevatedButton(
                  onPressed: () async {
                    //a little validation for the textfield
                    if (qrdataFeed.text.isEmpty) {
                      setState(() {
                        qrData = "";
                      });
                    } else {
                      setState(() {
                        qrData = qrdataFeed.text;
                      });
                    }
                  },
                  //Title given on Button
                  child: Text(
                    "Generate QR Code",
                    style: TextStyle(
                      color: Colors.indigo[900],
                    ),
                  ),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  //   side: BorderSide(color: Colors.indigo[900]),
                  // ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    saveToGallery();
                  },
                  child: Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
}
