import 'package:flutter/material.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/bookingbajuBaak.dart';
import 'package:it_del/Services/bookingbajuBaak_service.dart';

class BookingBajuBaakView extends StatefulWidget {
  @override
  _BookingBajuBaakViewState createState() => _BookingBajuBaakViewState();
}

class _BookingBajuBaakViewState extends State<BookingBajuBaakView> {
  late Future<ApiResponse<List<BookingBajuBaak>>> _bookingBajuData;

  @override
  void initState() {
    super.initState();
    _bookingBajuData = BookingBajuBaakController.viewAllRequestsForBaak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Booking Baju'),
        backgroundColor:
            Colors.blue, // Set the same color as IzinKeluarBaakView
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Refresh data
                _bookingBajuData =
                    BookingBajuBaakController.viewAllRequestsForBaak();
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
        child: FutureBuilder<ApiResponse<List<BookingBajuBaak>>>(
          future: _bookingBajuData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.error != null) {
              final error = snapshot.data?.error ?? 'Failed to load data.';
              return Center(child: Text(error));
            } else {
              List<BookingBajuBaak> bookingBajuList = snapshot.data!.data!;
              return ListView.builder(
                itemCount: bookingBajuList.length,
                itemBuilder: (context, index) {
                  BookingBajuBaak bookingBaju = bookingBajuList[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('ID: ${bookingBaju.userId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Baju: ${bookingBaju.ukuranBaju}'),
                          Text('Baju: ${bookingBaju.bajuId}'),
                          Text('Baju: ${bookingBaju.metodePembayaran}'),
                          Text('Status: ${bookingBaju.status}'),
                          Text(
                              'Tanggal Pengambilan: ${bookingBaju.tanggalPengambilan}'),
                        ],
                      ),
                      trailing: bookingBaju.status == 'approved'
                          ? Icon(Icons.check, color: Colors.green)
                          : bookingBaju.status == 'rejected'
                              ? Icon(Icons.clear, color: Colors.red)
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        approveIzin(bookingBaju.id);
                                      },
                                      child: Text('Approve'),
                                    ),
                                    SizedBox(width: 8.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        rejectIzin(bookingBaju.id);
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
        await BookingBajuBaakController.approveBookingBaju(izinId);
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
        _bookingBajuData = BookingBajuBaakController.viewAllRequestsForBaak();
      });
    }
  }

  void rejectIzin(int izinId) async {
    ApiResponse<String> response =
        await BookingBajuBaakController.rejectBookingBaju(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _bookingBajuData = BookingBajuBaakController.viewAllRequestsForBaak();
      });
    }
  }
}
