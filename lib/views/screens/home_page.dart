import 'package:chat_flutter_app/utils/firebase_auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/signIn_controller.dart';
import '../../utils/firebasestore_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String SelectedOption = "Option 1";

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? user = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    print("=========================");
    print(user);
    print("=========================");

    SignInController signInController = Get.put(SignInController());

    double height = Get.height;
    double width = Get.width;

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.08,
              ),
              CircleAvatar(
                radius: height * 0.09,
                // foregroundImage: (user!.photoURL != null)
                //     ? NetworkImage(user.photoURL!)
                //     : const AssetImage("assets/images/user.png")
                // as ImageProvider?,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              // Text("Email : ${user.email}"),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: height * 0.02,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuthHelper.firebaseAuthHelper.signOut();
                      signInController.signOut();
                      Get.offNamedUntil("/signUp_page", (route) => false);
                    },
                    icon: const Icon(Icons.logout_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),

        appBar: AppBar(
          title: Text(
            "Home page",
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuthHelper.firebaseAuthHelper.signOut();
                Get.toNamed('/setting_page');
              },
              icon: Icon(
                Icons.settings,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "Option 1",
                  child: Row(
                    children: [
                      const Icon(Icons.bookmark_add_outlined,
                          color: Colors.black),
                      const Text("All BookMark"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "Option 2",
                  child: Row(
                    children: [
                      const Icon(Icons.laptop, color: Colors.black),
                      const Text("Search Engine"),
                    ],
                  ),
                ),
              ],
              onSelected: (selectedOption) {
                setState(() {
                  // SelectedOption = selectedOption;
                });
                if (selectedOption == "Option 1") {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        height: 600,
                      );
                    },
                  );
                } else if (selectedOption == "Option 2") {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Search Engine"),
                      ),
                    );
                  });
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Transform.scale(
                  scale: 0.9,
                  child: SearchBar(
                    onTap: () {},
                    leading: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        CupertinoIcons.search,
                      ),
                    ),
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     CircleAvatar(
              //       radius: 40,
              //     ),
              //   ],
              // ),
              Expanded(
                flex: 8,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>> data =
                          snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          allDocs = data.docs;

                      Set<String> uniqueSet = {};

                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          uniqueList = allDocs
                              .where((e) => uniqueSet.add(e.data()['uid']))
                              .toList();

                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          documents = [];

                      // for (int i = 0; i < uniqueList.length; i++) {
                      //   if (user!.uid != uniqueList[i].data()['uid']) {
                      //     documents.add(uniqueList[i]);
                      //   }
                      // }

                      return  ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Get.toNamed("/chat_page", arguments: documents[index]);
                          },
                          child: ListTile(
                            leading: Text("${index + 1}"),
                            // title: Text(documents[index].data()['email']),
                            // subtitle: Text(documents[index].data()['uid']),
                          ),
                        ),
                      );




                      //   ListView.builder(
                      //   itemCount: allDocs.length,
                      //   itemBuilder: (context, index) {
                      //     return ListTile(
                      //       onTap: () {
                      //         Navigator.of(context).pushNamed("/chat_page",
                      //             arguments: allDocs[index]);
                      //       },
                      //       leading: CircleAvatar(
                      //         radius: 30,
                      //         // foregroundImage: (user!.photoURL != null)
                      //         //     ? NetworkImage(user.photoURL!)
                      //         //     : const AssetImage("assets/images/user.png")
                      //         //         as ImageProvider?,
                      //
                      //         // foregroundImage: (user!.photoURL != null)
                      //         //     ? NetworkImage(user.photoURL!)
                      //         //     : const AssetImage("assets/images/google.png")
                      //         // as ImageProvider?,
                      //       ),
                      //       onLongPress: () {
                      //         setState(() {
                      //           showDialog(
                      //             context: context,
                      //             builder: (context) => AlertDialog(
                      //               title: Text(
                      //                 "This contact is confirm delete??",
                      //               ),
                      //               content: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceEvenly,
                      //                 children: [
                      //                   ElevatedButton(
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         Navigator.of(context).pop();
                      //                       });
                      //                     },
                      //                     child: Text("Dissmiss"),
                      //                   ),
                      //                   ElevatedButton(
                      //                     onPressed: () async {
                      //                       await FireStoreHelper
                      //                           .fireStoreHelper
                      //                           .deleteUser(
                      //                               id: allDocs[index].id);
                      //                       setState(() {
                      //                         Navigator.of(context).pop();
                      //                       });
                      //                     },
                      //                     child: Text("ok"),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           );
                      //         });
                      //       },
                      //       title: Text(
                      //         "${allDocs[index].data()['email']}",
                      //       ),
                      //       subtitle: Text(
                      //         "${allDocs[index].data()['uid']}",
                      //       ),
                      //       trailing: Row(
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           IconButton(
                      //             onPressed: () async {
                      //               await FireStoreHelper.fireStoreHelper
                      //                   .updateUser(
                      //                 id: allDocs[index].id,
                      //                 email: 'Khushi Mangukiya',
                      //               );
                      //             },
                      //             icon: Icon(
                      //               Icons.edit,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
