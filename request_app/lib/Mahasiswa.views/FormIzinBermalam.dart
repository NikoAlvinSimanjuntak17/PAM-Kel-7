import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it_del/Mahasiswa.views/RequestIzinBermalam.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/request_izin_bermalam.dart';
import 'package:it_del/Auth/login_screen.dart';
import 'package:it_del/Services/IzinBermalam_service.dart';
import 'package:it_del/Services/User_service.dart';
import 'package:it_del/Services/globals.dart';

class FormIzinBermalams extends StatefulWidget {
  final RequestIzinBermalam? formIzinBermalam;
  final String? title;

  FormIzinBermalams({this.formIzinBermalam, this.title});
  @override
  _FormIzinBermalamState createState() => _FormIzinBermalamState();
}

class _FormIzinBermalamState extends State<FormIzinBermalams> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _departureDateTimeController =
      TextEditingController();
  final TextEditingController _returnDateTimeController =
      TextEditingController();
  bool _loading = false;

  void _editizinbermalam(int id) async {
    DateTime departureDateTime =
        DateTime.parse(_departureDateTimeController.text);
    DateTime returnDateTime = DateTime.parse(_returnDateTimeController.text);
    ApiResponse response = await updateIzinBermalam(
        id, _reasonController.text, departureDateTime, returnDateTime);
    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestIzinBermalamScreen(),
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

  void _createizinbermalam() async {
    DateTime departureDateTime =
        DateTime.parse(_departureDateTimeController.text);
    DateTime returnDateTime = DateTime.parse(_returnDateTimeController.text);

    ApiResponse response = await CreateIzinBermalam(
        _reasonController.text, departureDateTime, returnDateTime);

    if (response.error == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => RequestIzinBermalamScreen(),
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
    if (widget.formIzinBermalam != null) {
      final startDate = widget.formIzinBermalam!.startDate;
      final EndDate = widget.formIzinBermalam!.endDate;
      final reason = widget.formIzinBermalam!.reason;
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
                  labelText: 'Keperluan IB',
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
                    if (widget.formIzinBermalam == null) {
                      _createizinbermalam();
                    } else {
                      _editizinbermalam(widget.formIzinBermalam!.id ?? 0);
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
