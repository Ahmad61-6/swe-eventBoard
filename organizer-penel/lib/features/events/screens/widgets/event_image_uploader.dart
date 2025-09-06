import 'dart:html' as html; // For web

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/icons/t_circular_icon.dart'; // Assuming you have this
import 'package:yt_ecommerce_admin_panel/common/widgets/images/t_rounded_image.dart'; // Assuming you have this
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart'; // For ImageType
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class TEventImageUploader extends StatelessWidget {
  const TEventImageUploader({
    super.key,
    required this.onPickImage,
    this.pickedFile, // Pass the picked file from controller
    this.uploadedImageUrl, // Pass the uploaded URL from controller
    this.width = 150,
    this.height = 150,
  });

  final VoidCallback
      onPickImage; // Callback to trigger image picking in controller
  final html.File? pickedFile; // The file picked by the user
  final String? uploadedImageUrl; // The URL of the uploaded image
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    // Determine which image to display
    String? displayImage;
    ImageType imageType = ImageType.asset; // Default
    html.File?
        memoryImage; // Not used directly here for web File, but structure is similar

    if (uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty) {
      // Show uploaded image from URL
      displayImage = uploadedImageUrl;
      imageType = ImageType.network;
    } else if (pickedFile != null) {
      // Show picked file (for web, we can't easily display it without converting,
      // so maybe show a placeholder or filename)
      // A more advanced version might use FileReader, but for simplicity, show filename or placeholder
      // For now, let's show a placeholder indicating it's picked
      displayImage = null; // Will use placeholder
      imageType = ImageType.asset;
    } else {
      // Show default placeholder
      displayImage = null; // Will use placeholder
      imageType = ImageType.asset;
    }

    return Stack(
      children: [
        // Display the image or placeholder
        TRoundedImage(
          // For web file, displaying directly is tricky. Show placeholder or filename.
          // If you have a way to convert html.File to ImageProvider, you could use it.
          // For now, a simple approach:
          image:
              displayImage, // Will be null if pickedFile or default, triggering placeholder logic in TRoundedImage if handled
          width: width,
          height: height,
          imageType: displayImage != null
              ? imageType
              : ImageType.asset, // Use asset for placeholder
          // You might need to modify TRoundedImage or pass a specific placeholder asset
          // For simplicity, assume TRoundedImage handles null image gracefully or has a default
          // Or pass a specific placeholder asset path:
          // image: displayImage ?? 'assets/images/content/default_image.png', // Adjust path
          // imageType: ImageType.asset,
        ),
        // Display file name if picked but not uploaded
        if (pickedFile != null && uploadedImageUrl == null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: TColors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: TSizes.xs),
              child: Text(
                pickedFile!.name,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.apply(color: TColors.white),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        // Edit/Upload Icon Button
        Positioned(
          right: -TSizes.sm, // Adjust position as needed
          bottom: -TSizes.sm,
          child: TCircularIcon(
            icon: Iconsax.edit_2,
            size: TSizes.iconMd,
            color: TColors.white,
            backgroundColor: TColors.primary,
            onPressed: onPickImage, // Trigger the pick function
          ),
        ),
      ],
    );
  }
}
