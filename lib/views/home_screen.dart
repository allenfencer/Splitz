import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:splitz/constants/color_theme.dart';
import 'package:splitz/global%20widgets/small_buttons.dart';
import 'package:splitz/views/create_group_screen.dart';
import 'package:splitz/views/profile_screen.dart';
import 'package:splitz/views/split_bill_screen.dart';
import 'package:splitz/views/view_group_screen.dart';

import '../constants/text_theme.dart';
import '../global widgets/custom_list_tile.dart';
import '../services/firebase_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DocumentSnapshot> userRef;
  late Future<DocumentSnapshot> groupRef;
  late num walletAmount = 0;
  TextEditingController topUpController = TextEditingController();

  @override
  void initState() {
    userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    super.initState();
  }

  Future<void> refreshState() async {
    userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {});
  }

  topupDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            titleTextStyle: TT.f20w600,
            title: const Text('Add Amount'),
            content: TextFormField(
              style: TT.f16w600,
              textAlignVertical: TextAlignVertical.center,
              controller: topUpController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8)
              ],
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey))),
            ),
            actions: [
              GestureDetector(
                onTap: () async {
                  const storage = FlutterSecureStorage();
                  final userId = await storage.read(key: 'userId');
                  log(userId.toString());
                  setState(() {
                    walletAmount =
                        walletAmount + int.parse(topUpController.text);
                  });
                  FirebaseService()
                      .updateUserWalletInFirebase(userId!, walletAmount);
                  if (context.mounted) Navigator.pop(context);
                  topUpController.clear();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorTheme.buttonColorLight),
                  child: Text(
                    'Top up',
                    style: TT.f16w600.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: refreshState,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dashboard',
                        style: TT.f24w600,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileScreen()));
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 25,
                            color: ColorTheme.textColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25)),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        Map<String, dynamic> data = snapshot.data!.data()!;
                        walletAmount = data['wallet'];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Balance',
                                      style: TT.f16w600,
                                    ),
                                    TextButton.icon(
                                        onPressed: topupDialog,
                                        icon: const Icon(
                                          Icons.add,
                                          color: ColorTheme.purpleTile,
                                        ),
                                        label: Text(
                                          'Top up',
                                          style: TT.f16w600.copyWith(
                                              color: ColorTheme.purpleTile),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '$walletAmount USD',
                                  style: TT.f24w600,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ]),
                        );
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Recent Searches',
                      //   style: TT.f18w400.copyWith(fontWeight: FontWeight.w600),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // TextFormField(
                      //     autovalidateMode: AutovalidateMode.onUserInteraction,
                      //     decoration: InputDecoration(
                      //         hintText: 'Search',
                      //         hintStyle: TT.f16w600.copyWith(
                      //             color: Colors.grey.shade400,
                      //             fontWeight: FontWeight.w400),
                      //         border: InputBorder.none,
                      //         enabledBorder: InputBorder.none,
                      //         suffixIcon: const Icon(Icons.search),
                      //         filled: true,
                      //         fillColor: ColorTheme.backgroundColor)),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your groups',
                            style: TT.f18w400
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SmallButtons(
                            buttonTitle: 'Add',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateGroupScreen(
                                            refreshState: refreshState,
                                          )));
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                        future: userRef,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> grpData =
                                snapshot.data!.get('groups');
                            if (grpData.isEmpty) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(bottom: 15, top: 25),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25, horizontal: 30),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'You dont have any groups',
                                      overflow: TextOverflow.ellipsis,
                                      style: TT.f20w600
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox(
                              height: 150,
                              child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: grpData.length,
                                  itemBuilder: ((context, index) {
                                    return FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('groups')
                                          .doc(grpData[index])
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewGroupScreen(
                                                              noOfMembers: snapshot
                                                                  .data!
                                                                  .get(
                                                                      'members')
                                                                  .length,
                                                              groupId: grpData[
                                                                  index],
                                                              groupName: snapshot
                                                                  .data!
                                                                  .get(
                                                                      'name'))));
                                            },
                                            child: CustomListTile(
                                              title: snapshot.data!.get('name'),
                                              member: snapshot.data!
                                                  .get('members')
                                                  .length,
                                            ),
                                          );
                                        } else if (!snapshot.hasData) {
                                          return const SizedBox();
                                        } else {
                                          return Container(
                                              height: 80,
                                              width: 125,
                                              alignment: Alignment.center,
                                              child:
                                                  const CircularProgressIndicator());
                                        }
                                      },
                                    );
                                  })),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent splits',
                            style: TT.f18w400
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          SmallButtons(
                            buttonTitle: 'Add',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SplitBillScreen()));
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: ((context, index) {
                              return const CustomListTile(
                                title: 'IV',
                              );
                            })),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Text(
                      //   'View Transactions',
                      //   style: TT.f18w400.copyWith(fontWeight: FontWeight.w600),
                      // ),
                    ],
                  ),
                )
              ]),
            ],
          ),
        )),
      ),
    );
  }
}
