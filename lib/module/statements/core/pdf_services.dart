import 'dart:io';

import 'package:better_open_file/better_open_file.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 01,April,2023.

class PdfServices {
  static Future<File> saveDocument(
      {required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    try {
      await DocumentFileSavePlus()
          .saveFile(bytes.buffer.asUint8List(), name, "appliation/pdf");
    } catch (e) {
      debugPrint('cant save pdf on this device!');
    }

    return file;
  }

  static Future openFile(File file) async {
    debugPrint('opening ');
    final url = file.path;
    await OpenFile.open(url);
  }
}
