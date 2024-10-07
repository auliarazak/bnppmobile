import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TesPDF extends StatefulWidget {
  const TesPDF({super.key});

  @override
  State<TesPDF> createState() => _TesPDFState();
}

class _TesPDFState extends State<TesPDF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: SfPdfViewer.network(
                'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf')));
  }
}
