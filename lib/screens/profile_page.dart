import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hypertransit/screens/driver.dart';
import 'package:hypertransit/screens/home_screen.dart';

class ProfilePage extends StatefulWidget {
  final String currentUserId;

  const ProfilePage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  final TextEditingController driverIdController = TextEditingController();

  void getData() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Student')
          .doc(widget.currentUserId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        isLoading = false; // Ensure loading state is updated
      });
    }
  }

  void switchToDriverMode() async {
    String enteredDriverId = driverIdController.text.trim();

    if (enteredDriverId.isNotEmpty) {
      try {
        final DocumentSnapshot driverDoc = await FirebaseFirestore.instance
            .collection('driverid') // Firestore collection for drivers
            .doc(enteredDriverId)
            .get();

        if (driverDoc.exists) {
          // Navigate to Driver Screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => DriverScreen()),
          );
        } else {
          showSnackBar("Invalid Driver ID. Please try again.");
        }
      } catch (e) {
        showSnackBar("Error verifying Driver ID: $e");
      }
    } else {
      showSnackBar("Please enter a valid Driver ID.");
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  // Display user profile data only if available
                  if (userData != null)
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(
                                "Name: ${userData!['name'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.cake),
                              title: Text("Age: ${userData!['age'] ?? 'N/A'}"),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.transgender),
                              title: Text("Gender: ${userData!['gender'] ?? 'N/A'}"),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: Text("Contact: ${userData!['contact-no'] ?? 'N/A'}"),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.directions_bus),
                              title: Text("Bus Number: ${userData!['bus-number'] ?? 'N/A'}"),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Center(
                      child: Text(
                        'No Profile Data Found\nPurchase Pass To Automatically Update Your Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Driver ID Input Field
                  TextField(
                    controller: driverIdController,
                    decoration: InputDecoration(
                      labelText: 'Enter Driver ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.badge),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Driver Mode Button
                  ElevatedButton.icon(
                    onPressed: switchToDriverMode, // Calls the function directly
                    icon: const Icon(Icons.directions_car),
                    label: const Text('Switch to Driver Mode'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
