// lib/features/events/screens/create_event/widgets/create_event_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

import '../../controllers/create_event_controller.dart';
import 'event_image_uploader.dart'; // Ensure this path is correct

class TCreateEventForm extends StatelessWidget {
  const TCreateEventForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateEventController>();

    // Use the list from the controller
    final List<String> eventTypes = controller.availableEventTypes;

    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Improved Image Uploader Section Header ---
            const Text(
              'Event Banner',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TSizes.sm),
            const Text(
              'Upload an image for your event banner. This will be displayed prominently.',
              style: TextStyle(
                fontSize: TSizes.fontSizeSm,
                color: TColors.textSecondary,
              ),
            ),
            const SizedBox(height: TSizes.md),

            // --- Enhanced Image Uploader Card ---
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              showBorder: true,
              borderColor: TColors.grey,
              backgroundColor: TColors.lightContainer, // Subtle background
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Stretch children
                children: [
                  // --- Uploader Row ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Image Display Area ---
                      SizedBox(
                        width: 120, // Slightly larger
                        height: 120,
                        child: Obx(() {
                          // Determine what to display based on controller state
                          if (controller.imageUploaded.value) {
                            // Show uploaded image if available
                            return TEventImageUploader(
                              onPickImage: controller.pickImage,
                              pickedFile: controller.pickedImageFile,
                              uploadedImageUrl: controller.uploadedImageUrl,
                              width: 120,
                              height: 120,
                            );
                          } else if (controller.pickedImageFile != null) {
                            // Show picked file placeholder
                            return Container(
                              decoration: BoxDecoration(
                                color: TColors.white,
                                borderRadius:
                                    BorderRadius.circular(TSizes.cardRadiusMd),
                                border: Border.all(
                                    color: TColors.primary.withOpacity(0.5)),
                              ),
                              child: const Icon(Iconsax.document_upload,
                                  size: 40, color: TColors.primary),
                            );
                          } else {
                            // Show default placeholder
                            return Container(
                              decoration: BoxDecoration(
                                color: TColors.white,
                                borderRadius:
                                    BorderRadius.circular(TSizes.cardRadiusMd),
                                border: Border.all(color: TColors.grey),
                              ),
                              child: const Icon(Iconsax.gallery,
                                  size: 40, color: TColors.grey),
                            );
                          }
                        }),
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      // --- Info and Action Column ---
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Center content vertically
                          children: [
                            Obx(() {
                              if (controller.imageUploaded.value) {
                                return const Text(
                                  'Banner Uploaded!',
                                  style: TextStyle(
                                    color: TColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else if (controller
                                  .imageFileName.value.isNotEmpty) {
                                return Text(
                                  controller.imageFileName.value,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2, // Allow 2 lines for long names
                                );
                              } else {
                                return Text(
                                  'No banner selected.',
                                  style:
                                      TextStyle(color: TColors.textSecondary),
                                );
                              }
                            }),
                            const SizedBox(height: TSizes.sm / 2),
                            // --- Action Button ---
                            SizedBox(
                              width: double
                                  .infinity, // Make button take available width
                              child: OutlinedButton.icon(
                                onPressed: controller.pickImage,
                                icon: const Icon(Iconsax.gallery,
                                    size: TSizes.iconSm),
                                label: const Text("Choose Image"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: TSizes.sm / 2),
                                  side: BorderSide(color: TColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(height: TSizes.sm / 2),
                            const Text(
                              'JPG, PNG (Max 5MB)',
                              style: TextStyle(
                                fontSize: TSizes.fontSizeSm,
                                color: TColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // --- Main Form Card ---
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              backgroundColor: TColors.white,
              child: Column(
                children: [
                  // --- Essential Details ---
                  TextFormField(
                    controller: controller.titleController,
                    validator: controller.validateTitle,
                    decoration: const InputDecoration(
                      labelText: 'Event Title *',
                      hintText: 'Enter the event title',
                      prefixIcon: Icon(Iconsax.text),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  TextFormField(
                    controller: controller.descriptionController,
                    validator: controller.validateDescription,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      hintText: 'Describe the event in detail...',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Iconsax.document_text),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // --- Event Type (now also Category) ---
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.eventType.value.isEmpty
                            ? null
                            : controller.eventType.value,
                        validator: controller
                            .validateEventType, // Still validate selection
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.eventType.value =
                                newValue; // Update Rx variable
                          }
                        },
                        items: eventTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Event Type / Category *', // Updated label
                          hintText: 'Select event type/category',
                          prefixIcon:
                              Icon(Iconsax.category), // Appropriate icon
                        ),
                      )),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // --- Conditional Location Details ---
                  Obx(() {
                    final isWebinar =
                        controller.eventType.value.trim().toLowerCase() ==
                            'webinar';
                    return isWebinar
                        ? TextFormField(
                            controller: controller.googleMeetLinkController,
                            validator: (value) {
                              if (isWebinar &&
                                  (value == null || value.isEmpty)) {
                                return 'Google Meet Link is required for Webinars.';
                              }
                              if (isWebinar && !GetUtils.isURL(value!)) {
                                return 'Please enter a valid Google Meet URL.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Google Meet Link *',
                              hintText: 'https://meet.google.com/xxx-xxxx-xxx',
                              prefixIcon: Icon(Iconsax.video),
                            ),
                          )
                        : TextFormField(
                            controller: controller.venueController,
                            validator: (value) {
                              if (!isWebinar &&
                                  (value == null || value.isEmpty)) {
                                return 'Venue is required for this event type.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Venue *',
                              hintText: 'e.g., ICR, Ground Hall, Room 101',
                              prefixIcon: Icon(Iconsax.location),
                            ),
                          );
                  }),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // --- Scheduling ---
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.dateController,
                          validator: controller.validateDate,
                          readOnly: true,
                          onTap: () => controller.pickDate(context),
                          decoration: const InputDecoration(
                            labelText: 'Date & Time *',
                            hintText: 'Select date and time',
                            prefixIcon: Icon(Iconsax.calendar_1),
                            suffixIcon: Icon(Iconsax.arrow_down_1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // --- Capacity & Pricing ---
                  TextFormField(
                    controller: controller.maxParticipantsController,
                    validator: controller.validateMaxParticipants,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max Participants *',
                      hintText: 'Enter maximum number of participants',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Free/Paid Toggle and Price
                  Obx(() => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Is this event free?'),
                          const SizedBox(width: TSizes.sm),
                          Switch(
                            value: controller.isFree.value,
                            onChanged: (value) => controller.toggleIsFree(),
                          ),
                          const Spacer(),
                          if (!controller.isFree.value)
                            Expanded(
                              child: TextFormField(
                                controller: controller.priceController,
                                validator: (value) {
                                  if (!controller.isFree.value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Price is required for paid events.';
                                    }
                                    final n = double.tryParse(value);
                                    if (n == null || n <= 0) {
                                      return 'Please enter a valid price greater than 0.';
                                    }
                                  }
                                  return null;
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Price *',
                                  hintText: '0.00',
                                  prefixIcon: Icon(Iconsax.dollar_circle),
                                ),
                              ),
                            ),
                        ],
                      )),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // --- Submit Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.createEvent();
                      },
                      child: const Text('Create Event'),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
