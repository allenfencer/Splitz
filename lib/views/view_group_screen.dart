import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitz/constants/color_theme.dart';
import 'package:splitz/views/home_screen.dart';
import 'package:splitz/views/split_bill_screen.dart';

import '../constants/text_theme.dart';
import '../services/firebase_services.dart';

class ViewGroupScreen extends StatefulWidget {
  VoidCallback refresh;
  int walletAmount;
  final String groupName;
  final String groupId;
  final int noOfMembers;
  ViewGroupScreen(
      {super.key,
      required this.refresh,
      required this.walletAmount,
      required this.groupName,
      required this.groupId,
      required this.noOfMembers});

  @override
  State<ViewGroupScreen> createState() => _ViewGroupScreenState();
}

class _ViewGroupScreenState extends State<ViewGroupScreen> {
  late Future groupsDocument;
  @override
  void initState() {
    groupsDocument = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorTheme.textColor,
        child: const Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SplitBillScreen(
                        noOfMembers: widget.noOfMembers,
                        groupId: widget.groupId,
                      )));
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.groupName,
          style: TT.f20w600,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.groupId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final billList = snapshot.data!.data()!['bills'];
              return ListView.builder(
                itemCount: billList.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.only(bottom: 15, top: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(2, 2)),
                          ]),
                      child: ListTile(
                        title: Text(
                          billList[index]['bill-desc'].toString(),
                          overflow: TextOverflow.ellipsis,
                          style:
                              TT.f20w600.copyWith(color: ColorTheme.textColor),
                        ),
                        trailing: billList[index]['paid-list'].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const ClipRRect(
                                child: SizedBox(
                                  child: Text(
                                    'Paid',
                                    style: TT.f20w600,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  log(billList[index]['paid-list'].toString());
                                  log(FirebaseAuth.instance.currentUser!.uid);
                                  final payableAmount =
                                      billList[index]['payable-amount'];
                                  if (widget.walletAmount <
                                      num.parse(payableAmount)) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            surfaceTintColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            alignment: Alignment.center,
                                            title: const Text(
                                              'Insufficient Balance',
                                              style: TT.f20w600,
                                            ),
                                            content: Text(
                                              'Please add funds to your account and try again',
                                              style: TT.f16w600.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            ),
                                          );
                                        });
                                  } else {
                                    widget.walletAmount = widget.walletAmount -
                                        num.parse(payableAmount).toInt();
                                    //UPDATED WALLET OF CURRENT USER
                                    FirebaseService()
                                        .updateUserWalletInFirebase(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            widget.walletAmount);
                                    //TRANSFER THE REMAINING AMOUNT TO THE PERSON WHO PAID THE BILL
                                    FirebaseService()
                                        .transferPayableAmountToPayer(
                                            widget.groupId,
                                            index,
                                            num.parse(payableAmount));
                                    //UPDATE PAID LIST
                                    FirebaseService().updatePaidListInFirebase(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.groupId,
                                        index);
                                    widget.refresh();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Amount Paid')));
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color.fromARGB(
                                            255, 172, 22, 12)),
                                    child: Text(
                                      'Pay',
                                      style: TT.f16w600
                                          .copyWith(color: Colors.white),
                                    )),
                              ),
                        subtitle: Text(
                            '${billList[index]['payable-amount']} \$',
                            style: TT.f16w600.copyWith(
                                color: const Color.fromARGB(255, 181, 26, 15))),
                      ));
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
