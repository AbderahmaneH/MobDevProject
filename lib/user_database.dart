class User {
  final String phone;
  final String password;
  final bool isBusiness;
  final String? businessName;
  final String? businessLocation;
  final String? email;

  User({
    required this.phone,
    required this.password,
    required this.isBusiness,
    this.businessName,
    this.businessLocation,
    this.email,
  });
}

List<User> userDatabase = [];
