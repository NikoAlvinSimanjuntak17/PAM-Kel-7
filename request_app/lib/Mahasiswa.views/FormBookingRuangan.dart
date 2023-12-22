import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/ruangan.dart';
import 'package:it_del/Services/bookingruangan_service.dart';

class BookingFormScreen extends StatefulWidget {
  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  int selectedRoomId = 1;
  TextEditingController reasonController = TextEditingController();
  TextEditingController startDateTimeController = TextEditingController();
  TextEditingController endDateTimeController = TextEditingController();
  List<Ruangan> availableRooms = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchAvailableRooms();
  }

  Future<void> fetchAvailableRooms() async {
    ApiResponse apiResponse = await getRuangan();
    if (apiResponse.data != null) {
      setState(() {
        availableRooms = List<Ruangan>.from(apiResponse.data);
        if (availableRooms.isNotEmpty) {
          selectedRoomId = availableRooms[0].id!;
        }
      });
    } else {
      // Handle error
      print(apiResponse.error);
      _showErrorSnackBar(apiResponse.error);
    }
  }

  void _showErrorSnackBar(String? error) {
    if (error != null) {
      final snackBar = SnackBar(
        content: Text('Ruangan sudah dibooking'), // Ubah pesan error di sini
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
        title: Text('Create Booking Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField(
              value: selectedRoomId,
              onChanged: (value) {
                setState(() {
                  selectedRoomId = value as int;
                });
              },
              items: getRoomDropdownItems(),
              decoration: InputDecoration(labelText: 'Select Room'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: reasonController,
              decoration: InputDecoration(labelText: 'Reason'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: startDateTimeController,
              onTap: () => _selectDate(context, startDateTimeController),
              readOnly: true,
              decoration: InputDecoration(labelText: 'Start Date & Time'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: endDateTimeController,
              onTap: () => _selectDate(context, endDateTimeController),
              readOnly: true,
              decoration: InputDecoration(labelText: 'End Date & Time'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                ApiResponse apiResponse = await createRequestRuangan(
                  selectedRoomId,
                  reasonController.text,
                  DateTime.parse(startDateTimeController.text),
                  DateTime.parse(endDateTimeController.text),
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

  List<DropdownMenuItem<int>> getRoomDropdownItems() {
    return availableRooms.map((room) {
      return DropdownMenuItem<int>(
        value: room.id!,
        child: Text(room.NamaRuangan!),
      );
    }).toList();
  }
}
