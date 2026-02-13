class UserModel {
  final String name;
  final String email;
  final String role;
  final String signupDate;
  final String address;
  final String village;
  final String taluka;
  final String district;
  final String state;
  final String country;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.signupDate,
    required this.address,
    required this.village,
    required this.taluka,
    required this.district,
    required this.state,
    required this.country,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      signupDate: json["signupDate"] ?? "",
      address: json["address"] ?? "",
      village: json["village"] ?? "",
      taluka: json["taluka"] ?? "",
      district: json["district"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
    );
  }

  UserModel? copyWith({required String name, required String address}) {}
}
