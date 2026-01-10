class User {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final bool isBusiness;
  final DateTime createdAt;
  String? businessName;
  String? businessType;
  String? businessAddress;
  double? latitude;
  double? longitude;
  String? area;
  String? city;
  String? state;
  String? pincode;
  String? landmark;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.isBusiness,
    required this.createdAt,
    this.businessName,
    this.businessType,
    this.businessAddress,
    this.latitude,
    this.longitude,
    this.area,
    this.city,
    this.state,
    this.pincode,
    this.landmark,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'is_business': isBusiness ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'business_name': businessName,
      'business_type': businessType,
      'business_address': businessAddress,
      'latitude': latitude,
      'longitude': longitude,
      'area': area,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      isBusiness: map['is_business'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      businessName: map['business_name'],
      businessType: map['business_type'],
      businessAddress: map['business_address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      area: map['area'],
      city: map['city'],
      state: map['state'],
      pincode: map['pincode'],
      landmark: map['landmark'],
    );
  }
}
