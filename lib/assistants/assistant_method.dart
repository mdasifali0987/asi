import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sawari/global/global.dart';

import '../model/user_model.dart';

class AssistantMethod {
  static void readCurrentOnlineUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);
    reference.once().then((snap) {
      userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
    });
  }
}
