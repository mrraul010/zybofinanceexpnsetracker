class CreateAccountResponse {
  final String status;
  final String? token;

  CreateAccountResponse({required this.status, this.token});

  factory CreateAccountResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CreateAccountResponse(status: 'error');
    }

    return CreateAccountResponse(
      status: json['status']?.toString() ?? 'error',

      token: json['token']?.toString(),
    );
  }
}
