import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/pdf_services.dart';
import '../model/statement_edu_info_model.dart';
import '../statement_edu_widgets.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 01,April,2023.

class StatementEduService {
  static Future<File> generateStatement(StatementEduInfoModel eduInfo) async {
    final pdf = pw.Document();

    final fcLogoSvg = await rootBundle.loadString('assets/svg_files/ic_first_cash_logo_login.svg');
    String generatedTime = DateFormat('dd-MM-yyyy | hh:mm:ss a').format(DateTime.now());

    debugPrint(generatedTime);

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        StatementEduWidgets.statement(eduInfo, fcLogoSvg, generatedTime),
      ],
    ));

    String fileName = 'FC-${generateFileName()}';
    debugPrint(fileName);

    return PdfServices.saveDocument(name: fileName, pdf: pdf);
  }

  static String generateFileName() {
    final now = DateTime.now();
    final formattedDateTime =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
    final fileName = '$formattedDateTime.pdf';
    return fileName;
  }
}