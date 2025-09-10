import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  String verificationId = '';
  bool codeSent = false;

  void sendCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      verificationCompleted: (cred) async {
        await FirebaseAuth.instance.signInWithCredential(cred);
        Navigator.pushReplacementNamed(context, '/dashboard');
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Error')));
      },
      codeSent: (verId, _) {
        setState(() { verificationId = verId; codeSent = true; });
      },
      codeAutoRetrievalTimeout: (verId) { verificationId = verId; }
    );
  }

  void verifyCode() async {
    final cred = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: codeController.text.trim());
    await FirebaseAuth.instance.signInWithCredential(cred);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone (+91...)')),
            SizedBox(height: 12),
            ElevatedButton(onPressed: sendCode, child: Text('Send OTP')),
            if (codeSent) ...[
              TextField(controller: codeController, decoration: InputDecoration(labelText: 'OTP')),
              SizedBox(height: 12),
              ElevatedButton(onPressed: verifyCode, child: Text('Verify')),
            ]
          ],
        ),
      ),
    );
  }
}
