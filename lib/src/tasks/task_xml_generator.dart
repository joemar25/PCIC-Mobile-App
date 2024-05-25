import 'package:xml/xml.dart';

Future<String> generateTaskXmlContent(
    String taskId, Map<String, dynamic> formData) async {
  final builder = XmlBuilder();

  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('TaskArchiveZipModel', nest: () {
    builder.attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
    builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');

    builder.element('AgentId', nest: () {
      builder.attribute('xsi:nil', 'true');
    });

    builder.element('AssignedDate',
        nest: formData['trackDatetime']?.toString() ?? '');

    builder.element('Attachments', nest: '');

    builder.element('AuditLogs', nest: () {
      // Task Status Audit Log
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Label', nest: 'Task Status');
        builder.element('Message', nest: formData['status'] ?? '');
        builder.element('SnapshotValue', nest: formData['status'] ?? '');
        builder.element('Source', nest: formData['assigneeId'] ?? '');
        builder.element('TaskId', nest: taskId);
        builder.element('Timestamp',
            nest: formData['trackDatetime']?.toString() ?? '');
        builder.element('UpdatedValue', nest: formData['status'] ?? '');
        builder.element('FieldLabel', nest: 'Task Status');
        builder.element('IPAddress', nest: '');
      });

      // Captured Mobile Location Audit Logs
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Captured Mobile Location');
        builder.element('Source', nest: formData['assigneeId'] ?? '');
        builder.element('TaskId', nest: taskId);
        builder.element('Timestamp',
            nest: formData['trackDatetime']?.toString() ?? '');
        builder.element('UpdatedValue', nest: formData['trackLastcoord'] ?? '');
        builder.element('FieldLabel', nest: 'Captured Mobile Location');
        builder.element('IPAddress', nest: '');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Captured Mobile Location');
        builder.element('SnapshotValue',
            nest: formData['trackLastcoord'] ?? '');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: taskId);
        builder.element('Timestamp',
            nest: formData['trackDatetime']?.toString() ?? '');
        builder.element('UpdatedValue', nest: formData['ppirFarmLoc'] ?? '');
        builder.element('FieldLabel', nest: 'Captured Mobile Location');
        builder.element('IPAddress', nest: '');
      });

      // UpdatePostPlanting script Audit Log
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: taskId);
        builder.element('Timestamp',
            nest: formData['trackDatetime']?.toString() ?? '');
      });

      // moo mooo
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Actual');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp',
            nest: formData['trackDatetime']?.toString() ?? '');
        builder.element('UpdatedValue', nest: '0.2500');
        builder.element('FieldId', nest: formData['ppirAreaAct'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Actual');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      // aa
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Region');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp',
            nest: formData['trackDatetime']?.toString() ?? '');
        builder.element('UpdatedValue', nest: 'Region 99');
        builder.element('FieldId', nest: formData['ppirRegion'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Region');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      // aa
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:02.4373782Z');
      });

      // aa
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Actual - Date of Planting (DS)');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:11.671Z');
        builder.element('UpdatedValue', nest: '023-10-25');
        builder.element('FieldId', nest: formData['ppirDopdsAct'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Actual - Date of Planting (DS)');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      // aa
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Actual - Date of Planting (TP)');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:11.671Z');
        builder.element('UpdatedValue', nest: '2023-10-24');
        builder.element('FieldId', nest: formData['ppirDoptpAct'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Actual - Date of Planting (TP)');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      // aa
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Seed Variety Planted - Corn/Rice');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:11.671Z');
        builder.element('UpdatedValue', nest: 'Rice');
        builder.element('FieldId', nest: formData['ppirSvpAct'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Seed Variety Planted - Corn/Rice');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      // aa
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:16.702754Z');
      });

      // aa
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Variety');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:21.86Z');
        builder.element('UpdatedValue', nest: 'RICE-NSIC RC104 (BALILI)');
        builder.element('FieldId', nest: formData['ppirVariety'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Variety');
        builder.element('IPAddress', nest: '172.31.6.165');
      });
      builder.element('Label',
          nest:
              'PPIR - Post Planting Inspection Report &gt; Stage of Crop ATV');
      // aa
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Stage of Crop ATV');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:21.86Z');
        builder.element('UpdatedValue', nest: 'RICE-DOUGH STG. (MATURITY)');
        builder.element('FieldId', nest: formData['ppir_stagecrop'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldId', nest: 'Stage of Crop ATV');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:28.7517927Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Full Name:');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:27.52Z');
        builder.element('UpdatedValue', nest: 'F');
        builder.element('FieldId', nest: formData['ppirNameInsured'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Full Name:');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Signature: (Insured)');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:27.52Z');
        builder.element('UpdatedValue',
            nest: '{"events":[],"attemptCount":0,"duration":0}');
        builder.element('FieldId', nest: formData['ppirSigInsured'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Signature: (Insured)');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:40.5418779Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Signature: (Insured)');
        builder.element('SnapshotValue',
            nest: '{"events":[],"attemptCount":0,"duration":0}');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:29.743Z');
        builder.element('UpdatedValue',
            nest:
                '{"events":[{"type":0,"timestamp":"2024-04-08T13:27:26.735+08:00"},{"type":2,"timestamp":"2024-04-08T13:27:29.352+08:00"}],"attemptCount":1,"duration":0}');
        builder.element('FieldId', nest: formData['ppirSigInsured'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Signature: (Insured)');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:27:52.2099499Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Full Name:');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:28:21.815Z');
        builder.element('UpdatedValue', nest: 'Inspector ');
        builder.element('FieldId', nest: formData['ppirNameIuia'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Full Name:');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:28:24.4310056Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Full Name:');
        builder.element('SnapshotValue', nest: 'Inspector ');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:28:25.002Z');
        builder.element('UpdatedValue', nest: 'Inspector');
        builder.element('FieldId', nest: formData['ppirNameIuia'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Full Name:');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Signature: (IU/IA)');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:28:25.002Z');
        builder.element('UpdatedValue',
            nest: '{"events":[],"attemptCount":0,"duration":0}');
        builder.element('FieldId', nest: formData['ppirSigIuia'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Signature: (IU/IA)');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:28:36.975082Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Signature: (IU/IA)');
        builder.element('SnapshotValue',
            nest: '{"events":[],"attemptCount":0,"duration":0}');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:28:33.479Z');
        builder.element('UpdatedValue',
            nest:
                '{"events":[{"type":0,"timestamp":"2024-04-08T13:28:24.559+08:00"},{"type":2,"timestamp":"2024-04-08T13:28:33.079+08:00"}],"attemptCount":1,"duration":0}');
        builder.element('FieldId', nest: formData['ppirSigIuia'] ?? '');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Signature: (IU/IA)');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:28:48.7513389Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'Tracked Farm &gt; Total Area (in sqm.)');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: '0');
        builder.element('FieldId', nest: formData['track_totalarea'] ?? '');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Total Area (in sqm.)');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Date and Time');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: '04/08/2024 1:29:22 pm');
        builder.element('FieldId', nest: formData['track_datetime'] ?? '');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Date and Time');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Last Coordinates');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:22.228+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FieldId', nest: formData['track_lastcoord'] ?? '');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Last Coordinates');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                'Coordinates|track_coordinates|{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:02.631+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Date/Time|track_coord_timestamp|04/08/2024 1:29:02 pm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T02:31:09.1609392Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Hidden Field');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T02:31:08.8601031Z');
        builder.element('UpdatedValue',
            nest:
                'N - BRGY. ROAD | E - CASIANO ORO | S - NESIA ENOC | W - EMMANUEL CLARITE');

        // mar
        builder.element('FieldId', nest: formData['ppir_nesw'] ?? '');

        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Hidden Field');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message', nest: 'Task created.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T02:31:03.8278713Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Assigned Date Time');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T02:31:08.3743402Z');
        builder.element('UpdatedValue',
            nest: '2024-04-08T02:31:03.8278713+00:00');
        builder.element('FieldLabel', nest: 'Assigned Date Time');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Agent');
        builder.element('Label', nest: 'Agent');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T02:31:08.3743402Z');
        builder.element('UpdatedValue', nest: 'Suarez, Christian');
        builder.element('FieldLabel', nest: 'Agent');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                'Coordinates|track_coordinates|{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:05.649+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Date/Time|track_coord_timestamp|04/08/2024 1:29:05 pm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                'Coordinates|track_coordinates|{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:08.649+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Date/Time|track_coord_timestamp|04/08/2024 1:29:08 pm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                'Coordinates|track_coordinates|{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:11.649+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Date/Time|track_coord_timestamp|04/08/2024 1:29:11 pm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: 'Section Break||');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                'Coordinates|track_coordinates|{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:14.649+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Date/Time|track_coord_timestamp|04/08/2024 1:29:14 pm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: 'Section Break||');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                'Coordinates|track_coordinates|{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:17.649+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Date/Time|track_coord_timestamp|04/08/2024 1:29:17 pm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: 'Section Break||');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                'Coordinates|track_coordinates|{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:20.649+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Date/Time|track_coord_timestamp|04/08/2024 1:29:20 pm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: 'Section Break||');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest:
                'Coordinates|track_coordinates|{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:22.228+08:00","unitLotNo":null,"zipCode":null}');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue',
            nest: 'Date/Time|track_coord_timestamp|04/08/2024 1:29:22 pm');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: 'Section Break||');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: 'Section Break||');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('UpdatedValue', nest: 'Section Break||');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('SnapshotValue',
            nest: 'Coordinates|track_coordinates|');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('SnapshotValue',
            nest: 'Date/Time|track_coord_timestamp|');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Fields');
        builder.element('SnapshotValue',
            nest: 'Coordinate Row|track_coordinate_row|');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:28.281Z');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Field');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:31.9213368Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Tracked Farm &gt; Farm Location');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:48.04Z');
        builder.element('UpdatedValue', nest: 'Farm');
        builder.element('FieldId', nest: formData['trackFarmloc'] ?? '');
        builder.element('FormTitle', nest: 'Tracked Farm');
        builder.element('FieldLabel', nest: 'Farm Location');
        builder.element('IPAddress', nest: '172.31.37.162');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:29:53.7502153Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Remarks:');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:45.183Z');
        builder.element('UpdatedValue', nest: 'Remarks');
        builder.element('FieldId', nest: 'ppir_remarks');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Remarks:');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest:
                'PPIR - Post Planting Inspection Report &gt; Signature: (Insured)PPIR - Post Planting Inspection Report &gt; Signature: (Insured)');
        builder.element('SnapshotValue',
            nest:
                '{"events":[{"type":0,"timestamp":"2024-04-08T13:27:26.735+08:00"},{"type":2,"timestamp":"2024-04-08T13:27:29.352+08:00"}],"attemptCount":1,"duration":0}');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:45.183Z');
        builder.element('UpdatedValue',
            nest:
                '{"events":[{"type":0,"timestamp":"2024-04-08T13:27:26.735+08:00"},{"type":2,"timestamp":"2024-04-08T13:27:29.352+08:00"},{"type":0,"timestamp":"2024-04-08T13:30:31.656+08:00"},{"type":2,"timestamp":"2024-04-08T13:30:35.456+08:00"}],"attemptCount":2,"duration":0}');
        builder.element('FieldId', nest: 'ppir_sig_insured');
        builder.element('FormTitle',
            nest: 'PPIR - Post Planting Inspection Report');
        builder.element('FieldLabel', nest: 'Signature: (Insured)');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:51.4918205Z');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Label', nest: 'Task Status');
        builder.element('Message',
            nest: "Task status is changed to 'Submitted'.");
        builder.element('SnapshotValue', nest: 'In Progress');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:57.111Z');
        builder.element('UpdatedValue', nest: 'Submitted');
        builder.element('FieldLabel', nest: 'Task Status');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Captured Mobile Location');
        builder.element('SnapshotValue', nest: 'Quezon City, 1100');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:57.111Z');
        builder.element('UpdatedValue', nest: '14.653113, 121.035177');
        builder.element('FieldLabel', nest: 'Captured Mobile Location');
        builder.element('FieldLabel', nest: 'Captured Mobile Location');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Captured Mobile Location');
        builder.element('SnapshotValue', nest: '14.653113, 121.035177');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:57.111Z');
        builder.element('UpdatedValue',
            nest:
                'GAOC (Gan Advanced Osseointegration Center), Quezon City, 1105');
        builder.element('FieldLabel', nest: 'Captured Mobile Location');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Agent');
        builder.element('SnapshotValue', nest: 'Suarez, Christian');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:59.921735Z');
        builder.element('FieldLabel', nest: 'Agent');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Assigned Date Time');
        builder.element('SnapshotValue',
            nest: '2024-04-08T02:31:03.8278713+00:00');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:59.921735Z');
        builder.element('UpdatedValue',
            nest: '2024-04-08T05:30:59.9217363+00:00');
        builder.element('FieldLabel', nest: 'Assigned Date Time');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Dispatch Acknowledged');
        builder.element('SnapshotValue', nest: 'True');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:30:59.921735Z');
        builder.element('UpdatedValue', nest: 'False');
        builder.element('FieldLabel', nest: 'Dispatch Acknowledged');
        builder.element('IPAddress', nest: '172.31.6.165');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - Region 99 PPIR script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '2024-04-08T05:31:00.8335183Z');
      });
    });

    builder.element('Attachments', nest: '');
  });

  final xmlDocument = builder.buildDocument();
  return xmlDocument.toXmlString(pretty: true, indent: '\t');
}
