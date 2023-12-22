import 'package:it_del/Services/bookingbaju_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/baju.dart';

class FormBookingBaju extends StatefulWidget {
  @override
  _FormBookingBajuState createState() => _FormBookingBajuState();
}

class _FormBookingBajuState extends State<FormBookingBaju> {
  int selectedBajuId = 1;
  TextEditingController metodePembayaranController = TextEditingController();
  TextEditingController tanggalPengambilanController = TextEditingController();
  List<Baju> availableBaju = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchAvailableRooms();
    metodePembayaranController.text = "transfer";
  }

  void _showErrorSnackBar(String? error) {
    if (error != null) {
      final snackBar = SnackBar(
        content: Text('tidak bisa'), // Ubah pesan error di sini
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Pemesanan Baju'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField(
              value: selectedBajuId,
              onChanged: (value) {
                setState(() {
                  selectedBajuId = value as int;
                });
              },
              items: getRoomDropdownItems(),
              decoration: InputDecoration(labelText: 'Pilih Ukuran Baju'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: metodePembayaranController,
              enabled: false,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'Metode Pembayaran'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: tanggalPengambilanController,
              onTap: () => _selectDate(context, tanggalPengambilanController),
              readOnly: true,
              decoration: InputDecoration(labelText: 'Pengambilan Baju'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                ApiResponse apiResponse = await createRequestBaju(
                  selectedBajuId,
                  metodePembayaranController.text,
                  DateTime.parse(tanggalPengambilanController
                      .text), // Hanya perlu satu kali DateTime.parse untuk tanggal pengambilan
                );
                if (apiResponse.data != null) {
                  Navigator.pop(context, true);
                } else {
                  // Handle error
                  print(apiResponse.error);
                  _showErrorSnackBar(apiResponse.error);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAvailableRooms() async {
    ApiResponse apiResponse = await getBaju();
    if (apiResponse.data != null) {
      setState(() {
        availableBaju = List<Baju>.from(apiResponse.data);
        if (availableBaju.isNotEmpty) {
          selectedBajuId = availableBaju[0].id!;
        }
      });
    } else {
      // Handle error
      print(apiResponse.error);
      _showErrorSnackBar(apiResponse.error);
    }
  }

  List<DropdownMenuItem<int>> getRoomDropdownItems() {
    return availableBaju.map((baju) {
      return DropdownMenuItem<int>(
        value: baju.id!,
        child: Text(baju.ukuran!),
      );
    }).toList();
  }
}
