import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  Future addUserToUserCollectionInFirebase(String uid) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    ref.set({
      'id': uid,
      'name': "",
      'phone': "",
      'wallet': 0,
      'groups': [],
    });
  }

  Future updateUserDetailsInFirebase(
      String uid, String name, String phone) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    ref.update({
      'id': uid,
      'name': name,
      'phone': phone,
    });
  }

  Future updateUsersGroupInFirebase(String uid, String groupId) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    ref.update({
      'id': uid,
      'groups': FieldValue.arrayUnion([groupId])
    });
  }

  Future updateUserWalletInFirebase(String uid, num wallet) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    ref.update({'id': uid, 'wallet': wallet});
  }

  //GROUP FUNCTIONS IN FIREBASE
  Future createGroup(String groupName, List groupMembers) async {
    final ref = FirebaseFirestore.instance.collection('groups');
    ref.add({
      'name': groupName,
      'members': FieldValue.arrayUnion(groupMembers),
      'bills': []
    }).then((value) {
      groupMembers.forEach(
        (element) {
          updateUsersGroupInFirebase(element, value.id);
        },
      );
    });
  }

  Future updatePaidListInFirebase(String uid, String groupId, int index) async {
    final ref = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get();
    final billRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);
    final bills = ref.data()!['bills'];
    bills[index]['paid-list'].add(uid);
    billRef.update({'bills': bills});
  }

  Future addGroups(String uid, String title) async {
    final ref = FirebaseFirestore.instance.collection('groups').doc();
    Map newData = {'id': DateTime.now().millisecondsSinceEpoch, 'title': title};
    await ref.update({
      'user-group': FieldValue.arrayUnion([newData])
    });
  }

  Future addBillToGroup(String groupId, String totalAmount,
      String billDescription, String amountToBePaid, List paidMembers) async {
    List<Map> bill = [
      {
        'total-amount': totalAmount,
        'bill-desc': billDescription,
        'payable-amount': amountToBePaid,
        'payer': FirebaseAuth.instance.currentUser!.uid,
        'paid-list': paidMembers
      }
    ];
    final ref = FirebaseFirestore.instance.collection('groups').doc(groupId);
    ref.update({'bills': FieldValue.arrayUnion(bill)});
  }

  Future transferPayableAmountToPayer(
      String groupId, int index, num payableAmount) async {
    final userRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final ref = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get();
    final payerId = ref.data()!['bills'][index]['payer'];
    num existingWalletBalance = userRef.get('wallet');
    log(existingWalletBalance.toString());
    existingWalletBalance = existingWalletBalance + payableAmount;
    updateUserWalletInFirebase(payerId, existingWalletBalance);
  }
}
