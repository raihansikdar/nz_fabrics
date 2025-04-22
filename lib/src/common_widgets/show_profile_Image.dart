import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowProfileImage{
  ShowProfileImage._();

  static void showLargeImage(String imageUrl) {
    Get.dialog(
      Dialog(
        insetAnimationDuration: const Duration(seconds: 1),
        insetAnimationCurve: Curves.easeInOutCubicEmphasized,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

}