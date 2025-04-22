import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/features/plant_over_view/controller/layout_position_controller.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class LayoutImageDetails extends StatefulWidget {
  final String layoutName;
  final String imageUrl;

  const LayoutImageDetails({super.key, required this.layoutName, required this.imageUrl});

  @override
  State<LayoutImageDetails> createState() => _LayoutImageDetailsState();
}

class _LayoutImageDetailsState extends State<LayoutImageDetails> {


  @override
  void initState() {
    Get.find<LayoutPositionController>().fetchLayoutNodePositionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(text: widget.layoutName, backPreviousScreen: true),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions.customChild(
            childSize: const Size(1000, 1000),
            child: Image.network(
              widget.imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
            minScale: PhotoViewComputedScale.contained * 0.5,
            maxScale: PhotoViewComputedScale.covered * 4,
            initialScale: PhotoViewComputedScale.contained,
            // heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
          );
        },
        itemCount: 1,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        pageController: PageController(),
      ),
    );
  }
}