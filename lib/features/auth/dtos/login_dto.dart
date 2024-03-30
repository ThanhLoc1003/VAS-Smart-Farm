class LoginDto {
  final String email;
  final String password;

  LoginDto({required this.email, required this.password});
  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      email: json['email'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
