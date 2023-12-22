import 'package:flutter/material.dart';
import 'package:it_del/Mahasiswa.views/FormBookingRuangan.dart';
import 'package:it_del/Mahasiswa.views/MahasiswaScreen.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/booking_ruangan.dart';
import 'package:it_del/Services/bookingruangan_service.dart';
import 'package:it_del/Models/ruangan.dart';
import 'package:it_del/Services/globals.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<BookingRuangan> bookingList = [];
  List<Ruangan> roomList = [];
  bool _loading = true; // Add _loading variable

  void deleteBookingRuangan(int id) async {
    try {
      ApiResponse response = await DeleteBookingRuangan(id);

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
      print("Error in deleteBookingRuangan: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookingRequests();
  }

  Future<void> fetchBookingRequests() async {
    try {
      ApiResponse apiResponse = await getRequestRuangan();
      if (apiResponse.data != null) {
        setState(() {
          bookingList = List<BookingRuangan>.from(apiResponse.data);
          _loading = false; // Set _loading to false when data is loaded
        });
        await fetchRoomList();
      } else {
        print(apiResponse.error);
        setState(() {
          _loading = false; // Set _loading to false in case of an error
        });
      }
    } catch (e) {
      print("Error in fetchBookingRequests: $e");
      setState(() {
        _loading = false; // Set _loading to false in case of an error
      });
    }
  }

  Future<void> fetchRoomList() async {
    ApiResponse roomResponse = await getRuangan();
    if (roomResponse.data != null) {
      setState(() {
        roomList = List<Ruangan>.from(roomResponse.data);
      });
    } else {
      print(roomResponse.error);
    }
  }

  String getRoomName(int? roomId) {
    Ruangan? room = roomList.firstWhere(
      (room) => room.id == roomId,
      orElse: () => Ruangan(),
    );
    return room?.NamaRuangan ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blueAccent,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Booking Ruangan Requests'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingFormScreen(),
                  ),
                ).then((value) {
                  if (value == true) {
                    fetchBookingRequests();
                  }
                });
              },
            ),
          ],
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  dataRowHeight: 56,
                  columns: [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Room')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: bookingList.map((booking) {
                    int index = bookingList.indexOf(booking);
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text('Room: ${getRoomName(booking.roomId)}')),
                        DataCell(Text(booking.status ?? 'N/A')),
                        DataCell(
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: Text('Edit'),
                                  value: 'edit',
                                ),
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
                                // Add edit functionality if needed
                              } else if (value == 'view') {
                                // Add view functionality if needed
                              } else if (value == 'delete') {
                                int index = bookingList.indexOf(booking);
                                BookingRuangan selectedBooking =
                                    bookingList[index];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Delete Booking Ruangan"),
                                      content: Text(
                                        "Are you sure you want to delete this request?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteBookingRuangan(
                                              selectedBooking.id ?? 0,
                                            );
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
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingFormScreen(),
              ),
            ).then((value) {
              if (value == true) {
                fetchBookingRequests();
              }
            });
          },
          label: Text('Request Here'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MahasiswaScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    '<- Back to Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
