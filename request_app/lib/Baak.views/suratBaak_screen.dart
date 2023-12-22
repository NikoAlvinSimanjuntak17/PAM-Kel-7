import 'package:flutter/material.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/suratBaak.dart';
import 'package:it_del/Services/SuratBaak_service.dart';

class IzinSuratBaakView extends StatefulWidget {
  @override
  _IzinSuratBaakViewState createState() => _IzinSuratBaakViewState();
}

class _IzinSuratBaakViewState extends State<IzinSuratBaakView> {
  late Future<ApiResponse<List<IzinSuratBaak>>> _izinSuratData;

  @override
  void initState() {
    super.initState();
    _izinSuratData = IzinSuratBaakController.viewAllRequestsForBaak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Request Izin Surat'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Refresh data
                _izinSuratData =
                    IzinSuratBaakController.viewAllRequestsForBaak();
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
        child: FutureBuilder<ApiResponse<List<IzinSuratBaak>>>(
          future: _izinSuratData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.error != null) {
              return Center(child: Text('Failed to load data.'));
            } else {
              List<IzinSuratBaak> izinSuratList = snapshot.data!.data!;
              return ListView.builder(
                itemCount: izinSuratList.length,
                itemBuilder: (context, index) {
                  IzinSuratBaak izinSurat = izinSuratList[index];
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Reason: ${izinSurat.reason}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tujuan Alamat Surat: ${izinSurat.alamat}'),
                          Text('Status: ${izinSurat.status}'),
                        ],
                      ),
                      trailing: izinSurat.status == 'approved'
                          ? Icon(Icons.check, color: Colors.green)
                          : izinSurat.status == 'rejected'
                              ? Icon(Icons.clear, color: Colors.red)
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        approveIzin(izinSurat.id);
                                      },
                                      child: Text('Approve'),
                                    ),
                                    SizedBox(width: 8.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        rejectIzin(izinSurat.id);
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
        await IzinSuratBaakController.approveIzinSurat(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinSuratData = IzinSuratBaakController.viewAllRequestsForBaak();
      });
    }
  }

  void rejectIzin(int izinId) async {
    ApiResponse<String> response =
        await IzinSuratBaakController.rejectIzinSurat(izinId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject: ${response.error}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.data}')),
      );
      setState(() {
        _izinSuratData = IzinSuratBaakController.viewAllRequestsForBaak();
      });
    }
  }
}
