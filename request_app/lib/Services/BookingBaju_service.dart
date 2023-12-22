import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/bookingbaju.dart';
import 'package:it_del/Models/baju.dart';
import 'package:it_del/Services/globals.dart';
import 'package:it_del/Services/User_service.dart';

Future<ApiResponse> createRequestBaju(
    int bajuId, String metodePembayaran, DateTime tanggalPengambilan) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(baseURL + 'bookingbaju'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Menambahkan Content-Type
      },
      body: jsonEncode({
        'baju_id': bajuId,
        'metode_pembayaran': metodePembayaran,
        'tanggal_pengambilan': DateFormat("yyyy-MM-dd HH:mm:ss")
            .format(tanggalPengambilan.toLocal()),
      }),
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        if (errors.containsKey('ukuran_baju') &&
            errors['ukuran_baju'][0] == 'Baju not found') {
          apiResponse.error = 'Baju not found';
        } else {
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
        }
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print("Server Response: ${response.body}");
        break;
    }
  } catch (e) {
    print('Error in createRequestBaju: $e');
    apiResponse.error = 'Server error: $e';
  }
  return apiResponse;
}

Future<ApiResponse> getRequestBaju() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL + 'bookingbaju'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        final responseData = jsonDecode(response.body);
        if (responseData != null && responseData.containsKey('BookingBaju')) {
          apiResponse.data = (responseData['BookingBaju'] as List)
              .map((p) => BookingBaju.fromJson(p))
              .toList();
          print("JSON Response: $responseData");
        } else {
          apiResponse.error = 'Invalid data format';
        }
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        // Log the actual server response for debugging
        print("Server Response: ${response.body}");
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error: $e';
    print("Error in retrieving booking baju: $e");
  }
  return apiResponse;
}

Future<ApiResponse> getBaju() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(baseURL + 'ukuran-baju'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['Baju'] as List)
            .map((p) => Baju.fromJson(p))
            .toList();
        break;
      case 401:
        // Handle unauthorized case
        break;
      default:
        // Handle other error cases
        print("Server Response: ${response.body}");
        break;
    }
  } catch (e) {
    // Handle server error
    print("Error in getRuangan: $e");
  }
  return apiResponse;
}

Future<ApiResponse> updateBookingBaju(int id, int roomId, String reason,
    DateTime startDate, DateTime endDate) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse(baseURL + 'izinkeluar/$id'), // Use PUT method here
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'reason': reason,
        'start_date': startDate.toIso8601String(), // Convert DateTime to string
        'end_date': endDate.toIso8601String(), // Convert DateTime to string
      },
    );

    // Handle response based on status code
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = 'Unauthorized';
        break;
      default:
        apiResponse.error = 'Something went wrong';
        break;
    }
  } catch (e) {
    apiResponse.error = 'Server error: $e';
  }
  return apiResponse;
}

Future<ApiResponse> DeleteBookingBaju(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .delete(Uri.parse(baseURL + 'booking-ruangan/$id'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthrorized;
        break;
    }
  } catch (e) {}
  return apiResponse;
}
