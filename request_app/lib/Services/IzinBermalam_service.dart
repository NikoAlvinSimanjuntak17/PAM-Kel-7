import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:it_del/Models/api_response.dart';
import 'package:it_del/Models/request_izin_bermalam.dart';
import 'package:it_del/Services/globals.dart';
import 'package:it_del/Services/User_service.dart';

Future<ApiResponse> CreateIzinBermalam(
    String reason, DateTime start_date, DateTime end_date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Check if the start_date is within the allowed timeframe (2 days in advance)
    DateTime allowedStartDate = DateTime.now().add(Duration(days: 2));
    if (start_date.isBefore(allowedStartDate)) {
      apiResponse.error =
          'Izin Bermalam can only be requested 2 days in advance.';
      return apiResponse;
    }

    String token = await getToken();
    final response =
        await http.post(Uri.parse(baseURL + 'izinbermalam'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'reason': reason,
      'start_date': start_date.toIso8601String(),
      'end_date': end_date.toIso8601String(),
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
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
    apiResponse.error = 'server error';
  }
  return apiResponse;
}

Future<ApiResponse> getIzinBermalam() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(baseURL + 'izinbermalam'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            (jsonDecode(response.body)['RequestIzinBermalam'] as List)
                .map((p) => RequestIzinBermalam.fromJson(p))
                .toList();
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
    print("Error in getIzinBermalam: $e");
  }
  return apiResponse;
}

Future<ApiResponse> updateIzinBermalam(
    int id, String reason, DateTime start_date, DateTime end_date) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse(baseURL + 'izinbermalam/$id'), // Use PUT method here
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'reason': reason,
        'start_date':
            start_date.toIso8601String(), // Convert DateTime to string
        'end_date': end_date.toIso8601String(), // Convert DateTime to string
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

Future<ApiResponse> DeleteIzinBermalam(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse(baseURL + 'izinbermalam/$id'),
        headers: {
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
