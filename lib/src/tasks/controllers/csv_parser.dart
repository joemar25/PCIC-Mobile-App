// src/tasks/controllers/csv_parser.dart
import 'package:csv/csv.dart';

class CSVParser {
  static const List<String> ppirColumns = [
    'Task Number',
    'Service Group',
    'Service Type',
    'Priority',
    'Task Status',
    'Assignee',
    'ppir_assignmentid',
    'ppir_insuranceid',
    'ppir_farmername',
    'ppir_address',
    'ppir_farmertype',
    'ppir_mobileno',
    'ppir_groupname',
    'ppir_groupaddress',
    'ppir_lendername',
    'ppir_lenderaddress',
    'ppir_cicno',
    'ppir_farmloc',
    'ppir_north',
    'ppir_south',
    'ppir_east',
    'ppir_west',
    'ppir_att_1',
    'ppir_att_2',
    'ppir_att_3',
    'ppir_att_4',
    'ppir_area_aci',
    'ppir_area_act',
    'ppir_dopds_aci',
    'ppir_dopds_act',
    'ppir_doptp_aci',
    'ppir_doptp_act',
    'ppir_svp_aci',
    'ppir_svp_act',
    'ppir_variety',
    'ppir_stagecrop',
    'ppir_remarks',
    'ppir_name_insured',
    'ppir_name_iuia',
    'ppir_sig_insured',
    'ppir_sig_iuia'
  ];

  static bool isPPIR(List<dynamic> headers) {
    return headers.every((header) => ppirColumns.contains(header));
  }

  static List<Map<String, dynamic>> parseCSV(String csvContent) {
    final List<List<dynamic>> csvData =
        const CsvToListConverter().convert(csvContent);

    if (csvData.isEmpty) {
      return [];
    }

    final headers = csvData[0].map((header) => header.toString()).toList();
    final isPpir = isPPIR(headers);

    final data = csvData.sublist(1).map((row) {
      final rowData = Map<String, dynamic>.fromIterables(headers, row);
      rowData['isPPIR'] = isPpir;
      return rowData;
    }).toList();

    return data;
  }
}
