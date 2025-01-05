import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg for SVG support
import 'package:cached_network_image/cached_network_image.dart';

class DetailImage extends StatelessWidget {
  final String? imageUrl; // Firebase image URL
  final String placeholderSvg; // Placeholder SVG if the image is not available
  final double height;
  final double gradientHeight;

  const DetailImage({
    Key? key,
    this.imageUrl, // Firebase image URL or null
    required this.placeholderSvg,
    required this.height,
    this.gradientHeight = 20.0, // Default gradient height of 12 pixels
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient container at the top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: gradientHeight, // Gradient height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 133, 133, 133).withOpacity(0.9), // Reduced opacity at bottom
                  Colors.grey.withOpacity(0.35), // Additional middle stop
                  Colors.grey.withOpacity(0.25), // Additional middle stop
                  Colors.grey.withOpacity(0.05), // Additional middle stop
                  Colors.transparent,
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Image container
        Container(
          height: height, // Custom height
          width: double.infinity, // Full width
          decoration: BoxDecoration(
            image: imageUrl != null && imageUrl!.isNotEmpty
                ? DecorationImage(
                    image: CachedNetworkImageProvider(
                        imageUrl!), // Use CachedNetworkImageProvider
                    fit: BoxFit.cover, // Adjust image to cover the container
                  )
                : null, // Don't use a decoration if no URL is provided
          ),
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl!, // Display Firebase image
                  fit: BoxFit.cover, // Make sure the image covers the container
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) {
                    // If the image fails to load, show the SVG placeholder
                    return SvgPicture.asset(
                      placeholderSvg, // SVG placeholder if the image fails
                      fit: BoxFit.cover,
                    );
                  },
                )
              : SvgPicture.asset(
                  placeholderSvg, // Fallback to SVG placeholder if no image URL
                  fit: BoxFit.cover,
                ),
        ),
      ],
    );
  }
}
