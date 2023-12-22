import 'package:flutter/material.dart';
import 'package:it_del/Auth/login_screen.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/user.dart';
import 'package:it_del/Services/User_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../rounded_button.dart';
import '../Mahasiswa.views/MahasiswaScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController txtname = TextEditingController();
  TextEditingController txtnim = TextEditingController();
  TextEditingController txtnomorhandphone = TextEditingController();
  TextEditingController txtnomorktp = TextEditingController();
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  createAccountPressed() async {
    ApiResponse response = await register(
      txtname.text,
      txtnomorktp.text,
      txtnomorhandphone.text,
      txtnim.text,
      txtemail.text,
      txtpassword.text,
    );
    if (response.error == null) {
      // Extract the role from the response
      _saveAndRedirectHome(response.data as User);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MahasiswaScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Register',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: txtname,
                validator: (val) =>
                    val!.isEmpty ? 'Nama Tidak Boleh Kosong' : null,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: txtnim,
                validator: (val) =>
                    val!.isEmpty ? 'Nim tidak boleh kosong' : null,
                decoration: InputDecoration(
                  labelText: 'NIM',
                  hintText: 'Enter your NIM',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: txtnomorhandphone,
                validator: (val) =>
                    val!.isEmpty ? 'Nomor Handphone tidak boleh kosong' : null,
                decoration: InputDecoration(
                  labelText: 'Nomor Handphone',
                  hintText: 'Enter your Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: txtnomorktp,
                validator: (val) =>
                    val!.isEmpty ? 'Nomor Ktp tidak boleh kosong' : null,
                decoration: InputDecoration(
                  labelText: 'Nomor KTP',
                  hintText: 'Enter your KTP Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtemail,
                validator: (val) =>
                    val!.isEmpty ? 'Invalid email address' : null,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: txtpassword,
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Membutuh setidaknya 6 huruf' : null,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              RoundedButton(
                btnText: 'Register',
                onBtnPressed: () => createAccountPressed(),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                ),
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
