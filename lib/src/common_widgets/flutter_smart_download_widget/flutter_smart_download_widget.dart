import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:open_filex/open_filex.dart';




enum DialogType {
  bottomSheet,
  popup
}

class FlutterSmartDownloadDialog {
  static Future<void> show({
    required BuildContext context,
    required String filePath,
    required DialogType dialogType,
  }) async {
    switch (dialogType) {
      case DialogType.bottomSheet:
        _showDownloadBottomSheet(context, filePath);
        break;
      case DialogType.popup:
        _showDownloadPopup(context, filePath);
        break;
    }
  }

  static Future<void> _showDownloadBottomSheet(BuildContext context, String filePath) async {
    Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 180,
          transform: Matrix4.translationValues(0, -size.height * 0.035, 0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteTextColor,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.redColor, width: 2),
                  ),
                  child: Image.asset(
                    AssetsPath.downloadGif,
                    height: size.height * 0.04,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Download Complete",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * k18TextSize,
                  ),
                ),
                Text(
                  "Check your internal storage's Download folder",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: size.height * k14TextSize,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade400, width: size.height * 0.001),
                        minimumSize: size.width < 600
                            ? Size(size.width * 0.4, size.height * 0.04)
                            : Size(size.width * 0.025, size.height * 0.050),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.016,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.016),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide.none,
                        minimumSize: size.width < 600
                            ? Size(size.width * 0.4, size.height * 0.04)
                            : Size(size.width * 0.025, size.height * 0.050),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await OpenFilex.open(filePath);
                      },
                      child: Text(
                        "Open",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.016,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> _showDownloadPopup(BuildContext context, String filePath) async {
    Size size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Align(
            alignment: Alignment.center,
            child: Container(
              transform: Matrix4.translationValues(0, -size.height * 0.027, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.whiteTextColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.redColor, width: 2),
                    ),
                    child: Image.asset(
                      AssetsPath.downloadGif,
                      height: size.height * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Download Complete",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * k18TextSize,
                    ),
                  ),
                  Text(
                    "Check your internal storage's Download folder",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: size.height * k14TextSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade400, width: size.height * 0.001),
                    minimumSize: size.width < 600
                        ? Size(size.width * 0.26, size.height * 0.04)
                        : Size(size.width * 0.025, size.height * 0.050),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.height * 0.016,
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.016),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    side: BorderSide.none,
                    minimumSize: size.width < 600
                        ? Size(size.width * 0.26, size.height * 0.04)
                        : Size(size.width * 0.025, size.height * 0.050),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await OpenFilex.open(filePath);
                  },
                  child: Text(
                    "Open",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.016,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/*

Future<void> _showDownloadBottomSheet(BuildContext context,String filePath) async {
  Size size = MediaQuery.of(context).size;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 180,
        transform: Matrix4.translationValues(0, -size.height * k40TextSize, 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.whiteTextColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.redColor, width: 2),
                ),
                child: Image.asset(
                  AssetsPath.downloadGif,
                  height: size.height * 0.04,
                ),
              ),
              const SizedBox(height: 10),
               Text(
                "Download Complete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * k18TextSize,
                ),
              ),
               Text(
                "Check your internal storage Download folder",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize:  size.height * k14TextSize,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade400, width: size.height * 0.001),
                      minimumSize: size.width < 600
                          ? Size(size.width * 0.4, size.height * 0.04)
                          : Size(size.width * 0.025, size.height * 0.050),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.height * 0.016,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.016),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      side: BorderSide.none,
                      minimumSize: size.width < 600
                          ? Size(size.width * 0.4, size.height * 0.04)
                          : Size(size.width * 0.025, size.height * 0.050),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () async {
                      OpenFilex.open(filePath);
                    },
                    child: Text(
                      "Open",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.016,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _showDownloadPopup(BuildContext context, String filePath) async {
  Size size = MediaQuery.of(context).size;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:  Colors.white,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        title: Align(
          alignment: Alignment.center,
          child: Container(
            transform: Matrix4.translationValues(0, -size.height * 0.027, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SvgPicture.asset(AssetsPath.alertIconSVG,height: size.height * 0.045,),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteTextColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.redColor,width: 2)
                    ),
                    child: Image.asset(AssetsPath.downloadGif,height: size.height * 0.045,)),
                SizedBox(height: size.height * k10TextSize),
                Text(
                  "Download Complete",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * k18TextSize,
                  ),
                ),
                Text(
                  "Check your internal storage's Download folder",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize:  size.height * k14TextSize,
                  ),
                ),
              ],
            ),
          ),
        ),

        // content: Text(widget.message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade400, width: size.height * 0.001),
                  minimumSize: size.width < 600 ?   Size(size.width * 0.26, size.height * 0.04) : Size(size.width * 0.025, size.height * 0.050),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.height * 0.016,
                  ),
                ),
              ),
              SizedBox(width: size.width *0.016,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  side: BorderSide.none,
                  minimumSize: size.width < 600 ?   Size(size.width * 0.26, size.height * 0.04) : Size(size.width * 0.025, size.height * 0.050),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),

                ),
                onPressed: () async{
                  OpenFilex.open(filePath);
                  Navigator.of(context).pop();
                },
                child:  Text(
                  "Open",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.016,
                      fontWeight: FontWeight.w700
                  ),
                ),
              )

            ],
          ),
        ],
      );
    },
  );
}


*/