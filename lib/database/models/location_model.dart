class BusinessLocation {
  final int? id;
  final double latitude;
  final double longitude;
  final String address;
  final String? area;
  final String? city;
  final String? state;
  final String? pincode;
  final String? landmark;

  BusinessLocation({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.area,
    this.city,
    this.state,
    this.pincode,
    this.landmark,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'area': area,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
    };
  }

  factory BusinessLocation.fromMap(Map<String, dynamic> map) {
    return BusinessLocation(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      area: map['area'],
      city: map['city'],
      state: map['state'],
      pincode: map['pincode'],
      landmark: map['landmark'],
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (address.isNotEmpty) parts.add(address);
    if (area != null && area!.isNotEmpty) parts.add(area!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (pincode != null && pincode!.isNotEmpty) parts.add(pincode!);
    return parts.join(', ');
  }
}
