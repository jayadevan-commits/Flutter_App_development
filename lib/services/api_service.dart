import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constant.dart';

class ApiService {

  // 🔐 HR LOGIN 
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('${AppConstants.baseUrl}/api/auth/hrLogin');

    try{
    final response = await http.post(
      url,
      headers:{
        'Accept':'application/json',
       // 'Content-Type': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email.trim(),
        'password': password.trim(),
      },
    ).timeout(const Duration(seconds: 20));


    // 🔍 Debug logs
    print('Login Status: ${response.statusCode}');
    print('Login Body: ${response.body}');

    if (response.statusCode == 200 )  {
      final data = jsonDecode(response.body);

    //acess_token
      if (data['access_token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['access_token']);

        print('✅ Token saved successfully');
        return true;
      } else {
        print('❌ Token missing in response');
      }
      } else{
        print('Login again Failed :${response.statusCode}');
      }
      } catch (e) {
        print('❌ Login Error: $e');
      }
    
    return false;
  }

  // 👤 CREATE EMPLOYEE
  static Future<bool> createEmployee(
      Map<String, dynamic> employeeData) async {
   try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    
  if (token == null) {
    print('❌ Token is null. Login required.');
    return false;
  }
  // 🔍 DEBUG: Check what we send
  print('🔑 Token Used: $token');
  print('📤 Employee Data Sent: $employeeData');
  
    final url =
        Uri.parse('${AppConstants.baseUrl}/api/auth/createEmployee');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(employeeData),
    )
    .timeout(const Duration(seconds: 20));

    print('Create Employee Status: ${response.statusCode}');
    print('Create Employee Body: ${response.body}');

    if( response.statusCode == 200 ||response.statusCode ==201){
      return true;
    }
    else{
      return false;
    }
  } catch (e) {
    print('❌ Create Employee Error: $e');
    return false;
  }
      }

  // 📋 GET MANAGER EMPLOYEES
  static Future<List<dynamic>> getManagerEmployees() async {
    try{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token missing. Please login again.');
    }

    final url =
        Uri.parse('${AppConstants.baseUrl}/api/auth/getmangerEmployees');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Employee List Status: ${response.statusCode}');
    print('Employee List Body: ${response.body}');

    if (response.statusCode ==200){

    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  } else{
    return [];
  }
} catch (e) {
  print('❌ Get Employees Error: $e');
  return [];
}
  }
/*
// Forget Password, Email send OTP
static Future<bool> EmailSendOTP(String email) async {
 // final url = Uri.parse('${AppConstants.baseUrl}/api/auth/EmailSendOTP');

 //final url = Uri.parse('http://127.0.0.1:8000/api/auth/EmailSendOTP');
 //final url = Uri.parse('http://192.168.0.14:8000/api/auth/EmailSendOTP');
  final url = Uri.parse('http://10.0.2.2:8000/api/auth/EmailSendOTP');

  try{
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'em_email': email.trim(),
      },
    ).timeout(const Duration(seconds: 20));

    print('Send OTP Status: ${response.statusCode}');
    print('Send OTP Body: ${response.body}');

    // if (response.statusCode ==200) {
    //   return true; // Email otp sent successfully
    // } else{
    //   return false; // Email otp not registered
    // }
    return response.statusCode == 200;
  } catch(e) {
    print ('❌ Forgot Password Error: $e');
    return false;
  }
}  */

static Future<bool> EmailSendOTP(String email) async {
  final url = Uri.parse('${AppConstants.baseUrl}/api/auth/EmailSendOTP');

  print('📤 STEP 1: Function called');
  print('📤 Email sent: $email');
  print('📤 URL: $url');

  try {
    print('📤 STEP 2: Sending POST request...');

    final response = await http
        .post(
          url,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'em_email': email.trim(),
          },
        )
        .timeout(const Duration(seconds: 10), onTimeout: () {
          print('⏰ ERROR: Request timeout (20 seconds)');
          throw Exception('Request Timeout');
        });

    print('📥 STEP 3: Response received');
    print('📥 Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ STEP 4: OTP sent successfully');
      return true;
    } else if (response.statusCode == 404) {
      print('❌ STEP 4: API route not found (404)');
      return false;
    } else if (response.statusCode == 422) {
      print('⚠️ STEP 4: Validation error (422)');
      return false;
    } else if (response.statusCode == 500) {
      print('🔥 STEP 4: Server error (500)');
      return false;
    } else {
      print('❓ STEP 4: Unexpected status code');
      return false;
    }
  } catch (e) {
    print('💥 STEP 5: Exception caught');
    print('💥 Error type: ${e.runtimeType}');
    print('💥 Error message: $e');
    return false;
  }
}


//  static Future<bool> EmailSendOTP(String email) async {
//     final url = Uri.parse('http://127.0.0.1:8000/api/auth/EmailSendOTP');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: {
//           'em_email': email.trim(),
//         },
//       ).timeout(const Duration(seconds: 20));

//       print('Send OTP Status: ${response.statusCode}');
//       print('Send OTP Body: ${response.body}');

//       return response.statusCode == 200;
//     } catch (e) {
//       print('❌ Forgot Password Error: $e');
//       return false;
//     }
//   }


// Reset Password
static Future<bool> resetPassword(
  String email, 
  String otp,
  String password, 
  String confirmPassword,
  ) async {
   final url = Uri.parse('${AppConstants.baseUrl}/api/auth/resetPassword');

     //final url = Uri.parse('http://10.0.2.2:8000/api/auth/EmailSendOTP');
  try{
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'em_email': email.trim(),
        'otp': otp.trim(),
        'password': password.trim(),
        'password_confirmation': confirmPassword.trim(),
      },
    ).timeout(const Duration(seconds: 10));

    print('Reset Password Status: ${response.statusCode}');
    print('Reset Password Body: ${response.body}');

    // if(response.statusCode == 200) {
    //   return true; // password updated successfully
    // } else {
    //   return false; // Invalid token or failure
    // }
    return response.statusCode == 200;
  } catch (e) {
       print('❌ Reset Password Error: $e');
       return false;
  }  
}
// ✅ Verify OTP
static Future<bool> EmailVerifyOTP(String email, String otp) async {
  final url = Uri.parse('${AppConstants.baseUrl}/api/auth/EmailVerifyOTP');

  //final url = Uri.parse('http://10.0.2.2:8000/api/auth/EmailVerifyOTP');

  try {
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'em_email': email.trim(),
        'otp': otp.trim(),
      },
    ).timeout(const Duration(seconds: 10));

    print('Verify OTP Status: ${response.statusCode}');
    print('Verify OTP Body: ${response.body}');

    return response.statusCode == 200;
  } catch (e) {
    print('❌ Verify OTP Error: $e');
    return false;
  }
}
}