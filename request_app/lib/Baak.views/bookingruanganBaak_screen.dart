import 'package:flutter/material.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/bookingruanganBaak.dart';
import 'package:it_del/Services/bookingruanganBaak_service.dart';

class BookingRuanganBaakView extends StatefulWidget {
  @override
  _BookingRuanganBaakViewState createState() => _BookingRuanganBaakViewState();
}

class _BookingRuanganBaakViewState extends State<BookingRuanganBaakView> {
  late Future<ApiResponse<List<BookingRuanganBaak>>> _bookingRuanganData;

  @override
  void initState() {
    super.initState();
    _bookingRuanganData = BookingRuanganBaakController.viewAllRequestsForBaak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Booking Ruangan'),
        backgroundColor:
            Colors.blue, // Set the same color as IzinKeluarBaakView
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Refresh data
                _bookingRuanganData =
                    BookingRuanganBaakController.viewAllRequestsForBaak();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.indigo],
          ),
        ),
        child: FutureBuilder<ApiResponse<List<BookingRuanganBaak>>>(
          future: _bookingRuanganData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.error != null) {
              final error = snapshot.data?.error ?? 'Failed to load data.';
              return Center(child: Text(error));
            } else {
              List<BookingRuanganBaak> bookingRuanganList =
                  snapshot.data!.data!;
              return ListView.builder(
                itemCount: bookingRuanganList.length,
                itemBuilder: (context, index) {
                  BookingRuanganBaak bookingRuangan = bookingRuanganList[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('ID: ${bookingRuangan.userId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reason: ${bookingRuangan.reason}'),
                          Text('Status: ${bookingRuangan.status}'),
                          Text('Room: ${bookingRuangan.roomId}'),
                          Text('Start Date: ${bookingRuangan.startTime}'),
                          Text('End Date: ${bookingRuangan.endTime}'),
                        ],
                      ),
                      trailing: bookingRuangan.status == 'approved'
                          ? Icon(Icons.check, color: Colors.green)
                          : bookingRuangan.status == 'rejected'
                              ? Icon(Icons.clear, color: Colors.red)
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        approveIzin(bookingRuangan.id);
                                      },
                                      child: Text('Approve'),
                                    ),
                                    SizedBox(width: 8.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        rejectIzin(bookingRuangan.id);
                                      },
                                      child: Text('Reject'),
                                    ),
                                  ],
                                ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void approveIzin(int izinId) async {
    ApiResponse<String> response =
        await BookingRuanganBaakController.approveBookingRuangan(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        // Refresh data after approval
        _bookingRuanganData =
            BookingRuanganBaakController.viewAllRequestsForBaak();
      });
    }
  }

  void rejectIzin(int izinId) async {
    ApiResponse<String> response =
        await BookingRuanganBaakController.rejectBookingRuangan(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _bookingRuanganData =
            BookingRuanganBaakController.viewAllRequestsForBaak();
      });
    }
  }
}
