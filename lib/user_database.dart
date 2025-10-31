class User {
  final String name;
  final String phone;
  final String password;
  final bool isBusiness;
  final String? businessName;
  final String? businessLocation;
  final String? email;

  User({
    required this.name,
    required this.phone,
    required this.password,
    required this.isBusiness,
    this.businessName,
    this.businessLocation,
    this.email,
  });
}

// Add these to your user_database.dart file
List<User> userDatabase = [
  User(
    name: "Tech Solutions LLC",
    phone: "0512345678",
    password: "111111",
    isBusiness: true,
    businessName: "Tech Solutions LLC",
    businessLocation: "Downtown Business District",
    email: "contact@techsolutions.com",
  ),
  User(
    name: "City Medical Center",
    phone: "0598765432",
    password: "111111",
    isBusiness: true,
    businessName: "City Medical Center",
    businessLocation: "Medical Plaza, Main Street",
    email: "info@citymedical.com",
  ),
  User(
    name: "Premium Restaurant",
    phone: "0500000000",
    password: "111111",
    isBusiness: true,
    businessName: "Premium Restaurant",
    businessLocation: "Gourmet Avenue",
    email: "reservations@premiumrestaurant.com",
  ),
];
