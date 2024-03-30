class LoginSuccessDto {
  final String status;
  final String message;
  final String role;

  LoginSuccessDto(
      {required this.status, required this.message, required this.role});
  factory LoginSuccessDto.fromJson(Map<String, dynamic> json) {
    return LoginSuccessDto(
      status: json['status'],
      message: json['message'],
      role: json['data'][0]['role'],
    );
  }
}
