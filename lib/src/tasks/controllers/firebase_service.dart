import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUserExists(String email) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return userSnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Error checking user existence: $e');
    }
  }

  Future<DocumentReference> getUserRef(String email) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        return userSnapshot.docs.first.reference;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user reference: $e');
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: 'password',
      );

      final user = userCredential.user;
      await _firestore.collection('users').doc(user?.uid).set({
        'name': userData['name'],
        'email': userData['email'],
        'profilePicUrl': userData['profilePicUrl'],
        'role': userData['role'],
        'isVerified': userData['isVerified'],
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': userData['isActive'],
      });
      debugPrint('User created in Firestore with UID: ${user?.uid}');
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    try {
      final userEmail = taskData['assignee'];
      DocumentReference userRef;

      try {
        userRef = await getUserRef(userEmail);
      } catch (e) {
        debugPrint('User does not exist, creating user...');
        final userData = {
          'name': taskData['ppir_name_iuia'],
          'email': taskData['assignee'],
          'profilePicUrl': '',
          'role': 'user',
          'isVerified': false,
          'isActive': true,
        };
        await createUser(userData);
        userRef = await getUserRef(userEmail);
      }

      final taskDoc = await _firestore.collection('tasks').add({
        'taskNumber': taskData['task_number'] ?? '',
        'serviceGroup': taskData['service_group'] ?? '',
        'serviceType': taskData['service_type'] ?? '',
        'priority': taskData['priority'] ?? '',
        'taskStatus': taskData['task_status'] ?? '',
        'assignee': taskData['assignee'] ?? '',
        'ppirAssignmentId': taskData['ppir_assignmentid'] ?? '',
        'ppirInsuranceId': taskData['ppir_insuranceid'] ?? '',
        'ppirFarmerName': taskData['ppir_farmername'] ?? '',
        'ppirAddress': taskData['ppir_address'] ?? '',
        'ppirFarmerType': taskData['ppir_farmertype'] ?? '',
        'ppirMobileNo': taskData['ppir_mobileno'] ?? '',
        'ppirGroupName': taskData['ppir_groupname'] ?? '',
        'ppirGroupAddress': taskData['ppir_groupaddress'] ?? '',
        'ppirLenderName': taskData['ppir_lendername'] ?? '',
        'ppirLenderAddress': taskData['ppir_lenderaddress'] ?? '',
        'ppirCicNo': taskData['ppir_cicno'] ?? '',
        'ppirFarmLoc': taskData['ppir_farmloc'] ?? '',
        'ppirNorth': taskData['ppir_north'] ?? '',
        'ppirSouth': taskData['ppir_south'] ?? '',
        'ppirEast': taskData['ppir_east'] ?? '',
        'ppirWest': taskData['ppir_west'] ?? '',
        'ppirAtt1': taskData['ppir_att_1'] ?? '',
        'ppirAtt2': taskData['ppir_att_2'] ?? '',
        'ppirAtt3': taskData['ppir_att_3'] ?? '',
        'ppirAtt4': taskData['ppir_att_4'] ?? '',
        'ppirAreaAci': taskData['ppir_area_aci'],
        'ppirAreaAct': taskData['ppir_area_act'] ?? '',
        'ppirDopdsAci': taskData['ppir_dopds_aci'] ?? '',
        'ppirDopdsAct': taskData['ppir_dopds_act'] ?? '',
        'ppirDoptpAci': taskData['ppir_doptp_aci'] ?? '',
        'ppirDoptpAct': taskData['ppir_doptp_act'] ?? '',
        'ppirSvpAci': taskData['ppir_svp_aci'] ?? '',
        'ppirSvpAct': taskData['ppir_svp_act'] ?? '',
        'ppirVariety': taskData['ppir_variety'] ?? '',
        'ppirStageCrop': taskData['ppir_stagecrop'] ?? '',
        'ppirRemarks': taskData['ppir_remarks'] ?? '',
        'ppirNameInsured': taskData['ppir_name_insured'] ?? '',
        'ppirNameIuia': taskData['ppir_name_iuia'] ?? '',
        'ppirSigInsured': taskData['ppir_sig_insured'] ?? '',
        'ppirSigIuia': taskData['ppir_sig_iuia'] ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'dateAccess': FieldValue.serverTimestamp(),

        // custom
        'user': userRef,
        'formType': taskData.containsKey('isPPIR') && taskData['isPPIR'] == true
            ? 'PPIR'
            : 'Others',
        'formId': taskData['formId'] ?? '',
      });

      debugPrint('Task created with ID: ${taskDoc.id}');
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  Future<void> updateFilesRead(String fileName) async {
    try {
      await _firestore.collection('files_read').doc(fileName).set({
        'fileName': fileName,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating files read: $e');
    }
  }

  Future<bool> isFileRead(String fileName) async {
    try {
      final fileSnapshot =
          await _firestore.collection('files_read').doc(fileName).get();
      return fileSnapshot.exists;
    } catch (e) {
      throw Exception('Error checking if file is read: $e');
    }
  }
}
