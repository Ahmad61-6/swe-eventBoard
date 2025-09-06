// lib/features/events/screens/create_event/controllers/create_event_controller.dart
import 'dart:html' as html; // For web file picker

import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:uuid/uuid.dart'; // Add this dependency: flutter pub add uuid
// --- Import your project's specific files ---
import 'package:yt_ecommerce_admin_panel/data/repositories/authentication/authentication_repository.dart';
// Adjust import path
import 'package:yt_ecommerce_admin_panel/utils/helpers/cloud_helper_functions.dart'; // Adjust import path - Ensure it supports html.File
import 'package:yt_ecommerce_admin_panel/utils/helpers/network_manager.dart'; // Adjust import path
import 'package:yt_ecommerce_admin_panel/utils/popups/full_screen_loader.dart'; // Adjust import path
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart'; // Adjust import path
import 'package:yt_ecommerce_admin_panel/utils/validators/validation.dart';

// Make sure these imports point to the correct files
import '../../../data/repositories/events/create_event_repository.dart';
import '../models/create_event_model.dart';
// Adjusted import path

class CreateEventController extends GetxController {
  static CreateEventController get instance => Get.find();

  // Assuming EventRepository is correctly set up and injected elsewhere (e.g., bindings)
  // Use Get.find if injected, or Get.put(EventRepository()) if managing here.
  final eventRepository =
      Get.find<EventRepository>(); // Ensure EventRepository is injected

  // --- TextEditingControllers for form fields ---
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueController = TextEditingController();
  final googleMeetLinkController = TextEditingController();
  final dateController = TextEditingController();
  final maxParticipantsController = TextEditingController();
  final imageUrlController =
      TextEditingController(); // For manual URL input (if kept)
  final priceController = TextEditingController();

  // --- Reactive Variables (Rx Types) ---
  final eventType = ''.obs; // This is now THE category
  final isFree = true.obs; // Reactive Boolean for Free/Paid toggle

  // --- Reactive variables to track image state for UI ---
  final RxString imageFileName = ''.obs;
  final RxBool imageUploaded = false.obs;

  // --- Internal State ---
  html.File? _pickedImageFile;
  String? _uploadedImageUrl;

  // --- Other State ---
  final formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime = const TimeOfDay(hour: 12, minute: 0);

  // --- Example Event Types (now also categories) ---
  final List<String> availableEventTypes = [
    'Seminar',
    'Webinar',
    'Hackathon',
    'Contest',
    'Club Event',
    'Job Circular'
  ];

  // --- Getters ---
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  html.File? get pickedImageFile => _pickedImageFile;
  String? get uploadedImageUrl => _uploadedImageUrl;

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    venueController.dispose();
    googleMeetLinkController.dispose();
    dateController.dispose();
    maxParticipantsController.dispose();
    imageUrlController.dispose();
    priceController.dispose();
    super.onClose();
  }

  // --- Validation Helpers ---
  String? validateTitle(String? value) =>
      TValidator.validateEmptyText('Title', value);
  String? validateDescription(String? value) =>
      TValidator.validateEmptyText('Description', value);
  // Validate that an eventType is selected
  String? validateEventType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Event Type is required.';
    }
    return null;
  }

  String? validateDate(String? value) =>
      value == null || value.isEmpty ? 'Date is required.' : null;
  String? validateMaxParticipants(String? value) {
    if (value == null || value.isEmpty) return 'Max Participants is required.';
    final n = int.tryParse(value);
    if (n == null || n <= 0)
      return 'Please enter a valid number greater than 0.';
    return null;
  }

  // --- Conditional Validation (Called during submission) ---
  String? validateVenueOrLink() {
    final currentEventType = eventType.value.trim().toLowerCase();
    if (currentEventType == 'webinar') {
      final link = googleMeetLinkController.text.trim();
      if (link.isEmpty) return 'Google Meet Link is required for Webinars.';
      if (!GetUtils.isURL(link)) return 'Please enter a valid Google Meet URL.';
    } else if (currentEventType.isNotEmpty) {
      final venue = venueController.text.trim();
      if (venue.isEmpty) return 'Venue is required for this event type.';
    }
    return null;
  }

  String? validatePrice() {
    if (isFree.value) return null;
    final priceText = priceController.text.trim();
    if (priceText.isEmpty) return 'Price is required for paid events.';
    final n = double.tryParse(priceText);
    if (n == null || n <= 0)
      return 'Please enter a valid price greater than 0.';
    return null;
  }

  // --- Date & Time Picker ---
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      updateDateControllerText();
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null && picked != _selectedTime) {
      _selectedTime = picked;
      updateDateControllerText();
    }
  }

  void updateDateControllerText() {
    if (_selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      String formattedTime = _selectedTime?.format(Get.context!) ?? '12:00 PM';
      dateController.text = '$formattedDate $formattedTime';
    }
  }

  // --- Toggle Free/Paid ---
  void toggleIsFree() {
    isFree.value = !isFree.value;
    if (isFree.value) {
      priceController.clear();
    }
  }

  // --- Image Handling ---
  /// Picks an image file using the web browser's file dialog.
  Future<void> pickImage() async {
    try {
      debugPrint("Attempting to pick image...");
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement()
            ..accept = 'image/*'; // Accept only image files

      uploadInput.click(); // Trigger the file selection dialog

      // Listen for the file selection event
      uploadInput.onChange.listen((event) async {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          _pickedImageFile = files[0]; // Get the first selected file
          // Update reactive variables for UI
          imageFileName.value = _pickedImageFile!.name; // Update filename
          imageUploaded.value = false; // Reset upload status
          _uploadedImageUrl = null; // Clear previous URL
          debugPrint('Image picked successfully: ${_pickedImageFile?.name}');
        } else {
          debugPrint('No file selected or file list is empty.');
        }
      });
    } catch (e) {
      debugPrint('Error picking image: $e');
      TLoaders.errorSnackBar(title: 'Image Pick Error', message: e.toString());
    }
  }

  /// Uploads the currently picked image file to Firebase Storage.
  /// Returns the download URL on success, null otherwise.
  Future<String?> uploadPickedImage() async {
    if (_pickedImageFile == null) {
      debugPrint('No image picked to upload.');
      return null;
    }

    if (_uploadedImageUrl != null) {
      debugPrint('Image already uploaded. Returning existing URL.');
      return _uploadedImageUrl;
    }

    try {
      TFullScreenLoader.openLoadingDialog('Uploading Image...',
          'assets/images/animations/cloud-uploading-animation.json'); // Adjust animation path

      final String fileName =
          'event_images/${const Uuid().v4()}_${_pickedImageFile!.name}';
      debugPrint('Generated filename for upload: $fileName');

      // --- CRITICAL: Ensure TCloudHelperFunctions.uploadImageFile supports html.File ---
      final String downloadUrl = await TCloudHelperFunctions.uploadImageFile(
        file: _pickedImageFile!,
        path: 'Events', // Storage folder path
        imageName: fileName,
      );

      _uploadedImageUrl = downloadUrl;
      imageUploaded.value = true; // Indicate upload success for UI
      debugPrint('Image uploaded successfully. Download URL: $downloadUrl');
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
          title: 'Success', message: 'Image uploaded successfully.');
      return downloadUrl;
    } catch (e) {
      imageUploaded.value = false; // Ensure status reflects failure
      TFullScreenLoader.stopLoading();
      debugPrint('Error during image upload: $e');
      TLoaders.errorSnackBar(
          title: 'Upload Failed', message: 'Error: ${e.toString()}');
      return null;
    }
  }

  // --- Form Submission ---
  Future<void> createEvent() async {
    try {
      TFullScreenLoader.openLoadingDialog('Creating Event...',
          'assets/images/animations/141594-animation-of-docer.json'); // Adjust animation path

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'No Internet Connection',
            message: 'Please check your connection and try again.');
        return;
      }

      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // --- IMAGE UPLOAD STEP ---
      String? finalImageUrl = _uploadedImageUrl;
      if (_pickedImageFile != null && _uploadedImageUrl == null) {
        finalImageUrl = await uploadPickedImage();
        if (finalImageUrl == null) {
          TFullScreenLoader.stopLoading();
          debugPrint("Image upload failed, aborting event creation.");
          return; // Important: Stop if upload fails
        }
        debugPrint("Image upload successful, proceeding with event creation.");
      } else if (_pickedImageFile == null) {
        debugPrint("No new image picked, using existing URL or none.");
      }
      // --- END IMAGE UPLOAD ---

      // --- Validate EventType (ensure one is selected) ---
      if (eventType.value.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Validation Error', message: 'Please select an event type.');
        return;
      }

      // Validate conditional fields
      final venueOrLinkError = validateVenueOrLink();
      if (venueOrLinkError != null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Validation Error', message: venueOrLinkError);
        return;
      }

      final priceError = validatePrice();
      if (priceError != null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Validation Error', message: priceError);
        return;
      }

      if (_selectedDate == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Missing Date',
            message: 'Please select a date for the event.');
        return;
      }

      DateTime eventDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime?.hour ?? 12,
        _selectedTime?.minute ?? 0,
      );

      // --- Get organizerId from Auth ---
      final String organizerId =
          AuthenticationRepository.instance.authUser?.uid ?? '';
      if (organizerId.isEmpty) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'Authentication Error',
            message: 'Organizer information not found. Please log in again.');
        return;
      }

      // Create the event model using current reactive values
      // eventType.value IS the category now
      final event = TCreateEventModel(
        id: '', // Firestore will generate this
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        venue: eventType.value.toLowerCase() != 'webinar'
            ? venueController.text.trim()
            : null,
        googleMeetLink: eventType.value.toLowerCase() == 'webinar'
            ? googleMeetLinkController.text.trim()
            : null,
        date: eventDateTime,
        organizerId: organizerId, // Associate with the creating organizer
        status: 'pending', // Default status
        maxParticipants: int.parse(maxParticipantsController.text.trim()),
        eventType:
            eventType.value, // Pass the selected eventType (used as category)
        imageUrl: finalImageUrl, // Use the URL from upload
        isFree: isFree.value, // Use the reactive value
        price:
            isFree.value ? null : double.tryParse(priceController.text.trim()),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      // Call repository (it handles the eventType path and organizer isolation)
      final eventId = await eventRepository.createEvent(event);

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
          title: 'Success',
          message: 'Event created successfully with ID: $eventId');

      resetForm(); // Reset the form and clear image state
    } catch (e) {
      TFullScreenLoader.stopLoading();
      debugPrint('Error creating event: $e');
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // --- Reset Form ---
  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    eventType.value = ''; // Reset the eventType selection (was category)
    venueController.clear();
    googleMeetLinkController.clear();
    dateController.clear();
    maxParticipantsController.clear();
    imageUrlController.clear(); // Clear manual URL input if used
    priceController.clear();
    _selectedDate = null;
    _selectedTime = const TimeOfDay(hour: 12, minute: 0);
    isFree.value = true; // Reset to free

    // Reset reactive variables for image state
    imageFileName.value = '';
    imageUploaded.value = false;
    _pickedImageFile = null; // Clear the picked file reference
    _uploadedImageUrl = null; // Clear the uploaded URL reference

    formKey.currentState?.reset(); // Reset form validation state if needed
    debugPrint("Form has been reset.");
  }
}
