import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gym_app/app/core/providers/api_routes.dart';
import 'package:gym_app/app/core/services/user_info.dart';

/// Widget to load images from Laravel storage with Sanctum authentication
///
/// Usage:
/// ```dart
/// StorageNetworkImage(
///   imagePath: 'membership_package/mp-001.png',
///   width: 150,
///   height: 150,
/// )
/// ```
class StorageNetworkImage extends StatelessWidget {
  final String imagePath; // e.g., "membership_package/mp-001.png"
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const StorageNetworkImage({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: UserInfo().getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return placeholder ??
              Container(
                width: width,
                height: height,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
        }

        final token = snapshot.data ?? '';
        // Construct full URL: https://gym.sulthon.blue/storage/membership_package/mp-001.png
        final baseUrl = ApiUrl.baseUrl.replaceAll('/api/v1', '');
        final fullImageUrl = '$baseUrl/storage/$imagePath';

        Widget imageWidget = CachedNetworkImage(
          imageUrl: fullImageUrl,
          httpHeaders: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) =>
              placeholder ??
              Container(
                width: width,
                height: height,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          errorWidget: (context, url, error) =>
              errorWidget ??
              Container(
                width: width,
                height: height,
                color: Colors.grey[300],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    SizedBox(height: 4),
                    Text(
                      'Image not found',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
        );

        if (borderRadius != null) {
          return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
        }

        return imageWidget;
      },
    );
  }
}
