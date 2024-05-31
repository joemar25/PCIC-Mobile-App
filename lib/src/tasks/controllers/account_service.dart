import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart' as logging;

class AccountService {
  static final logging.Logger _logger = logging.Logger('AccountService');

  static Future<String> getAuthUidForEmail(String email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
    } catch (error) {
      _logger.severe('Error fetching authUid for email: $email - $error');
    }

    return '';
  }
}
