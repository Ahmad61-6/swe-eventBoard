// lib/features/events/models/event_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TCreateEventModel {
  final String id;
  final String title;
  final String description;
  final String? venue;
  final String? googleMeetLink;
  final DateTime date;
  final String organizerId; // Crucial for isolation
  final String status;
  final int maxParticipants;
  final String eventType; // This serves as the category
  final String? imageUrl;
  final bool isFree;
  final double? price;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  TCreateEventModel({
    required this.id,
    required this.title,
    required this.description,
    this.venue,
    this.googleMeetLink,
    required this.date,
    required this.organizerId, // Ensure this is passed during creation
    required this.status,
    required this.maxParticipants,
    required this.eventType, // Required eventType (used as category)
    this.imageUrl,
    required this.isFree,
    this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TCreateEventModel.fromMap(
      Map<String, dynamic> data, String documentId) {
    final timestampNow = Timestamp.now();
    return TCreateEventModel(
      id: documentId,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      venue: data['venue'] as String?,
      googleMeetLink: data['googleMeetLink'] as String?,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      organizerId: data['organizerId'] as String? ?? '', // Load organizerId
      status: data['status'] as String? ?? 'pending',
      maxParticipants: (data['maxParticipants'] is int)
          ? data['maxParticipants'] as int
          : (data['maxParticipants'] is num)
              ? (data['maxParticipants'] as num).toInt()
              : 0,
      eventType: data['eventType'] as String? ?? '', // Load eventType
      imageUrl: data['imageUrl'] as String?,
      isFree: data['isFree'] is bool ? data['isFree'] as bool : true,
      price: data['price'] is num ? (data['price'] as num).toDouble() : null,
      createdAt: data['createdAt'] as Timestamp? ?? timestampNow,
      updatedAt: data['updatedAt'] as Timestamp? ?? timestampNow,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'venue': venue,
      'googleMeetLink': googleMeetLink,
      'date': Timestamp.fromDate(date),
      'organizerId': organizerId, // Save organizerId
      'status': status,
      'maxParticipants': maxParticipants,
      'eventType': eventType, // Save eventType
      'imageUrl': imageUrl,
      'isFree': isFree,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TCreateEventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? venue,
    String? googleMeetLink,
    DateTime? date,
    String? organizerId,
    String? status,
    int? maxParticipants,
    String? eventType, // Include eventType
    String? imageUrl,
    bool? isFree,
    double? price,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return TCreateEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      venue: venue ?? this.venue,
      googleMeetLink: googleMeetLink ?? this.googleMeetLink,
      date: date ?? this.date,
      organizerId: organizerId ?? this.organizerId,
      status: status ?? this.status,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      eventType: eventType ?? this.eventType, // Include eventType
      imageUrl: imageUrl ?? this.imageUrl,
      isFree: isFree ?? this.isFree,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
