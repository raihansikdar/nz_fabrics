import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class NoInternetPage extends StatelessWidget {

  final VoidCallback onRetry;

  const NoInternetPage({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.16),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextComponent(
              text:"No Internet Connection.",
              color: Colors.grey,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: size.width > 550 ? 60 : 40,
            width: 200,
            child: ElevatedButton(
              onPressed: onRetry,
              child: const TextComponent(text:"Try Again",color: AppColors.whiteTextColor,),
            ),
          ),
        ],
      ),
    );
  }
}
