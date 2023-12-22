import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/booking_ruangan.dart';
import 'package:it_del/Models/ruangan.dart';
import 'package:it_del/Services/globals.dart';
import 'package:it_del/Services/User_service.dart';

Future<ApiResponse> createRequestRuangan(
    int roomId, String reason, DateTime startDate, DateTime endDate) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse(baseURL + 'booking-ruangan'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'room_id': roomId.toString(),
      'reason': reason,
      'start_time':
          DateFormat("yyyy-MM-dd HH:mm:ss").format(startDate.toLocal()),
      'end_time': DateFormat("yyyy-MM-dd HH:mm:ss").format(endDate.toLocal()),
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        if (errors.containsKey('room_id') &&
            errors['room_id'][0] == 'Room already booked') {
          apiResponse.error = 'Room is already booked for the selected time.';
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
    print('Error in createRequestRuangan: $e');
    apiResponse.error = 'Server error: $e';
  }
  return apiResponse;
}

Future<ApiResponse> getRequestRuangan() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(baseURL + 'booking-ruangan'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['bookingData'] as List)
            .map((p) => BookingRuangan.fromJson(p))
            .toList();
        print("JSON Response: ${jsonDecode(response.body)}");

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
    apiResponse.error = 'server error';
    print("Error in getIzinKeluar: $e");
  }
  return apiResponse;
}

Future<ApiResponse> getRuangan() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(baseURL + 'ruangan'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['Ruangan'] as List)
            .map((p) => Ruangan.fromJson(p))
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

Future<ApiResponse> updateRequestRuangan(int id, int roomId, String reason,
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

Future<ApiResponse> DeleteBookingRuangan(int id) async {
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

Future<ApiResponse> checkRoomAvailabilityApi(
    int roomId, DateTime startDate, DateTime endDate) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(baseURL + 'cek-ruangan'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'room_id': roomId.toString(),
        'start_time': startDate.toIso8601String(),
        'end_time': endDate.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body
      dynamic responseBody = json.decode(response.body);

      if (responseBody.containsKey('message')) {
        // Room is available
        apiResponse.data = true;
      } else if (responseBody.containsKey('error')) {
        // Room is not available
        apiResponse.data = false;
        apiResponse.error = responseBody['error'];
      } else {
        // Handle unexpected response format
        apiResponse.error = 'Invalid response format';
      }
    } else {
      // Handle other HTTP status codes
    }
  } catch (e) {
    // Handle general error
    apiResponse.error = 'Error: $e';
  }

  return apiResponse;
}

Future<ApiResponse> getAdminRequestRuangan() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(baseURL + 'admin/bookingruangan'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = (jsonDecode(response.body)['bookingData'] as List)
            .map((p) => BookingRuangan.fromJson(p))
            .toList();
        print("JSON Response: ${jsonDecode(response.body)}");
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
    apiResponse.error = 'server error';
    print("Error in getIzinKeluar: $e");
  }
  return apiResponse;
}
