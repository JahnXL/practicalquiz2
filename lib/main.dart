// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  Future<void> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  Future<void> _signInWithEmail() async {
    await _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  Future<void> _signUpWithEmail() async {
    await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  Future<void> _signInWithGithub() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    await _auth.signInWithProvider(githubProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Auth")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signInWithEmail, child: Text("Sign In")),
            ElevatedButton(onPressed: _signUpWithEmail, child: Text("Sign Up")),
            SignInButton(Buttons.Google, onPressed: _signInWithGoogle),
            SignInButton(Buttons.GitHub, onPressed: _signInWithGithub),
          ],
        ),
      ),
    );
  }
}
