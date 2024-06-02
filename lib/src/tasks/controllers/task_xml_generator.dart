// task_xml_generator.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xml/xml.dart';

Future<String> generateTaskXmlContent(String taskId) async {
  // Fetch the task data from Firestore
  final taskDoc =
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).get();

  if (!taskDoc.exists) {
    throw Exception('Task not found');
  }

  final taskData = taskDoc.data();

  // sample - get its blob later
  // ppirSigInsured //"https://firebasestorage.googleapis.com/v0/b/pcic-mobile-app.appspot.com/o/PPIR_SAVES%2FyYKcFDJcksVUVTj2EMvj%2FAttachments%2F24520728-6dbe-433a-8f45-4ee110d778fa_ppirSigInsured.png?alt=media&token=fdb34520-eb75-4ea8-9e6d-d514f7e6ec85"
  // ppirSigIuia // "https://firebasestorage.googleapis.com/v0/b/pcic-mobile-app.appspot.com/o/PPIR_SAVES%2FyYKcFDJcksVUVTj2EMvj%2FAttachments%2F82412bd9-8338-43d8-bb19-20841be68d24_ppirSigIuia.png?alt=media&token=116f7af7-42ff-4e04-a4fd-dc961053e5cf"

  final assignee = taskData?['assignee'] ??
      'Assignee not found'; // "christian_suarez.pcic@gmail.com"
  final createdAt = taskData?['createdAt'] ??
      'Created At not found'; // June 2, 2024 at 8:54:40 PM UTC+8
  final dateAccess = taskData?['dateAccess'] ??
      'Date Access not found'; // June 2, 2024 at 8:54:40 PM UTC+8
  final formType = taskData?['formType'] ?? 'Form Type not found'; // "PPIR"
  final ppirAddress =
      taskData?['ppirAddress'] ?? 'Address not found'; // "PASONG BANGKAL"
  final ppirAreaAci = taskData?['ppirAreaAci'] ?? 'Area ACI not found'; // 1.6
  final ppirAreaAct = taskData?['ppirAreaAct'] ?? 'Area ACT not found'; // "1.6"
  final ppirAssignmentId = taskData?['ppirAssignmentId'] ??
      'Assignment ID not found'; // "PASONG BANGKAL"
  final ppirCicNo = taskData?['ppirCicNo'] ?? 'CIC No not found'; // 1662879
  final ppirDopdsAci =
      taskData?['ppirDopdsAci'] ?? 'DOPDS ACI not found'; // "Nov 30, 2023"
  final ppirDopdsAct = taskData?['ppirDopdsAct'] ?? 'DOPDS ACT not found';
  final ppirDoptpAci =
      taskData?['ppirDoptpAci'] ?? 'DOPTP ACI not found'; // "Nov 30, 2023"
  final ppirDoptpAct = taskData?['ppirDoptpAct'] ?? 'DOPTP ACT not found';
  final ppirEast = taskData?['ppirEast'] ?? 'East not found';
  final ppirFarmLoc = taskData?['ppirFarmLoc'] ?? 'Farm Location not found';
  final ppirFarmerName = taskData?['ppirFarmerName'] ?? 'Farmer Name not found';
  final ppirFarmerType = taskData?['ppirFarmerType'] ?? 'Farmer Type not found';
  final ppirGroupAddress =
      taskData?['ppirGroupAddress'] ?? 'Group Address not found';
  final ppirGroupName = taskData?['ppirGroupName'] ?? 'Group Name not found';
  final ppirInsuranceId =
      taskData?['ppirInsuranceId'] ?? 'Insurance ID not found'; // 798446
  final ppirLenderAddress =
      taskData?['ppirLenderAddress'] ?? 'Lender Address not found';
  final ppirLenderName = taskData?['ppirLenderName'] ?? 'Lender Name not found';
  final ppirMobileNo = taskData?['ppirMobileNo'] ??
      'Mobile Number not found'; // "(0992) 813-6909"
  final ppirNameInsured =
      taskData?['ppirNameInsured'] ?? 'Name Insured not found';
  final ppirNameIuia = taskData?['ppirNameIuia'] ?? 'Name IU/IA not found';
  final ppirNorth = taskData?['ppirNorth'] ?? 'North not found';
  final ppirRemarks = taskData?['ppirRemarks'] ?? 'Remarks not found';
  final ppirSigInsured =
      taskData?['ppirSigInsured'] ?? 'Signature Insured not found';
  final ppirSigIuia = taskData?['ppirSigIuia'] ?? 'Signature IU/IA not found';
  final ppirSouth = taskData?['ppirSouth'] ?? 'South not found';
  final ppirStageCrop = taskData?['ppirStageCrop'] ?? 'Stage Crop not found';
  final ppirSvpAci = taskData?['ppirSvpAci'] ?? 'SVP ACI not found';
  final ppirSvpAct = taskData?['ppirSvpAct'] ?? 'SVP ACT not found';
  final ppirVariety = taskData?['ppirVariety'] ?? 'Variety not found';
  final ppirWest = taskData?['ppirWest'] ?? 'West not found';
  final priority =
      taskData?['priority'] ?? 'Priority not found'; // "Normal Priority"
  final serviceGroup =
      taskData?['serviceGroup'] ?? 'Service Group not found'; // "P03"
  final serviceType =
      taskData?['serviceType'] ?? 'Service Type not found'; // "Region 03 PPIR"
  final taskNumber = taskData?['taskNumber'] ?? 'Task Number not found';
  final taskStatus =
      taskData?['taskStatus'] ?? 'Task Status not found'; // "For Dispatch"
  final trackDatetime = taskData?['trackDatetime'] ??
      'Track Datetime not found'; // "2024-06-02 13:48:36"
  final trackLastcoord = taskData?['trackLastcoord'] ??
      'Track Lastcoord not found'; // "13.1384721,123.7346903"
  final trackTotalarea = taskData?['trackTotalarea'] ??
      'Track Totalarea not found'; // "0.026367133007525287"
  final trackTotaldistance = taskData?['trackTotaldistance'] ??
      'Track Totaldistance not found'; // "138.0"

  final builder = XmlBuilder();

  builder.processing('xml', 'version="1.0" encoding="UTF-8"');
  builder.element('TaskArchiveZipModel', nest: () {
    builder.attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
    builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');

    builder.element('AgentId', nest: () {
      builder.attribute('xsi:nil', 'true');
    });

    builder.element('AssignedDate', nest: '');

    builder.element('Attachments', nest: '');

    builder.element('AuditLogs', nest: () {
      // Task Status Audit Log
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Label', nest: 'Task Status');
        builder.element('Message',
            nest: "Task status is changed to '$taskStatus'.");
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: '');
        builder.element('TaskId', nest: '');
        builder.element('Timestamp', nest: '');
        builder.element('UpdatedValue', nest: '');
        builder.element('FieldLabel', nest: 'Task Status');
        builder.element('IPAddress', nest: '');
      });

      // Captured Mobile Location Audit Logs
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Captured Mobile Location');
        builder.element('Source', nest: '');
        builder.element('TaskId', nest: '');
        builder.element('Timestamp', nest: '');
        builder.element('UpdatedValue', nest: '');
        builder.element('FieldLabel', nest: 'Captured Mobile Location');
        builder.element('IPAddress', nest: '');
      });

      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label', nest: 'Captured Mobile Location');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '');
        builder.element('Timestamp', nest: '');
        builder.element('UpdatedValue', nest: '');
        builder.element('FieldLabel', nest: 'Captured Mobile Location');
        builder.element('IPAddress', nest: '');
      });

      // UpdatePostPlanting script Audit Log
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Task');
        builder.element('Message',
            nest: 'Executed P99 - UpdatePostPlanting script.');
        builder.element('Source', nest: 'System');
        builder.element('TaskId', nest: '');
        builder.element('Timestamp', nest: '');
      });

      // moo mooo
      builder.element('TaskAuditLogZipModel', nest: () {
        builder.element('AuditLevel', nest: 'Field');
        builder.element('Label',
            nest: 'PPIR - Post Planting Inspection Report &gt; Actual');
        builder.element('SnapshotValue', nest: '');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('TaskId', nest: '138152');
        builder.element('Timestamp', nest: '');
        builder.element('UpdatedValue', nest: '0.2500');
        builder.element('FieldId', nest: '');
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
        builder.element('Timestamp', nest: '');
        builder.element('UpdatedValue', nest: 'Region 99');
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');
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
        builder.element('FieldId', nest: '');

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
        builder.element('FieldId', nest: '');
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

    builder.element('CreatedBy', nest: 'System');
    builder.element('DateCreated', nest: '2024-04-08T02:31:03.8278713Z');
    builder.element('DispatchAcknowledged', nest: 'false');
    builder.element('DueDate', nest: () {
      builder.attribute('xsi:nil', 'true');
    });

    // Form Data
    builder.element('Forms', nest: () {
      // Form Zip Model 1
      builder.element('FormZipModel', nest: () {
        builder.element('ContentId', nest: '___C313c757e');

        builder.element('Fields', nest: () {
          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C8af47c47');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Farmer');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'fb036b78-a523-428c-9099-5cd30e0cfd48');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '1');
            builder.element('Type', nest: 'TabHeader');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_insuranceid');
            builder.element('ContentId', nest: 'ppir_insuranceid');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Insurance ID:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '7fd346a8-7ca4-4095-a4f0-7ad59594620b');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '3');
            builder.element('Type', nest: 'Number');
            builder.element('Value', nest: '34455');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_farmername');
            builder.element('ContentId', nest: 'ppir_farmername');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Name of Farmer:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'edda9582-34f4-4e5d-8fcb-fb4e7cf38e12');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '4');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'DELA TORRE, RAMIL O');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_address');
            builder.element('ContentId', nest: 'ppir_address');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Address:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'b7fa21e1-5275-4880-bd93-b4e3e9ed5298');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '5');
            builder.element('Type', nest: 'Paragraph');
            builder.element('Value', nest: 'BUENAVISTA, CARMEN ,BOHOL');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_mobileno');
            builder.element('ContentId', nest: 'ppir_mobileno');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Mobile No.');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'e5a61bf2-5218-4363-af96-3b9c67e53b19');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '7');
            builder.element('Type', nest: 'Text');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C8c5c666c');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Heading 3');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '35e08ccb-2683-4ea6-8b39-53abbcfd308c');
            builder.element('ParentObjectId',
                nest: 'e1741f98-0db6-4831-9d5d-226e55c82216');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '15');
            builder.element('Type', nest: 'Label');
            builder.element('Value', nest: 'Location of Sketch Plan');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C849d713a');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Filler');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'b125be87-9a5d-497c-a353-7dad592d3b0a');
            builder.element('ParentObjectId',
                nest: 'e1741f98-0db6-4831-9d5d-226e55c82216');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '19');
            builder.element('Type', nest: 'Filler');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_north');
            builder.element('ContentId', nest: 'ppir_north');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'North:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '9c9cdbb7-a0cf-48a6-a88f-9b9d003a2fe4');
            builder.element('ParentObjectId',
                nest: 'e1741f98-0db6-4831-9d5d-226e55c82216');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '17');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'BRGY. ROAD');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_east');
            builder.element('ContentId', nest: 'ppir_east');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'East:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '67cb381c-583b-4b5b-9d7b-cab659b82df1');
            builder.element('ParentObjectId',
                nest: 'e1741f98-0db6-4831-9d5d-226e55c82216');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '18');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'CASIANO ORO');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Ced4bb507');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Filler');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '38ddbce4-1d2a-4571-a130-26ffbe74290a');
            builder.element('ParentObjectId',
                nest: 'e1741f98-0db6-4831-9d5d-226e55c82216');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '16');
            builder.element('Type', nest: 'Filler');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_south');
            builder.element('ContentId', nest: 'ppir_south');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'South:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '9dae3068-2783-4b5c-9661-0546cdd62d32');
            builder.element('ParentObjectId',
                nest: 'e1741f98-0db6-4831-9d5d-226e55c82216');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '20');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'NESIA ENOC');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_west');
            builder.element('ContentId', nest: 'ppir_west');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'West:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '808c57b1-fef3-4e2a-afdc-4e49ac1ee55e');
            builder.element('ParentObjectId',
                nest: 'e1741f98-0db6-4831-9d5d-226e55c82216');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '21');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'EMMANUEL CLARITE');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Caa847787');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '7d6ba651-2f24-4a5a-b1b5-cce3b770a64a');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '22');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cba3ecf69');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '2fb8b7d2-d5b4-497f-a1b0-968a2b980558');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '25');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C1e067799');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '6fb4c3db-b48c-4893-9948-b68920dd227a');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '33');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Ca5e93611');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '0d811bf2-adff-40e4-a5af-1a51c2419493');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '38');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C601ba4fb');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '3e964cf7-d063-4694-9ad1-ea0ce93f3a33');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '43');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C9c2b21b4');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '2e4c03a8-597d-46d7-bb18-ca92b61cb21c');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '48');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C15096e44');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '3acdbae6-8cbe-4f36-878c-d9a50ced23ed');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '49');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_groupaddress');
            builder.element('ContentId', nest: 'ppir_groupaddress');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Group Address:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '230156a2-3beb-4a61-81f3-06cdc2d52d17');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '9');
            builder.element('Type', nest: 'Paragraph');
            builder.element('Value', nest: 'BICAO, CARMEN, BOHOL');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_lenderaddress');
            builder.element('ContentId', nest: 'ppir_lenderaddress');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Lender Address:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '31e8c458-42d5-4fb8-bfbd-07d3d8617e73');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '11');
            builder.element('Type', nest: 'Paragraph');
            builder.element('Value', nest: 'BICAO, CARMEN, BOHOL');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_cicno');
            builder.element('ContentId', nest: 'ppir_cicno');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'CIC No.:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '61f6699b-6122-4ec6-b9e8-5ddf6d4bec58');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '12');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '2164816');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_farmloc');
            builder.element('ContentId', nest: 'ppir_farmloc');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Location of Farm:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '602b6892-9416-489a-8659-2952e459b84f');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '13');
            builder.element('Type', nest: 'Paragraph');
            builder.element('Value', nest: 'BUENAVISTA, CARMEN, BOHOL');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C41277505');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Findings');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '08bdd465-1733-4641-b002-b59837875261');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '27');
            builder.element('Type', nest: 'TabHeader');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Ccda744f4');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Body');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '1e0c1a2a-0d59-4252-8eb6-e2359325b292');
            builder.element('ParentObjectId',
                nest: '2e251a10-487b-4232-b7d9-f99aa1172e81');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '30');
            builder.element('Type', nest: 'Label');
            builder.element('Value', nest: 'Area Planted');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Ce0369d7e');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Body');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '851e57a4-d17c-467a-9547-7c300fc5ba18');
            builder.element('ParentObjectId',
                nest: 'a947b27e-3769-44d1-a9c5-21bf0ae4d91f');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '35');
            builder.element('Type', nest: 'Label');
            builder.element('Value', nest: 'Date of Planting (DS)');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cf595c3db');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Body');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '5b513a36-faad-4898-9c53-b4afcee141ba');
            builder.element('ParentObjectId',
                nest: '1c728bc6-2ba6-47c9-a66b-329fddb8318a');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '40');
            builder.element('Type', nest: 'Label');
            builder.element('Value', nest: 'Date of Planting (TP)');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C330188fd');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Body');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'b7051998-97cd-4205-9c13-4e319552f515');
            builder.element('ParentObjectId',
                nest: '60ae3318-f922-4f6f-a24f-dcc507417e92');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '45');
            builder.element('Type', nest: 'Label');
            builder.element('Value', nest: 'Seed Variety Planted');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_remarks');
            builder.element('ContentId', nest: 'ppir_remarks');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Remarks:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '9a2a65cb-bc39-4904-ba2e-82e5319631bd');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '57');
            builder.element('Type', nest: 'Paragraph');
            builder.element('Value', nest: 'Remarks');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C26680de1');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Body');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '8a5b37be-d47b-4981-969a-8b64146ef23c');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '58');
            builder.element('Type', nest: 'Label');
            builder.element('Value', nest: 'Conformed by:');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_name_insured');
            builder.element('ContentId', nest: 'ppir_name_insured');
            builder.element('HelpText', nest: 'Insured');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Full Name:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'f49128c4-09c7-47e9-adb1-2b26609532fb');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '59');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'F');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Ce8e2c8d2');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Body');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '41c1d54b-3f2f-4fc5-bd83-2cc78587c3c1');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '62');
            builder.element('Type', nest: 'Label');
            builder.element('Value', nest: 'Prepared by:');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_groupname');
            builder.element('ContentId', nest: 'ppir_groupname');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Group Name:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '0773da25-8885-420f-b507-3106d180517a');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '8');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'BICAO FARMERS MPC');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_lendername');
            builder.element('ContentId', nest: 'ppir_lendername');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Lender Name:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '38cd62f2-91c4-49be-8a34-fc55c7b97028');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '10');
            builder.element('Type', nest: 'Text');
            builder.element('Value',
                nest: 'BICAO FARMERS MULTIPURPOSE COOPERATIVE');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('Attachment', nest: () {
              builder.element('AuthorId', nest: '53111');
              builder.element('Blob', nest: 'BLOB_MAR');
              builder.element('BlobLocation',
                  nest: '2cba2e43-122c-4f9a-b7a7-3e97fcd3183d');
              builder.element('CapturedDateTime',
                  nest: '2024-04-08T05:30:35.447Z');
              builder.element('CapturedLocation', nest: () {
                builder.element('Accuracy', nest: () {
                  builder.attribute('xsi:nil', 'true');
                });
                builder.element('BuildingName',
                    nest: 'GAOC (Gan Advanced Osseointegration Center)');
                builder.element('City', nest: 'Quezon City');
                builder.element('Country', nest: 'Philippines');
                builder.element('Latitude', nest: '14.6531133');
                builder.element('Longitude', nest: '121.0351767');
                builder.element('Province', nest: '');
                builder.element('Timestamp', nest: () {
                  builder.attribute('xsi:nil', 'true');
                });
                builder.element('ZipCode', nest: '1105');
              });
              builder.element('FileName',
                  nest: 'e4ef107c-6764-4d22-898b-adb27364e945.png');
              builder.element('FromMobile', nest: 'false');
              builder.element('Height', nest: '0');
              builder.element('LastModifiedDate', nest: '0001-01-01T00:00:00');
              builder.element('Length', nest: '4047');
              builder.element('MimeType', nest: 'image/png');
              builder.element('Width', nest: '0');
              builder.element('ZipEntryFileName',
                  nest: '1d8e0164-16a2-4b09-9f87-8b16baabbb60');
            });
            builder.element('FieldId', nest: 'ppir_sig_insured');
            builder.element('ContentId', nest: 'ppir_sig_insured');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Signature: (Insured)');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '48264b19-5b65-49c2-aa55-dff352940f4a');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '60');
            builder.element('Type', nest: 'ESignature');
            builder.element('Value',
                nest: 'e4ef107c-6764-4d22-898b-adb27364e945.png');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('Attachment', nest: () {
              builder.element('AuthorId', nest: '53111');
              builder.element('Blob', nest: 'BLOB_MAR');
              builder.element('BlobLocation',
                  nest: '3ef6459c-3634-4bc1-b048-e1c0247cb6a1');
              builder.element('CapturedDateTime',
                  nest: '2024-04-08T05:28:33.072Z');
              builder.element('CapturedLocation', nest: () {
                builder.element('Accuracy', nest: () {
                  builder.attribute('xsi:nil', 'true');
                });
                builder.element('BuildingName', nest: '');
                builder.element('City', nest: 'Quezon City');
                builder.element('Country', nest: 'Philippines');
                builder.element('Latitude', nest: '14.6381974');
                builder.element('Longitude', nest: '121.042935');
                builder.element('Province', nest: '');
                builder.element('Timestamp', nest: () {
                  builder.attribute('xsi:nil', 'true');
                });
                builder.element('ZipCode', nest: '1100');
              });
              builder.element('FileName',
                  nest: '92e7a921-eddb-4ce2-91cb-974834e22c40.png');
              builder.element('FromMobile', nest: 'false');
              builder.element('Height', nest: '0');
              builder.element('LastModifiedDate', nest: '0001-01-01T00:00:00');
              builder.element('Length', nest: '6421');
              builder.element('MimeType', nest: 'image/png');
              builder.element('Width', nest: '0');
              builder.element('ZipEntryFileName',
                  nest: '5a91c02b-0a3c-48c2-b233-445d3538d8cf');
            });

            builder.element('FieldId', nest: 'ppir_sig_iuia');
            builder.element('ContentId', nest: 'ppir_sig_iuia');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Signature: (IU/IA)');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'a0aa8416-78ef-44bb-ae27-f9eca6c44dc5');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '64');
            builder.element('Type', nest: 'ESignature');
            builder.element('Value',
                nest: '92e7a921-eddb-4ce2-91cb-974834e22c40.png');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C7538cacd');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Filler');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '139da2b2-4b85-4eec-9466-48262d057ae8');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '61');
            builder.element('Type', nest: 'Filler');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_name_iuia');
            builder.element('ContentId', nest: 'ppir_name_iuia');
            builder.element('HelpText', nest: 'IU/IA');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Full Name:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '9e6881eb-9d3c-4cd8-8ed2-0c6e140ce44b');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '63');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'Inspector');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_dopds_aci');
            builder.element('ContentId', nest: 'ppir_dopds_aci');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Per ACI - Date of Planting (DS)');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'f4281666-3928-4533-bf80-89586cf74358');
            builder.element('ParentObjectId',
                nest: 'a947b27e-3769-44d1-a9c5-21bf0ae4d91f');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '36');
            builder.element('Type', nest: 'Date');
            builder.element('Value', nest: '2201-06-21');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_dopds_act');
            builder.element('ContentId', nest: 'ppir_dopds_act');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Actual - Date of Planting (DS)');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '7cbbf87c-46f9-47d1-b699-7727ec464198');
            builder.element('ParentObjectId',
                nest: 'a947b27e-3769-44d1-a9c5-21bf0ae4d91f');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '37');
            builder.element('Type', nest: 'Date');
            builder.element('Value', nest: '2023-10-25');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_doptp_aci');
            builder.element('ContentId', nest: 'ppir_doptp_aci');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Per ACI - Date of Planting (TP)');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'd153d684-235c-4e3f-a415-ba337bf9299d');
            builder.element('ParentObjectId',
                nest: '1c728bc6-2ba6-47c9-a66b-329fddb8318a');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '41');
            builder.element('Type', nest: 'Date');
            builder.element('Value', nest: '2014-07-12');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_doptp_act');
            builder.element('ContentId', nest: 'ppir_doptp_act');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Actual - Date of Planting (TP)');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'b9c5121f-3afe-43ce-b9b5-c3a36145122a');
            builder.element('ParentObjectId',
                nest: '1c728bc6-2ba6-47c9-a66b-329fddb8318a');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '42');
            builder.element('Type', nest: 'Date');
            builder.element('Value', nest: '2023-10-24');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_svp_aci');
            builder.element('ContentId', nest: 'ppir_svp_aci');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Per ACI');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'ac7e1eb9-9f36-40ad-9ae0-03eb1d98ef64');
            builder.element('ParentObjectId',
                nest: '60ae3318-f922-4f6f-a24f-dcc507417e92');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '46');
            builder.element('Type', nest: 'Text');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cd9e63b1f');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });

            builder.element('Label', nest: 'Body');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '57b7a79a-704e-4a83-95d9-4ef5ba9c9fcb');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '55');
            builder.element('Type', nest: 'Label');
            builder.element('Value',
                nest:
                    'If transplanted, how many days were the seedings from seed sowing to transplanting');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_assignmentid');
            builder.element('ContentId', nest: 'ppir_assignmentid');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'PPI Assignment ID:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'd0487430-ed7e-423a-965d-4a6fd5adb4a6');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '2');
            builder.element('Type', nest: 'Number');
            builder.element('Value', nest: '42');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cef050610');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Grid with Fixed Rows');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'a08a5a60-437d-4b67-b648-7c7bf6b549b1');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '28');
            builder.element('Type', nest: 'Grid');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C0044b0e2');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Row - DS');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'a947b27e-3769-44d1-a9c5-21bf0ae4d91f');
            builder.element('ParentObjectId',
                nest: 'a08a5a60-437d-4b67-b648-7c7bf6b549b1');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '34');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Ca939bf9a');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Row -TP');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '1c728bc6-2ba6-47c9-a66b-329fddb8318a');
            builder.element('ParentObjectId',
                nest: 'a08a5a60-437d-4b67-b648-7c7bf6b549b1');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '39');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Ceae00bd6');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Row - SVP');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '60ae3318-f922-4f6f-a24f-dcc507417e92');
            builder.element('ParentObjectId',
                nest: 'a08a5a60-437d-4b67-b648-7c7bf6b549b1');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '44');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C51474a87');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: '');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'd556f75b-085b-48d8-9463-779f20630568');
            builder.element('ParentObjectId',
                nest: '60ae3318-f922-4f6f-a24f-dcc507417e92');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '47');
            builder.element('Type', nest: 'Filler');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_farmertype');
            builder.element('ContentId', nest: 'ppir_farmertype');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Type of Farmers:');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'cba496fd-fb24-4ff4-853a-d9ae0fa346d8');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '6');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: 'BORROWING GROUP');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cab5519b6');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Row - Area');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '2e251a10-487b-4232-b7d9-f99aa1172e81');
            builder.element('ParentObjectId',
                nest: 'a08a5a60-437d-4b67-b648-7c7bf6b549b1');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '29');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_area_act');
            builder.element('ContentId', nest: 'ppir_area_act');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Actual');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'c7c334df-6911-4d09-b9b1-d47da41d6d56');
            builder.element('ParentObjectId',
                nest: '2e251a10-487b-4232-b7d9-f99aa1172e81');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '32');
            builder.element('Type', nest: 'Number');
            builder.element('Value', nest: '0.2500');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C962111dc');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Filler');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '2b89b9b3-5ec7-4e71-9f5a-afa5281bc63e');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '52');
            builder.element('Type', nest: 'Filler');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_area_aci');
            builder.element('ContentId', nest: 'ppir_area_aci');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Per ACI');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '0d31c35c-62dd-4d9b-a99e-702e620edd9c');
            builder.element('ParentObjectId',
                nest: '2e251a10-487b-4232-b7d9-f99aa1172e81');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '31');
            builder.element('Type', nest: 'Number');
            builder.element('Value', nest: '0.2500');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C434bf08e');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'b4b0abd3-0448-4956-9842-8e7183aa771c');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');

            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '65');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C59eff340');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Attachment');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '1f313a18-bcfd-4ab2-9fe8-5e3c8f59c3d9');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '23');
            builder.element('Type', nest: 'Section');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('Attachment', nest: () {
              builder.element('AuthorId', nest: '1001');
              builder.element('Blob', nest: 'BLOB_MAR');
              builder.element('BlobLocation',
                  nest: '3bb8a48d-4b87-4d96-a6fa-8dc7804aaf0c');
              builder.element('CapturedDateTime', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('FileName',
                  nest: 'P99-20240408-26864_ppir_att_1.gpx');
              builder.element('FromMobile', nest: 'false');
              builder.element('Height', nest: '0');
              builder.element('LastModifiedDate', nest: '0001-01-01T00:00:00');
              builder.element('Length', nest: '1349');
              builder.element('MimeType', nest: 'application/gpx+xml');
              builder.element('Width', nest: '0');
              builder.element('ZipEntryFileName',
                  nest: 'a81e8752-7e9d-468f-a254-180028a09c0b');
            });

            builder.element('FieldId', nest: 'ppir_att_1');
            builder.element('ContentId', nest: 'ppir_att_1');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Attachment 1');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '052b555b-f884-4ab7-8548-9803b1d549a3');
            builder.element('ParentObjectId',
                nest: '1f313a18-bcfd-4ab2-9fe8-5e3c8f59c3d9');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '24');
            builder.element('Type', nest: 'Attachment');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_nesw');
            builder.element('ContentId', nest: 'ppir_nesw');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });

            builder.element('Label', nest: 'Hidden Field');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '100af01a-d64a-40f8-93af-16d94a032c7d');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '26');
            builder.element('Type', nest: 'Text');
            builder.element('Value',
                nest:
                    'N - BRGY. ROAD | E - CASIANO ORO | S - NESIA ENOC | W - EMMANUEL CLARITE');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cbc50640e');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '091ca59e-a4c0-4bb9-b99e-b648ad00fd4a');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '66');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cea4d0b64');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Location Sketch');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'e1741f98-0db6-4831-9d5d-226e55c82216');

            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '14');
            builder.element('Type', nest: 'Section');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_variety');
            builder.element('ContentId', nest: 'ppir_variety');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Variety');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '3e6d02a0-5a2a-4e69-b1bb-2ecd57c28119');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefData', nest: () {
              builder.element('Column', nest: 'Variety Name');
              builder.element('ColumnId', nest: '14018');
              builder.element('HintId1', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('HintId2', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('Link', nest: 'Seed-Region-Code');
              builder.element('LinkId', nest: '14019');
              builder.element('ParentContentId', nest: 'ppir_svp_act');
              builder.element('ParentTemplateFieldId', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('Table', nest: 'ZVariety PPIR');
              builder.element('TableId', nest: '14016');
            });
            builder.element('RefDataParentRowId',
                nest: '044c4205-e3dc-44ae-9c3e-1564d77e010a');
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '54');
            builder.element('Type', nest: 'List');
            builder.element('Value', nest: 'RICE-NSIC RC104 (BALILI)');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_stagecrop');
            builder.element('ContentId', nest: 'ppir_stagecrop');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Stage of Crop ATV');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'ae7da5af-b294-468b-8ffd-1f5999a1b9ea');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefData', nest: () {
              builder.element('Column', nest: 'STAGES DESCRIPTION');
              builder.element('ColumnId', nest: '15017');
              builder.element('HintId1', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('HintId2', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('Link', nest: 'VARIETY ID');
              builder.element('LinkId', nest: '15016');
              builder.element('ParentContentId', nest: 'ppir_svp_act');
              builder.element('ParentTemplateFieldId', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('Table', nest: 'ZStage of Crop');
              builder.element('TableId', nest: '15015');
            });
            builder.element('RefDataParentRowId',
                nest: '044c4205-e3dc-44ae-9c3e-1564d77e010a');
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '56');
            builder.element('Type', nest: 'List');
            builder.element('Value', nest: 'RICE-DOUGH STG. (MATURITY)');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_svp_act');
            builder.element('ContentId', nest: 'ppir_svp_act');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Seed Variety Planted - Corn/Rice');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '18d6c046-bd00-4460-9b6a-c8f2dd70c1a0');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefData', nest: () {
              builder.element('Column', nest: 'Seed Variety');
              builder.element('ColumnId', nest: '14015');
              builder.element('HintId1', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('HintId2', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('Link', nest: 'Region Name');
              builder.element('LinkId', nest: '14016');
              builder.element('ParentContentId', nest: 'ppir_region');
              builder.element('ParentTemplateFieldId', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('Table', nest: 'ZSeed Variety Planted');
              builder.element('TableId', nest: '14015');
            });
            builder.element('RefDataParentRowId',
                nest: '061461ca-c322-4d95-97b8-e2bfd06d467c');
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '53');
            builder.element('Type', nest: 'Radio');
            builder.element('Value', nest: 'Rice');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C352c241e');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '50');
            builder.element('Type', nest: 'Section');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'ppir_region');
            builder.element('ContentId', nest: 'ppir_region');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Region');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '623d651b-15c9-4bba-9cfa-f45098958619');
            builder.element('ParentObjectId',
                nest: 'ef7fa39c-a661-4d29-9e0b-154e4c0e2efb');
            builder.element('RefData', nest: () {
              builder.element('Column', nest: 'Region Name');
              builder.element('ColumnId', nest: '14014');
              builder.element('HintId1', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('HintId2', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('LinkId', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('ParentTemplateFieldId', nest: () {
                builder.attribute('xsi:nil', 'true');
              });
              builder.element('Table', nest: 'ZRegion PPIR');
              builder.element('TableId', nest: '14014');
            });
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '51');
            builder.element('Type', nest: 'List');
            builder.element('Value', nest: 'Region 99');
          });
        });
        builder.element('ObjectId',
            nest: '61b7af12-0d56-4f5f-8561-70df26169bfa');
        builder.element('Script', nest: () {
          builder.text("""
            function getRegion(string) {
              if (string && typeof string === "string") {
                // Use regular expressions to find the last two numbers
                const regexNumbers = /\\d{2}\$/;
                
                const matchesNumbers = string.match(regexNumbers);

                if (matchesNumbers && matchesNumbers.length > 0) {
                  const numbers = matchesNumbers[0]; // Get the matched numbers

                  // Check if the last two digits are 13
                  if (numbers === "13") {
                    const specialResult = "Region 13 (3A)";
                    return specialResult;
                  } else {
                    const result = "Region " + numbers; // Concatenate "Region " with the numbers
                    return result;
                  }
                }
              }
              return null; // No match found
            }

            form.addInlineListener('onLoad', function*(path, document, form, isNew) {
              var region = select.contentByContentId(form, "ppir_region");
              var servicePrefix = "";
              var regionNumber = "";

              yield* select.metadata(function*(metadata) {			
                servicePrefix = metadata.groupPrefix;
                regionNumber = getRegion(servicePrefix);
              });
              
              yield* select.refData('ZRegion PPIR', 'Region Name', function*(reg) {
                if (reg.length > 0) {
                  for (var i = 0; i < reg.length; i++) {
                    const temp = reg[i];
                    region.value = {
                      ...temp
                    };		
                  }
                }
              }, null, null, regionNumber);
              
              yield* actions.patch(function(draftDocument) {
                var draft_region = select.contentByContentId(draftDocument, "ppir_region");
                if (!!draft_region.value) {
                  if (draft_region.value.valueId !== region.value.valueId) {
                    draft_region.value = region.value;
                  }
                } else {
                  draft_region.value = region.value;			
                }
              });
            });
          """);
        });

        builder.element('Title',
            nest: 'PPIR - Post Planting Inspection Report');
      });

      // Form Zip Model 2
      builder.element('FormZipModel', nest: () {
        builder.element('ContentId', nest: '___C08edc864s');

        builder.element('Fields', nest: () {
          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C08edc864');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Tracked Farm');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '99d924a7-9058-4837-bd46-5d239be7e359');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '1');
            builder.element('Type', nest: 'TabHeader');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_totalarea');
            builder.element('ContentId', nest: 'track_totalarea');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Total Area (in sqm.)');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '0f124681-4b98-49e9-bfc4-d8905b0c9841');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '5');
            builder.element('Type', nest: 'Number');
            builder.element('Value', nest: '0');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_datetime');
            builder.element('ContentId', nest: 'track_datetime');

            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date and Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'ef551587-0b65-4da6-8fb7-b1b8e68089f0');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '6');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:22 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_lastcoord');
            builder.element('ContentId', nest: 'track_lastcoord');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Last Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '00bda7f0-e641-489d-93cc-c1ab43d700e9');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '7');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:22.228+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Ca548a4bc');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '91fc7b45-089e-43ed-b0bd-114c86a9891d');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '12');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cff3abf61');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '14f41875-1f3d-468a-b8aa-15a55814234e');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '16');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cdefe65b1');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '9d47d98d-22ab-4ad5-8491-d77a73227326');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '20');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_farmloc');
            builder.element('ContentId', nest: 'track_farmloc');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Farm Location');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '06d9cedb-34bd-4279-8552-b366723e2de3');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '42');
            builder.element('Type', nest: 'Paragraph');
            builder.element('Value', nest: 'Farm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_polygon_grid');
            builder.element('ContentId', nest: 'track_polygon_grid');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates Tracked');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '8');
            builder.element('Type', nest: 'Grid');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_visual');
            builder.element('ContentId', nest: 'track_visual');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Launch Visualization');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '465d7cb6-2d0b-4ee1-a1e0-b546aa8c69f3');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '4');
            builder.element('Type', nest: 'LaunchVisualization');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_areatracer');
            builder.element('ContentId', nest: 'track_areatracer');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Track');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '0735a594-b5f1-41d3-b90a-713519cbadb3');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '2');
            builder.element('Type', nest: 'LaunchMap');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_landplot');
            builder.element('ContentId', nest: 'track_landplot');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'View Tracked Perimeter');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'ed107a69-5d57-4daa-a485-0f1552d1601b');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '3');
            builder.element('Type', nest: 'LaunchMap');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinate_row');
            builder.element('ContentId', nest: 'track_coordinate_row');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinate Row');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '9ae9f9cf-7060-4582-aeb0-1149c52ab6b8');
            builder.element('ParentObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '9');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinates');
            builder.element('ContentId', nest: 'track_coordinates');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '1b224cf9-1c0b-43a6-94a6-8e99d36f098f');
            builder.element('ParentObjectId',
                nest: '9ae9f9cf-7060-4582-aeb0-1149c52ab6b8');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '10');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:02.631+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coord_timestamp');
            builder.element('ContentId', nest: 'track_coord_timestamp');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date/Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'e89fc95a-1cbe-4c78-a710-077d81e10a59');
            builder.element('ParentObjectId',
                nest: '9ae9f9cf-7060-4582-aeb0-1149c52ab6b8');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '11');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:02 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinate_row');
            builder.element('ContentId', nest: 'track_coordinate_row');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinate Row');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'bd977db7-78e1-4176-a5a8-df26f5a85e52');
            builder.element('ParentObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '13');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinates');
            builder.element('ContentId', nest: 'track_coordinates');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'fa8a7b5f-a5c7-43c4-8e41-a8d600bd815f');
            builder.element('ParentObjectId',
                nest: 'bd977db7-78e1-4176-a5a8-df26f5a85e52');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '14');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:05.649+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coord_timestamp');
            builder.element('ContentId', nest: 'track_coord_timestamp');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date/Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '674316dd-bd2f-4138-839f-97d7f212cb4f');
            builder.element('ParentObjectId',
                nest: 'bd977db7-78e1-4176-a5a8-df26f5a85e52');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '15');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:05 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinate_row');
            builder.element('ContentId', nest: 'track_coordinate_row');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinate Row');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '4a235456-fb4b-47fa-a6e6-630bf7519192');
            builder.element('ParentObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '17');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinates');
            builder.element('ContentId', nest: 'track_coordinates');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '1031d073-5a94-4eb1-8d9e-69925647a0f5');
            builder.element('ParentObjectId',
                nest: '4a235456-fb4b-47fa-a6e6-630bf7519192');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '18');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:08.649+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coord_timestamp');
            builder.element('ContentId', nest: 'track_coord_timestamp');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date/Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '87ef33c7-44fe-4fe6-b1d7-0b6cdecd9f80');
            builder.element('ParentObjectId',
                nest: '4a235456-fb4b-47fa-a6e6-630bf7519192');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '19');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:08 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinate_row');
            builder.element('ContentId', nest: 'track_coordinate_row');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinate Row');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '72d9d354-749a-4991-99fc-53dbc228c317');
            builder.element('ParentObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '21');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinates');
            builder.element('ContentId', nest: 'track_coordinates');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });

            builder.element('ObjectId',
                nest: '2563598a-9bae-4d71-90c3-8fbff7b2cb83');
            builder.element('ParentObjectId',
                nest: '72d9d354-749a-4991-99fc-53dbc228c317');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '22');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:11.649+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coord_timestamp');
            builder.element('ContentId', nest: 'track_coord_timestamp');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date/Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'b611f788-8622-494d-aca7-84c7c9c0e6d0');
            builder.element('ParentObjectId',
                nest: '72d9d354-749a-4991-99fc-53dbc228c317');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '23');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:11 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C234ee8b9');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '08643319-201c-4f07-b694-4ce913f89226');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '24');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinate_row');
            builder.element('ContentId', nest: 'track_coordinate_row');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinate Row');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '5d462cd2-cff5-4030-84a8-a0d77a0ccde2');
            builder.element('ParentObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '25');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinates');
            builder.element('ContentId', nest: 'track_coordinates');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'e7d023f2-1a40-4150-9aab-9995b27c2b93');
            builder.element('ParentObjectId',
                nest: '5d462cd2-cff5-4030-84a8-a0d77a0ccde2');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '26');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:14.649+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coord_timestamp');
            builder.element('ContentId', nest: 'track_coord_timestamp');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date/Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '36a340d5-271d-46ab-94cf-bdabe6595a6f');
            builder.element('ParentObjectId',
                nest: '5d462cd2-cff5-4030-84a8-a0d77a0ccde2');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '27');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:14 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C09b40bd4');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '907e5ff9-9ad2-47f4-af1e-9e33e9855024');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '28');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinate_row');
            builder.element('ContentId', nest: 'track_coordinate_row');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinate Row');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'c0093f37-f1b5-4a7d-ad38-6abe75b4510c');
            builder.element('ParentObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '29');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinates');
            builder.element('ContentId', nest: 'track_coordinates');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '307f0fd4-c31f-4eb5-84a0-feab2e15de98');
            builder.element('ParentObjectId',
                nest: 'c0093f37-f1b5-4a7d-ad38-6abe75b4510c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '30');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:17.649+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coord_timestamp');
            builder.element('ContentId', nest: 'track_coord_timestamp');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date/Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '804c1c1b-5911-4990-bd3c-4bad05bd7c40');
            builder.element('ParentObjectId',
                nest: 'c0093f37-f1b5-4a7d-ad38-6abe75b4510c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '31');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:17 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C96db75c0');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'b5120d49-0ff8-4628-a7da-b4770afa6b58');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '32');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinate_row');

            builder.element('ContentId', nest: 'track_coordinate_row');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinate Row');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'f711f34e-2fd4-49eb-af07-c71fa04b8b6e');
            builder.element('ParentObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '33');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinates');
            builder.element('ContentId', nest: 'track_coordinates');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'ec311f16-09fb-4cd4-bece-d6bae3038d38');
            builder.element('ParentObjectId',
                nest: 'f711f34e-2fd4-49eb-af07-c71fa04b8b6e');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '34');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:20.649+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coord_timestamp');
            builder.element('ContentId', nest: 'track_coord_timestamp');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date/Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });

            builder.element('ObjectId',
                nest: 'f98c9ce1-0863-475f-ab29-3ece9d024088');
            builder.element('ParentObjectId',
                nest: 'f711f34e-2fd4-49eb-af07-c71fa04b8b6e');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '35');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:20 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C5b4698b0');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });

            builder.element('ObjectId',
                nest: 'c0f636b1-56a7-4fe6-b334-837fe622421f');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '36');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinate_row');
            builder.element('ContentId', nest: 'track_coordinate_row');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinate Row');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '77ac435f-e846-46b4-9dd4-eccaf5c1d32f');
            builder.element('ParentObjectId',
                nest: 'efa12ec5-9d4a-4ef0-b1f0-317930a5d59c');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '37');
            builder.element('Type', nest: 'Row');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coordinates');
            builder.element('ContentId', nest: 'track_coordinates');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Coordinates');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '8c62807e-5889-4c77-8756-2c1724734dd3');
            builder.element('ParentObjectId',
                nest: '77ac435f-e846-46b4-9dd4-eccaf5c1d32f');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '38');
            builder.element('Type', nest: 'PolygonPoint');
            builder.element('Value',
                nest:
                    '{"accuracy":null,"barangayVillage":null,"buildingName":null,"city":null,"country":null,"latitude":14.6531133,"longitude":121.0351767,"province":null,"street":null,"timestamp":"2024-04-08T13:29:22.228+08:00","unitLotNo":null,"zipCode":null}');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('FieldId', nest: 'track_coord_timestamp');
            builder.element('ContentId', nest: 'track_coord_timestamp');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Date/Time');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '1f8fb0e7-4fde-49d2-b6f9-1dd06896c395');
            builder.element('ParentObjectId',
                nest: '77ac435f-e846-46b4-9dd4-eccaf5c1d32f');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '39');
            builder.element('Type', nest: 'Text');
            builder.element('Value', nest: '04/08/2024 1:29:22 pm');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___C6453bbf9');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: '5fd8995f-17f1-4e31-b388-bdefd5a497cf');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '40');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cbaca3988');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'd359f07c-b8b4-4d9d-948f-194c8dcee913');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '41');
            builder.element('Type', nest: 'SectionBreak');
          });

          builder.element('FormFieldZipModel', nest: () {
            builder.element('ContentId', nest: '___Cf5512a2c');
            builder.element('Indicator', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Label', nest: 'Section Break');
            builder.element('LockFieldType', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('ObjectId',
                nest: 'ab2b568c-766e-4b8e-8b56-d52b5be0c16f');
            builder.element('ParentObjectId',
                nest: '00000000-0000-0000-0000-000000000000');
            builder.element('RefDataParentRowId', nest: () {
              builder.attribute('xsi:nil', 'true');
            });
            builder.element('Options', nest: '');
            builder.element('Sequence', nest: '43');
            builder.element('Type', nest: 'SectionBreak');
          });
        });
        builder.element('FormId', nest: '165e0588-9ca5-4ce7-ad00-d263928b5e31');
        builder.element('FormTitle', nest: 'Tracked Farm');
      });
    });

    // Captured Mobile Location
    builder.element('CapturedMobileLocation', nest: () {
      builder.element('Accuracy', nest: () {
        builder.attribute('xsi:nil', 'true');
      });
      builder.element("BuildingName",
          nest: "GAOC (Gan Advanced Osseointegration Center)");
      builder.element("City", nest: "Quezon City");
      builder.element("Country", nest: "Philippines");
      builder.element("Latitude", nest: "14.6531133");
      builder.element("Longitude", nest: "121.0351767");
      builder.element("ZipCode", nest: "1105");
      builder.element('Province', nest: '');
      builder.element('Timestamp', nest: () {
        builder.attribute('xsi:nil', 'true');
      });
      builder.element('ZipCode', nest: '1105');
    });

    builder.element('CapturedMobileLocationHash', nest: '0');
    builder.element('LastAssignedAgentId', nest: '53111');
    builder.element('LastModifiedDate', nest: '2024-04-08T05:30:59.9217363Z');
    builder.element('Priority', nest: 'NormalPriority');
    builder.element('Remarks', nest: '');
    builder.element('ServiceGroupId', nest: '10010');
    builder.element('ServiceGroupName', nest: 'Region 99 - PPIR');
    builder.element('ServiceGroupTaskNumberPrefix', nest: 'P99');
    builder.element('ServiceTypeId', nest: '12012');
    builder.element('ServiceTypeName', nest: 'Region 99 PPIR');

    // Status Logs
    builder.element('StatusLogs', nest: () {
      builder.element('TaskStatusLogZipModel', nest: () {
        builder.element('AgentId', nest: () {
          builder.attribute('xsi:nil', 'true');
        });
        builder.element('Source', nest: 'System');
        builder.element('SourceId', nest: '1001');
        builder.element('TaskId', nest: '138152');
        builder.element('TaskNumber', nest: 'P99-20240408-26864');
        builder.element('TaskStatus', nest: 'For Dispatch');
        builder.element('Timestamp', nest: '2024-04-08T02:31:03.8278713Z');
      });

      builder.element('TaskStatusLogZipModel', nest: () {
        builder.element('Agent', nest: 'Suarez, Christian');
        builder.element('AgentId', nest: '53111');
        builder.element('TaskId', nest: '138152');
        builder.element('TaskNumber', nest: 'P99-20240408-26864');
        builder.element('TaskStatus', nest: 'In Progress');
        builder.element('Timestamp', nest: '2024-04-08T05:26:32.092Z');
      });

      builder.element('TaskStatusLogZipModel', nest: () {
        builder.element('Agent', nest: 'Suarez, Christian');
        builder.element('AgentId', nest: '53111');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('SourceId', nest: '53111');
        builder.element('TaskId', nest: '138152');
        builder.element('TaskNumber', nest: 'P99-20240408-26864');
        builder.element('TaskStatus', nest: 'In Progress');
        builder.element('Timestamp', nest: '2024-04-08T05:26:32.092Z');
      });

      builder.element('TaskStatusLogZipModel', nest: () {
        builder.element('AgentId', nest: () {
          builder.attribute('xsi:nil', 'true');
        });
        builder.element('TaskId', nest: '138152');
        builder.element('TaskNumber', nest: 'P99-20240408-26864');
        builder.element('TaskStatus', nest: 'Submitted');
        builder.element('Timestamp', nest: '2024-04-08T05:30:59.9217363Z');
      });

      builder.element('TaskStatusLogZipModel', nest: () {
        builder.element('Agent', nest: 'Suarez, Christian');
        builder.element('AgentId', nest: '53111');
        builder.element('Source', nest: 'Suarez, Christian');
        builder.element('SourceId', nest: '53111');
        builder.element('TaskId', nest: '138152');
        builder.element('TaskNumber', nest: 'P99-20240408-26864');
        builder.element('TaskStatus', nest: 'Submitted');
        builder.element('Timestamp', nest: '2024-04-08T05:30:57.111Z');
      });
    });

    builder.element('TaskNumber', nest: 'P99-20240408-26864');
    builder.element('TaskStatus', nest: 'Submitted');
    builder.element('ArchiveDateTime',
        nest: '2024-04-08T13:31:01.155522+08:00');
    builder.element('LatestArchiveDate',
        nest: '2024-04-08T13:31:01.1555203+08:00');
  });

  final xmlDocument = builder.buildDocument();
  return xmlDocument.toXmlString(pretty: true, indent: '\t');
}
