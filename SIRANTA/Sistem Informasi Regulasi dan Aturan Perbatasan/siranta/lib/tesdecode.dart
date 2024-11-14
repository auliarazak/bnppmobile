import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class PdfConverterScreen extends StatefulWidget {
  @override
  _PdfConverterScreenState createState() => _PdfConverterScreenState();
}

class _PdfConverterScreenState extends State<PdfConverterScreen> {
  String? base64String;
  TextEditingController fileNameController = TextEditingController();

  Future<void> convertPdfToBase64() async {
    String? base64 = await PdfToBase64Converter.convertPdfToBase64();
    setState(() {
      base64String = base64;
    });
  }

  Future<void> decodeAndSavePdf() async {
    if (base64String != null && fileNameController.text.isNotEmpty) {
      bool success = await PdfToBase64Converter.saveBase64AsPdf(
        base64String!,
        fileNameController.text,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save PDF.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base64 string or filename is missing.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Base64 Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: convertPdfToBase64,
              child: const Text("Select and Encode PDF to Base64"),
            ),
            const SizedBox(height: 20),
            Text(
              'Length of base64String: ${base64String?.length ?? 0} characters',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fileNameController,
              decoration: const InputDecoration(
                labelText: "Enter filename to save decoded PDF",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: decodeAndSavePdf,
              child: const Text("Decode and Save as PDF"),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfToBase64Converter {
  /// Convert PDF file to Base64 string
  static Future<String?> convertPdfToBase64() async {
    try {
      // Pick PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        // Get file path
        File file = File(result.files.single.path!);

        // Read file as bytes
        List<int> fileBytes = await file.readAsBytes();

        // Convert bytes to base64
        String base64String = base64Encode(fileBytes);

        return base64String;
      }
    } catch (e) {
      print('Error converting PDF to Base64: $e');
    }
    return null;
  }

  /// Convert Base64 string back to PDF file in Downloads directory
  static Future<bool> saveBase64AsPdf(String base64String, String fileName) async {
  try {
    // Decode base64 to bytes
    List<int> pdfBytes = base64Decode(base64String);

    // Get Downloads directory
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    // If the directory is null, show an error and return false
    if (downloadsDir == null || !await downloadsDir.exists()) {
      print('Error: Downloads directory not found');
      return false;
    }

    String filePath = p.join(downloadsDir.path, '$fileName.pdf');

    // Write bytes to file
    await File(filePath).writeAsBytes(pdfBytes);

    return true;
  } catch (e) {
    print('Error saving Base64 as PDF: $e');
    return false;
  }
}

}
