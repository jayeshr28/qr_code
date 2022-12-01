import 'package:flutter/material.dart';
import 'package:qr_code/generate_qr_page.dart';
import 'package:qr_code/scan_qr_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        //Display Image
        Image(
            image: NetworkImage(
                "https://cdn.dribbble.com/users/1398774/screenshots/3658825/media/56562cd1ae32d32720357ae2d5bc949c.jpg")),

        SizedBox(
          height: 50,
        ),
        //First Button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ScanQRPage()));
          },
          child: Text(
            "Scan QR Code",
            style: TextStyle(color: Colors.indigo[900]),
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   side: BorderSide(color: Colors.indigo[900]),
          // ),
        ),
        SizedBox(height: 10),

        //Second Button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GenerateQRPage()));
          },
          child: Text(
            "Generate QR Code",
            style: TextStyle(color: Colors.indigo[900]),
          ),
        ),
      ],
    ));
  }
}
