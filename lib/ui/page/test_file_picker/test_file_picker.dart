// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class TestFilePicker extends StatefulWidget {
  const TestFilePicker({super.key});

  @override
  State<TestFilePicker> createState() => _TestFilePickerState();
}

class _TestFilePickerState extends State<TestFilePicker> {
  List<String> headers = [];
  List<List<String>> excelData = [];

  Future<void> pickAndReadExcelFile() async {
    try {
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // Read file
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            List<String> rowData = [];
            for (var cell in row) {
              rowData.add(cell?.value.toString() ?? '');
            }
            if (headers.isEmpty) {
              headers = rowData;
            } else {
              excelData.add(rowData);
            }
          }
        }

        setState(() {});
      }
    } catch (e) {
      debugPrint('Error picking or reading Excel file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel File Picker'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: pickAndReadExcelFile,
            child: const Text('Pick Excel File'),
          ),
          Expanded(
            child: excelData.isEmpty
                ? const Center(child: Text('No data loaded'))
                : SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.blue),
                      headingTextStyle: const TextStyle(color: Colors.white),
                      columns: List<DataColumn>.generate(
                        headers.isNotEmpty ? headers.length : 0,
                        (index) => DataColumn(
                          label: Text(headers[index]),
                        ),
                      ),
                      rows: excelData.map((row) {
                        return DataRow(
                          cells: row.map((cell) {
                            return DataCell(Text(cell.toString()));
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
