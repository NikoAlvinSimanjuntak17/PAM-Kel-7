import 'package:flutter/material.dart';
import 'package:it_del/Mahasiswa.views/RequestSurat.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/request_surat.dart';
import 'package:it_del/Auth/login_screen.dart';
import 'package:it_del/Services/Surat_service.dart';
import 'package:it_del/Services/User_service.dart';
import 'package:it_del/Services/globals.dart';

class FormIzinSurats extends StatefulWidget {
  final RequestIzinSurat? formIzinSurat;
  final String? title;

  FormIzinSurats({this.formIzinSurat, this.title});
  @override
  _FormIzinSuratState createState() => _FormIzinSuratState();
}

class _FormIzinSuratState extends State<FormIzinSurats> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  bool _loading = false;

  void _editizinsurat(int id) async {
    ApiResponse response = await updateIzinSurat(
        id, _reasonController.text, _alamatController.text);
    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestIzinSuratScreen(),
        ),
      );
    } else if (response.error == unauthrorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            )
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _createizinsurat() async {
    ApiResponse response =
        await CreateIzinSurat(_reasonController.text, _alamatController.text);

    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestIzinSuratScreen(),
        ),
      );
    } else if (response.error == unauthrorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            )
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {
    if (widget.formIzinSurat != null) {
      final reason = widget.formIzinSurat!.reason;
      final alamat = widget.formIzinSurat!.alamat;

      _reasonController.text = reason ?? '';
      _alamatController.text = alamat ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Reason TextField
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Keperluan Surat',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Tujuan Alamat Surat',
                ),
              ),
              SizedBox(height: 16.0),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _loading = !_loading;
                    });
                    if (widget.formIzinSurat == null) {
                      _createizinsurat();
                    } else {
                      _editizinsurat(widget.formIzinSurat!.id ?? 0);
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
