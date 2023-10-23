import 'package:cloud_firestore/cloud_firestore.dart';

//
class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insertUserWhileSignIn(
      {required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await db.collection("records").doc("users").get();

    Map<String, dynamic> res = docSnapshot.data() as Map<String, dynamic>;

    print("==============");
    int id = res['id'];
    int length = res['length'];

    print(id);
    print(length);
    print("==============");

    await db.collection("users").doc("${++id}").set(data);

    await db
        .collection("records")
        .doc("users")
        .update({"id": id, "length": ++length});
  }

  //todo:display all user
  displayAllUser() {
    Stream<QuerySnapshot<Map<String, dynamic>>> userStream =
        db.collection("users").snapshots();

    return userStream;
  }

  Future<void> sendChatMessage(
      {required String msg, required String id}) async {
    await db
        .collection("users")
        .doc(id)
        .collection("chat")
        .add({"message": msg, "timestamp": FieldValue.serverTimestamp()});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String id}) {
    return db
        .collection("users")
        .doc(id)
        .collection("chat")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<void> deleteUser({required String id}) async {
    await db.collection("users").doc(id).delete();
  }

  Future<void> updateUser({required String id, required String email}) async {
    await db.collection("users").doc(id).update({"email": email});
  }
}
