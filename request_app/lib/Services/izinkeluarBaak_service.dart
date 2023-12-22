import 'dart:convert';
import 'package:it_del/Services/User_service.dart';
import 'package:http/http.dart' as http;
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/izinkeluarBaak.dart'; // Sesuaikan dengan lokasi file model IzinKeluar.dart Anda
import 'package:it_del/Services/globals.dart';

class IzinKeluarBaakController {
  static Future<ApiResponse<String>> approveIzinKeluar(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'izin-keluar/$izinId/approve'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Keluar Telah Disetujui';
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in approveIzinKeluar: $e");
    }

    return apiResponse;
  }

  static Future<ApiResponse<String>> rejectIzinKeluar(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'izin-keluar/$izinId/reject'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Keluar Telah Ditolak';
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in rejectIzinKeluar: $e");
    }

    return apiResponse;
  }

  static Future<ApiResponse<List<IzinKeluarBaak>>>
      viewAllRequestsForBaak() async {
    ApiResponse<List<IzinKeluarBaak>> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.get(
        Uri.parse(baseURL + 'izin-keluar/all'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          Iterable data = json.decode(response.body)['RequestIzinKeluar'];
          List<IzinKeluarBaak> izinKeluarList =
              data.map((json) => IzinKeluarBaak.fromJson(json)).toList();
          apiResponse.data = izinKeluarList;
          break;
        case 401:
          apiResponse.error = 'Unauthorized';
          break;
        default:
          apiResponse.error = 'Something went wrong';
          print("Server Response: ${response.body}");
          break;
      }
    } catch (e) {
      apiResponse.error = 'Server error: $e';
      print("Error in viewAllRequestsForBaak: $e");
    }

    return apiResponse;
  }
}
