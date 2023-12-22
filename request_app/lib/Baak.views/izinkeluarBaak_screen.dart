import 'package:flutter/material.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/izinkeluarBaak.dart';
import 'package:it_del/Services/izinkeluarBaak_service.dart';

class IzinKeluarBaakView extends StatefulWidget {
  @override
  _IzinKeluarBaakViewState createState() => _IzinKeluarBaakViewState();
}

class _IzinKeluarBaakViewState extends State<IzinKeluarBaakView> {
  late Future<ApiResponse<List<IzinKeluarBaak>>> _izinKeluarData;

  @override
  void initState() {
    super.initState();
    _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Request Izin Keluar'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Refresh data
                _izinKeluarData =
                    IzinKeluarBaakController.viewAllRequestsForBaak();
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
        child: FutureBuilder<ApiResponse<List<IzinKeluarBaak>>>(
          future: _izinKeluarData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.error != null) {
              return Center(child: Text('Failed to load data.'));
            } else {
              List<IzinKeluarBaak> izinKeluarList = snapshot.data!.data!;
              return ListView.builder(
                itemCount: izinKeluarList.length,
                itemBuilder: (context, index) {
                  IzinKeluarBaak izinKeluar = izinKeluarList[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Reason: ${izinKeluar.reason}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${izinKeluar.status}'),
                          Text('Start Date: ${izinKeluar.startDate}'),
                          Text('End Date: ${izinKeluar.endDate}'),
                        ],
                      ),
                      trailing: izinKeluar.status == 'approved'
                          ? Icon(Icons.check, color: Colors.green)
                          : izinKeluar.status == 'rejected'
                              ? Icon(Icons.clear, color: Colors.red)
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        approveIzin(izinKeluar.id);
                                      },
                                      child: Text('Approve'),
                                    ),
                                    SizedBox(width: 8.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        rejectIzin(izinKeluar.id);
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
        await IzinKeluarBaakController.approveIzinKeluar(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
      });
    }
  }

  void rejectIzin(int izinId) async {
    ApiResponse<String> response =
        await IzinKeluarBaakController.rejectIzinKeluar(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinKeluarData = IzinKeluarBaakController.viewAllRequestsForBaak();
      });
    }
  }
}
