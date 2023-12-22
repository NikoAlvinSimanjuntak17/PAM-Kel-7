import 'package:it_del/Models/baju.dart';
import 'package:it_del/Services/globals.dart';
import 'package:flutter/material.dart';
import 'package:it_del/Mahasiswa.views/FormBookingBaju.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/bookingbaju.dart';
import 'package:it_del/Services/bookingbaju_service.dart';

class BookingBajuScreen extends StatefulWidget {
  @override
  _BookingBajuScreenState createState() => _BookingBajuScreenState();
}

class _BookingBajuScreenState extends State<BookingBajuScreen> {
  List<BookingBaju> bookingList = [];
  List<Baju> bajuList = [];

  void deleteIzinBermalam(int id) async {
    try {
      ApiResponse response = await DeleteBookingBaju(id);

      if (response.error == null) {
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context);
        fetchBookingRequests();
      } else if (response.error == unauthrorized) {
        // ... (unchanged)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    } catch (e) {
      print("Error in deleteIzinBermalam: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookingRequests();
  }

  Future<void> fetchBookingRequests() async {
    ApiResponse apiResponse = await getRequestBaju();
    if (apiResponse.data != null) {
      setState(() {
        bookingList = List<BookingBaju>.from(apiResponse.data);
      });
      await fetchRoomList();
    } else {
      print(apiResponse.error);
    }
  }

  Future<void> fetchRoomList() async {
    ApiResponse roomResponse = await getBaju();
    if (roomResponse.data != null) {
      setState(() {
        bajuList = List<Baju>.from(roomResponse.data);
      });
    } else {
      print(roomResponse.error);
    }
  }

  String getBajuUkuran(int? bajuId) {
    Baju? baju = bajuList.firstWhere(
      (baju) => baju.id == bajuId,
      orElse: () => Baju(),
    );
    return baju.ukuran ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Requests'),
      ),
      body: DataTable(
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        dataRowHeight: 56,
        columns: [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Ukuran')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')), // Added a column for actions
        ],
        rows: bookingList.map((booking) {
          int index = bookingList.indexOf(booking);
          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text('${getBajuUkuran(booking.bajuId)}')),
              DataCell(Text(booking.status)),
              DataCell(
                PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text('View'),
                        value: 'view',
                      ),
                      PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      ),
                    ];
                  },
                  onSelected: (String value) {
                    if (value == 'edit') {
                    } else if (value == 'view') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("View Booking Ruangan"),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ukuran: ${booking.bajuId}"),
                                SizedBox(height: 8),
                                Text(
                                    "Waktu PEngambilan: ${booking.tanggalPengambilan}"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                            ],
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical:
                                    8), // Sesuaikan nilai sesuai kebutuhan
                          );
                        },
                      );
                    } else if (value == 'delete') {
                      int index = bookingList.indexOf(booking);
                      BookingBaju selectedIzinKeluar = bookingList[index];
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete Izin Keluar"),
                            content: Text(
                                "Are you sure you want to delete this request?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteIzinBermalam(selectedIzinKeluar.id);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormBookingBaju(),
            ),
          ).then((value) {
            if (value == true) {
              fetchBookingRequests();
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
