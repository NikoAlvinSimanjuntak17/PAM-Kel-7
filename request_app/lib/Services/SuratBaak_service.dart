import 'dart:convert';
import 'package:it_del/Services/User_service.dart';
import 'package:http/http.dart' as http;
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/suratBaak.dart';
import 'package:it_del/Services/globals.dart';

class IzinSuratBaakController {
  static Future<ApiResponse<String>> approveIzinSurat(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'izin-surat/$izinId/approve'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Surat Telah Disetujui';
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
      print("Error in approveIzinSurat: $e");
    }

    return apiResponse;
  }

  static Future<ApiResponse<String>> rejectIzinSurat(int izinId) async {
    ApiResponse<String> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.put(
        Uri.parse(baseURL + 'izin-surat/$izinId/reject'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          apiResponse.data = 'Permintaan Izin Surat Telah Ditolak';
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
      print("Error in rejectIzinSurat: $e");
    }

    return apiResponse;
  }

  static Future<ApiResponse<List<IzinSuratBaak>>>
      viewAllRequestsForBaak() async {
    ApiResponse<List<IzinSuratBaak>> apiResponse = ApiResponse();

    try {
      String token = await getToken();

      final response = await http.get(
        Uri.parse(baseURL + 'izin-surat/all'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          Iterable data = json.decode(response.body)['RequestIzinSurat'];
          List<IzinSuratBaak> izinSuratList =
              data.map((json) => IzinSuratBaak.fromJson(json)).toList();
          apiResponse.data = izinSuratList;
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
