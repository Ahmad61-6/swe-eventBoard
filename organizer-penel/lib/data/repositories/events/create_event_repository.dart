// lib/features/events/repositories/event_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';

import '../../../features/events/models/create_event_model.dart';

class EventRepository extends GetxController {
  static EventRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Sanitizes the event type string to be safe for use as a Firestore document ID.
  String _sanitizeEventType(String eventType) {
    return eventType
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
        .replaceAll(RegExp(r'_{2,}'), '_');
  }

  /// Creates a new event document in 'Events/{eventType}/events/{eventId}'
  /// AND a reference entry in 'AllEvents/{eventId}' for efficient querying by organizerId.
  Future<String> createEvent(TCreateEventModel event) async {
    try {
      debugPrint("Repository: Attempting to create event '${event.title}'...");

      final String safeEventType = _sanitizeEventType(event.eventType);
      final eventTypeRef = _db.collection('Events').doc(safeEventType);

      // 1. Add the main event document to the categorized subcollection.
      final docRef = await eventTypeRef.collection('events').add(event.toMap());
      final String eventId = docRef.id;
      debugPrint("Repository: Main event document created with ID: $eventId");

      // 2. Update the main document with its own ID.
      await docRef.update({'id': eventId});
      debugPrint("Repository: Main event document ID updated.");

      // 3. Create a denormalized entry in 'AllEvents' for querying by organizerId.
      final allEventsRef = _db.collection('AllEvents').doc(eventId);
      final allEventsData = {
        'id': eventId,
        'title': event.title,
        'organizerId': event.organizerId,
        'eventType': event.eventType,
        'date': event.date, // Firestore converts DateTime to Timestamp
        'status': event.status,
        // Add other fields you might want to filter/sort by in lists
      };
      await allEventsRef.set(allEventsData);
      debugPrint(
          "Repository: Denormalized entry created in 'AllEvents' collection.");

      return eventId;
    } on FirebaseException catch (e) {
      debugPrint(
          "Repository: FirebaseException during creation: ${e.code} - ${e.message}");
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      debugPrint("Repository: FormatException during creation: $e");
      throw const TFormatException();
    } on PlatformException catch (e) {
      debugPrint(
          "Repository: PlatformException during creation: ${e.code} - ${e.message}");
      throw TPlatformException(e.code).message;
    } catch (e) {
      debugPrint("Repository: Unexpected error during event creation: $e");
      throw 'An unexpected error occurred while creating the event. Please try again.';
    }
  }

  /// Fetches all events created by a specific organizer.
  /// Queries the 'AllEvents' collection for efficiency.
  Future<List<TCreateEventModel>> fetchEventsByOrganizer(
      String organizerId) async {
    try {
      debugPrint("Repository: Fetching events for organizer ID: $organizerId");
      if (organizerId.isEmpty) {
        debugPrint("Repository: Organizer ID is empty, returning empty list.");
        return [];
      }

      final snapshot = await _db
          .collection('AllEvents')
          .where('organizerId', isEqualTo: organizerId)
          .orderBy('date',
              descending: false) // Example: order by date ascending
          .get();

      final List<TCreateEventModel> events = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final String eventId = data['id'];
        final String eventType = data['eventType'];

        // Fetch full event details from the main path
        final String safeEventType = _sanitizeEventType(eventType);
        final mainDocSnapshot = await _db
            .collection('Events')
            .doc(safeEventType)
            .collection('events')
            .doc(eventId)
            .get();

        if (mainDocSnapshot.exists) {
          events.add(TCreateEventModel.fromMap(
              mainDocSnapshot.data()!, mainDocSnapshot.id));
        } else {
          debugPrint(
              "Repository Warning: Event ID $eventId found in AllEvents but main document missing.");
          // Handle potential inconsistency
        }
      }

      debugPrint(
          "Repository: Fetched ${events.length} events for organizer $organizerId");
      return events;
    } on FirebaseException catch (e) {
      debugPrint(
          "Repository: FirebaseException during fetch by organizer: ${e.code} - ${e.message}");
      throw TFirebaseException(e.code).message;
    } catch (e) {
      debugPrint("Repository: Unexpected error during fetch by organizer: $e");
      throw 'An unexpected error occurred while fetching your events. Please try again.';
    }
  }

// --- Placeholder for student app feature ---
/*
  Future<List<TCreateEventModel>> fetchEventsByType(String eventType) async {
    try {
      final String safeEventType = _sanitizeEventType(eventType);
      final snapshot = await _db.collection('Events').doc(safeEventType).collection('events').get();
      return snapshot.docs.map((doc) => TCreateEventModel.fromMap(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } // ... other catches
  }
  */
// --- End placeholder ---
}
