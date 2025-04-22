import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class ErrorPage extends StatelessWidget {

  final VoidCallback onRetry;

  const ErrorPage({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 80),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextComponent(
              text:"Server or other issues detected. Please try again later or contact support if needed.",
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
              child: const TextComponent(text:"Retry",color: AppColors.whiteTextColor,),
            ),
          ),
        ],
      ),
    );
  }
}
