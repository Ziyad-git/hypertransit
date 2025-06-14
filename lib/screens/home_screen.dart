import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hypertransit/screens/busmap.dart';
import 'package:hypertransit/screens/login_screen.dart';
import 'package:hypertransit/screens/pass_screen.dart';
import 'package:hypertransit/screens/profile_page.dart';
import 'package:get/get.dart';
import 'package:hypertransit/screens/purchase_pass_screen.dart';
import 'package:hypertransit/screens/scan_pass.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  void getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Student')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? "Unknown";
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() => isLoading = false);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF005c99),
                      Color(0xFF00375c),
                    ]),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        title: Text(
                          'Hello,',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          userName ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.person, color: Colors.white, size: 40),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  currentUserId: FirebaseAuth.instance.currentUser!.uid,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(200))),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 30,
                    children: [
                      itemDashboard('Track Bus', Icons.bus_alert,
                          Colors.deepOrange, context, Busmap()),
                      itemDashboard('View Pass',
                          Icons.perm_contact_cal_outlined, Colors.blue, context, PassScreen()),
                      itemDashboard('Purchase Pass',
                          Icons.text_snippet_outlined, Colors.green, context, PurchasePass()),
                      // itemDashboard('Scan Pass', Icons.scanner,
                      //     Colors.indigo, context, ScanPass()),
                      itemDashboard('LogOut', Icons.logout, Colors.teal, context, LoginScreen()),
                    ],
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background, BuildContext context, Widget screen) =>
      GestureDetector(
          onTap: () {
            if (title == 'LogOut') {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => screen));
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 5),
                      color: Theme.of(context).primaryColor.withOpacity(.2),
                      spreadRadius: 2,
                      blurRadius: 5)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, color: Colors.white)),
                const SizedBox(height: 8),
                Text(title.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium)
              ],
            ),
          ));
}
