import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:hypertransit/screens/login_screen.dart";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

void dispose() {
    emailController.dispose();
    super.dispose();
}

Future passwordReset() async {
  try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text('Password reset link sent to your mail'),
      );
    });
  }on FirebaseAuthException catch(e){
    print(e);
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text('user not found'),
      );

    });
    }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'Forgot Password',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          color: Colors.black,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          const Text(
            'Reset Your Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),

          // Subtitle
          const Text(
            'Enter your email address below and we will send you a password reset link.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30.0),

          // Email Input Field
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
              filled: true,
              fillColor: Colors.grey[200],
              prefixIcon: const Icon(Icons.email, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Reset Password Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  passwordReset(); // Call the password reset function
                } else {
                  // Show an error if the email field is empty
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text('Please enter your email'),
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[700],
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Send Reset Link',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20.0),

          // Back to Login Text
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text(
              'Back to Login',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.indigo[700],
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}