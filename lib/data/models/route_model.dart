// lib/data/models/route_model.dart
class RouteModel {
  final String id;
  final String name;
  final String location;
  final String coverImage;
  final double price;
  final double distance;
  final double duration;
  final double averageRating;
  final String countryCode; // Derived
  final String origin; // From author.location

  RouteModel({
    required this.id,
    required this.name,
    required this.location,
    required this.coverImage,
    required this.price,
    required this.distance,
    required this.duration,
    required this.averageRating,
    required this.countryCode,
    required this.origin,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    // Get origin from author if available
    String origin = 'Katargam'; // Default value
    if (json['author'] != null && json['author'] is Map && json['author']['location'] != null) {
    origin = json['author']['location'];
  }
    
    // Get travel method
     String travelMethod = '';
  if (json['travelmethod'] != null && json['travelmethod'] is Map && json['travelmethod']['name'] != null) {
    travelMethod = json['travelmethod']['name'];
  }
    
    // Determine country code based on travel method
    String countryCode = 'US'; // Default
    if (travelMethod == 'Fahrrad') {
      countryCode = 'DE';
    } else if (travelMethod == 'Bus/Bahn') {
      countryCode = 'GB';
    }

    return RouteModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      coverImage: json['cover_image'] ?? 'https://picsum.photos/200/300',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      distance: (json['distance'] is num) ? (json['distance'] as num).toDouble() : 0.0,
      duration: (json['duration'] is num) ? (json['duration'] as num).toDouble() / 60 : 0.0, // Convert to hours
      averageRating: (json['average_rating'] is num) ? (json['average_rating'] as num).toDouble() : 0.0,
      countryCode: countryCode,
      origin: origin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'cover_image': coverImage,
      'price': price,
      'distance': distance,
      'duration': duration,
      'average_rating': averageRating,
      'country_code': countryCode,
      'origin': origin,
    };
  }
}