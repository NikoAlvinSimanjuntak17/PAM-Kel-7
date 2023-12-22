import 'package:flutter/material.dart';
import 'package:it_del/Mahasiswa.views/FormBookingBaju.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/baju.dart';
import 'package:it_del/Models/bookingbaju.dart';
import 'package:it_del/Services/bookingbaju_service.dart';
import 'package:it_del/Services/globals.dart';

class BookingBajuScreen extends StatefulWidget {
  @override
  _BookingBajuScreenState createState() => _BookingBajuScreenState();
}

class _BookingBajuScreenState extends State<BookingBajuScreen> {
  List<BookingBaju> bookingList = [];
  List<Baju> bajuList = [];
  bool _loading = true;

  void deleteBookingBaju(int id) async {
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
      print("Error in deleteBookingBaju: $e");
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
        _loading = false;
      });
      await fetchBajuList();
    } else {
      print(apiResponse.error);
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> fetchBajuList() async {
    ApiResponse bajuResponse = await getBaju();
    if (bajuResponse.data != null) {
      setState(() {
        bajuList = List<Baju>.from(bajuResponse.data);
      });
    } else {
      print(bajuResponse.error);
    }
  }

  String getBajuUkuran(int? bajuId) {
    Baju? baju = bajuList.firstWhere(
      (baju) => baju.id == bajuId,
      orElse: () => Baju(),
    );
    return baju?.ukuran ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Requests'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : DataTable(
              headingTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              dataRowHeight: 56,
              columns: [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Ukuran')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("View Booking Baju"),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Ukuran: ${getBajuUkuran(booking.bajuId)}"),
                                      SizedBox(height: 8),
                                      Text("Status: ${booking.status}"),
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
                                    vertical: 8,
                                  ),
                                );
                              },
                            );
                          } else if (value == 'delete') {
                            int index = bookingList.indexOf(booking);
                            BookingBaju selectedBooking = bookingList[index];
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Delete Booking Baju"),
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
                                        deleteBookingBaju(selectedBooking.id);
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
      floatingActionButton: FloatingActionButton.extended(
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
                  Navigator.of(context).pop();
                },
                child: Text(
                  '<- Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
