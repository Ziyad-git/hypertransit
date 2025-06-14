import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hypertransit/screens/home_screen.dart';
import 'package:hypertransit/screens/pass_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PurchasePass extends StatefulWidget {
  const PurchasePass({Key? key}) : super(key: key);

  @override
  _PurchasePassState createState() => _PurchasePassState();
}

class _PurchasePassState extends State<PurchasePass> {
  List<Color> colors = [
    Color(0xFF005c99),
    Colors.white,
  ];
  TextEditingController passNameController = TextEditingController();
  TextEditingController passAgeController = TextEditingController();
  TextEditingController passContactNoController = TextEditingController();
  TextEditingController passBusNumberController = TextEditingController();
  TextEditingController passGenderController = TextEditingController();
  TextEditingController passBusStopController = TextEditingController();

  // List of bus stops with ticket rates
final Map<String, int> busStops = {
  "Kalady": 30,
  "Aluva": 90,
  "Perumbavoor": 70,
  "Thrissur": 100,
  "Kochi": 150,
  "Kalamassery": 140,
  "Angamaly": 40,

};

// Variable to store the selected bus stop
String? selectedBusStop;
String? gender; // Updated to store selected gender

  @override
  void dispose() {
    passNameController.dispose();
    passAgeController.dispose();
    passContactNoController.dispose();
    passBusNumberController.dispose();
    passGenderController.dispose();
    super.dispose();
  }

  String _validateInputs() {
    String errorMessage = '';

    // if (passNameController.text.isEmpty ||
    //     passAgeController.text.isEmpty ||
    //     passContactNoController.text.isEmpty ||
    //     passBusNumberController.text.isEmpty ||
    //     passGenderController.text.isEmpty ||
    //     gender == null) {
    //   errorMessage = "Please fill all fields";
    // }

    return errorMessage;
  }

  void pay() {
    // Search for buses based on the current state
    makePayment();
  }

void _handlePaymentSuccess(PaymentSuccessResponse response) {
  String passName = passNameController.text;
  String passAge = passAgeController.text;
  String passContact = passContactNoController.text;
  String passBusNumber = passBusNumberController.text;
  String passGender = passGenderController.text;

  User? user = FirebaseAuth.instance.currentUser;
  String? uid = user?.uid;

  FirebaseFirestore.instance.collection("Student").doc(uid).set({
    'name': passName,
    'age': passAge,
    'contact-no': passContact,
    'bus-number': passBusNumber,
    'gender': passGender,
    'bus-stop': selectedBusStop, // Save the selected bus stop
    'passPurchaseDate': DateTime.now(),
    'passExpiryDate': DateTime.now().add(Duration(days: 30)),
    'amount': busStops[selectedBusStop], // Save the ticket rate
    'userId': uid,
  });

  FirebaseFirestore.instance.collection("Student").doc(uid).update({
    'isPassBought': true,
  });

  GetStorage storage = GetStorage();
  storage.write('passAmount', busStops[selectedBusStop]);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => PassScreen()),
  );
}

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error HERE: ${response.code}- ${response.message}");
  }

  void _handleEXTERNALWALLET(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET IS: ${response.walletName}");
  }

  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleEXTERNALWALLET);
  }

  void makePayment() async {
  if (selectedBusStop == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a bus stop'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Get the ticket rate for the selected bus stop
  int amount = busStops[selectedBusStop]! * 100; // Convert to paise for Razorpay

  var options = {
    'key': 'rzp_test_Qd4MycImaTdQJD',
    'amount': amount, // Use the calculated amount
    'name': passNameController.text,
    'description': 'Bus Pass',
    'prefill': {
      'contact': passContactNoController.text,
      'email': "dev@gmail.com"
    },
  };

  try {
    _razorpay?.open(options);
  } catch (e) {
    debugPrint(e.toString());
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Purchase Pass',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 24.0)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use min to avoid overflow
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/purchase_pass.png',
                  height: 150,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Name TextFormField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextFormField(
                        controller: passNameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 5),

                    // Age TextFormField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextFormField(
                        controller: passAgeController,
                        decoration: InputDecoration(
                          labelText: "Age",
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 5),

                    // Gender TextFormField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextFormField(
                        controller: passGenderController,
                        decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 5),

                    // Contact Number TextFormField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextFormField(
                        controller: passContactNoController,
                        decoration: InputDecoration(
                          labelText: "Contact Number",
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 5),

                    // Bus Number TextFormField
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.grey[100],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextFormField(
                        controller: passBusNumberController,
                        decoration: InputDecoration(
                          labelText: "Bus Number",
                          labelStyle: TextStyle(color: Colors.black87),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 5),
                                    Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedBusStop,
                    decoration: InputDecoration(
                      labelText: "Select Bus Stop",
                      labelStyle: TextStyle(color: Colors.black87),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    items: busStops.keys.map((String stop) {
                      return DropdownMenuItem<String>(
                        value: stop,
                        child: Text(stop),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBusStop = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 5),

                    // Pay Button
                    MaterialButton(
                      color: const Color.fromARGB(255, 1, 72, 130),
                      height: 50, // Set a fixed height or use minHeight
                      minWidth: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      child: Text(
                        " Pay ",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        String errorMessage = _validateInputs();
                        if (errorMessage.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ElevatedButton(
                            onPressed: () {
                              CollectionReference collRef = FirebaseFirestore
                                  .instance
                                  .collection('Student');
                              collRef.add({
                                'passName': passNameController.text,
                                'passAge': passAgeController.text,
                                'passContact': passContactNoController.text,
                                'passBusNumber': passBusNumberController.text,
                                'passGender': passGenderController.text,
                              });
                            },
                            child: Text('Add Student'),
                          );
                          pay();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}