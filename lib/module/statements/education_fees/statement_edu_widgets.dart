import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'model/statement_edu_info_model.dart';

/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 31,March,2023.

class StatementEduWidgets {
  static pw.Widget statement(StatementEduInfoModel eduInfo, String fcLogoSvg, String generatedTime) =>
      pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                children: [
                  pw.Text('RECEIPT', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(eduInfo.title!, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.normal)),
                  pw.Text("Generated : $generatedTime"),
                ],
                crossAxisAlignment: pw.CrossAxisAlignment.start,
              ),
              pw.SvgImage(svg: fcLogoSvg, height: 100, width: 100),
            ],
          ),

          pw.Container(height: 20),
          pw.Divider(
            height: 1,
            borderStyle: pw.BorderStyle.dashed,
          ),

          pw.Container(height: 20),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    child: pw.Text(
                      'Transaction Details',
                      textAlign: pw.TextAlign.center,
                    ),
                    padding: const pw.EdgeInsets.all(20),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Expanded(
                    child: paddedText('Institute'),
                    flex: 2,
                  ),
                  pw.Expanded(
                    child: paddedText(eduInfo.insName ?? 'test ins'),
                    flex: 1,
                  )
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Expanded(
                    child: paddedText('Student Name'),
                    flex: 2,
                  ),
                  pw.Expanded(
                    child: paddedText(eduInfo.studentName ?? 'test student'),
                    flex: 1,
                  )
                ],
              ),
              pw.TableRow(
                children: [
                  paddedText('Registration ID', align: TextAlign.right),
                  paddedText(eduInfo.regId ?? 'test reg id'),
                ],
              ),
              pw.TableRow(
                children: [
                  paddedText('Amount', align: TextAlign.right),
                  paddedText(eduInfo.amount!)
                ],
              ),
              pw.TableRow(
                children: [
                  paddedText('Charge', align: TextAlign.right),
                  paddedText(eduInfo.charge!)
                ],
              ),

              pw.TableRow(
                children: [
                  paddedText('TxID', align: TextAlign.right),
                  paddedText(eduInfo.txnId!)
                ],
              )
            ],
          ),
          pw.Container(height: 20),
          pw.Divider(
            height: 1,
            borderStyle: pw.BorderStyle.dashed,
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Text(
              'This receipt has been generated electronically',
              textAlign: pw.TextAlign.center,
            ),
          )
        ],
      );

  static pw.Padding paddedText(
    final String text, {
    final TextAlign align = TextAlign.left,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(10),
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.left,
        ),
      );
}


