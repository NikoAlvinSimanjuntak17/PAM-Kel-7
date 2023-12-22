import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it_del/Mahasiswa.views/RequestIzinKeluar.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/request_izin_keluar.dart';
import 'package:it_del/Auth/login_screen.dart';
import 'package:it_del/Services/IzinKeluar_service.dart';
import 'package:it_del/Services/User_service.dart';
import 'package:it_del/Services/globals.dart';

class FormIzinKeluars extends StatefulWidget {
  final RequestIzinKeluar? formIzinKeluar;
  final String? title;

  FormIzinKeluars({this.formIzinKeluar, this.title});
  @override
  _FormIzinKeluarState createState() => _FormIzinKeluarState();
}

class _FormIzinKeluarState extends State<FormIzinKeluars> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _departureDateTimeController =
      TextEditingController();
  final TextEditingController _returnDateTimeController =
      TextEditingController();
  bool _loading = false;

  void _editizinkeluar(int id) async {
    DateTime departureDateTime =
        DateTime.parse(_departureDateTimeController.text);
    DateTime returnDateTime = DateTime.parse(_returnDateTimeController.text);
    ApiResponse response = await updateIzinKeluar(
        id, _reasonController.text, departureDateTime, returnDateTime);
    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestIzinKeluarScreen(),
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

  void _createizinkeluar() async {
    DateTime departureDateTime =
        DateTime.parse(_departureDateTimeController.text);
    DateTime returnDateTime = DateTime.parse(_returnDateTimeController.text);

    ApiResponse response = await CreateIzinKeluar(
        _reasonController.text, departureDateTime, returnDateTime);

    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestIzinKeluarScreen(),
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
    if (widget.formIzinKeluar != null) {
      final startDate = widget.formIzinKeluar!.startDate;
      final EndDate = widget.formIzinKeluar!.endDate;
      final reason = widget.formIzinKeluar!.reason;
      _reasonController.text = reason ?? '';
      if (startDate != null) {
        _departureDateTimeController.text =
            DateFormat("yyyy-MM-dd HH:mm").format(startDate);
      }
      if (EndDate != null) {
        _returnDateTimeController.text =
            DateFormat("yyyy-MM-dd HH:mm").format(EndDate);
      }
    }

    super.initState();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != controller) {
      _selectTime(context, controller, picked);
    }
  }

  Future<void> _selectTime(BuildContext context,
      TextEditingController controller, DateTime pickedDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final DateTime combinedDateTime = DateTime(pickedDate.year,
          pickedDate.month, pickedDate.day, picked.hour, picked.minute);
      final formattedDateTime =
          DateFormat("yyyy-MM-dd HH:mm").format(combinedDateTime);
      controller.text = formattedDateTime;
    }
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
                  labelText: 'Keperluan IK',
                ),
              ),
              SizedBox(height: 16.0),

              // Tanggal Keluar (Departure Date) DatePicker
              TextFormField(
                controller: _departureDateTimeController,
                onTap: () => _selectDate(context, _departureDateTimeController),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Keluar',
                ),
              ),
              SizedBox(height: 16.0),

              // Tanggal Masuk (Return Date) DatePicker
              TextFormField(
                controller: _returnDateTimeController,
                onTap: () => _selectDate(context, _returnDateTimeController),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Masuk',
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
                    if (widget.formIzinKeluar == null) {
                      _createizinkeluar();
                    } else {
                      _editizinkeluar(widget.formIzinKeluar!.id ?? 0);
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
