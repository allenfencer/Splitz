import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splitz/services/firebase_services.dart';
import 'package:splitz/views/home_screen.dart';

import '../constants/color_theme.dart';
import '../constants/text_theme.dart';
import '../global widgets/custom_button.dart';
import '../global widgets/custom_text_field.dart';
import '../global widgets/user_card_tile.dart';

class CreateGroupScreen extends StatefulWidget {
  final VoidCallback refreshState;
  const CreateGroupScreen({super.key, required this.refreshState});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController groupController = TextEditingController();
  TextEditingController userSearchController = TextEditingController();
  final userRef = FirebaseFirestore.instance.collection('users').snapshots();
  List groupMemberIds = [];
  void addMemberToGroup(String id) {
    groupMemberIds.add(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Create Group',
          style: TT.f20w600,
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: 'Group name',
              icon: Icons.group,
              onChanged: (data) {},
              validator: (val) {
                if (val.isEmpty || val == null) {
                  return 'Group name cannot be empty';
                } else {
                  return null;
                }
              },
              inputType: TextInputType.text,
              controller: groupController,
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Add Members',
              style: TT.f20w600,
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
              stream: userRef,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          return UserCardTile(
                            id: snapshot.data!.docs[index]['id'],
                            name: snapshot.data!.docs[index]['name'],
                            number: snapshot.data!.docs[index]['phone'],
                            function: addMemberToGroup,
                          );
                        })),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                buttonText: 'Create Group',
                function: () async {
                  if (groupController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Group name cannot be empty')));
                    return;
                  }
                  await FirebaseService().createGroup(
                      groupController.text, groupMemberIds.toSet().toList());
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false).then((value) => widget.refreshState());
                }),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      )),
    );
  }
}
