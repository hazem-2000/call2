import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class PP extends StatefulWidget {
  const PP({Key? key}) : super(key: key);

  @override
  State<PP> createState() => _PPState();
}

class _PPState extends State<PP> {

  final pdf=pw.Document();
  pdfCreation()async{

    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(

      pw.Page(
        build: (pw.Context context){
          return pw.Column(

            children: [
              pw.Text('company name',style: pw.TextStyle(font: font,fontSize: 50)),
              pw.Divider(),

            ],
          );

        },
        pageFormat: PdfPageFormat.a4,
      ),

    );

    var output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    OpenFile.open('${output.path}/example.pdf');
    //file.writeAsBytesSync(pdf.save());
    file.writeAsBytesSync(await pdf.save());



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: TextButton(
        onPressed: (){
          pdfCreation();

        },
        child: Text('hhhh'),
      )),
    );
  }
}
