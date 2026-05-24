import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyboexpensetracker/core/network/api_client.dart';
import 'package:zyboexpensetracker/features/auth/data/models/create_account_response_model.dart';
import 'package:zyboexpensetracker/features/auth/data/models/send_otpmodel.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<SendOtpResponse> sendOtp(String phone) async {
    try {
      final response = await _apiClient.post(
        '/auth/send-otp/',
        data: {'phone': phone},
        requiresAuth: false,
        isFormData: true,
      );

      return SendOtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send OTP');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<String> createAccount(String phone, String nickname) async {
    try {
      final response = await _apiClient.post(
        '/auth/create-account/',
        data: {'phone': phone, 'nickname': nickname},
        requiresAuth: false,
        isFormData: true,
      );

      final parsedResponse = CreateAccountResponse.fromJson(response.data);

      if (parsedResponse.status == 'success' && parsedResponse.token != null) {
        final token = parsedResponse.token!;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_nickname', nickname);

        return token;
      } else {
        throw Exception('Failed to create account. Invalid server response.');
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create account',
      );
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while creating your account.',
      );
    }
  }

  Future<void> saveSession(String token, String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_nickname', nickname);
  }
}
