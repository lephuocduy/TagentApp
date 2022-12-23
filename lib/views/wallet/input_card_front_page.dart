import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_job_mobile/views/wallet/input_card_back_page.dart';
import 'package:it_job_mobile/widgets/button/button.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';

class InputCardFrontPage extends StatefulWidget {
  InputCardFrontPage({
    Key? key,
  }) : super(key: key);

  @override
  State<InputCardFrontPage> createState() => _InputCardFrontPageState();
}

class _InputCardFrontPageState extends State<InputCardFrontPage> {
  String imagePath = '';
  File? cardFront;

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: BackButton(
          color: AppColor.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Bật Kiếm Tiền',
          style: AppTextStyles.h3Black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xác thực thông tin',
                  style: AppTextStyles.h2Black,
                ),
                Divider(
                  color: AppColor.grey,
                  height: 5.h,
                ),
                Text(
                  'Loại giấy tờ',
                  style: AppTextStyles.h4darkGrey,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      color: AppColor.blue,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Chứng minh nhân dân hoặc cccd',
                      style: AppTextStyles.h4Black,
                    ),
                  ],
                ),
                Divider(
                  color: AppColor.grey,
                  height: 2.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  height: 60.w,
                  width: 100.w,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: AppColor.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imagePath.isNotEmpty
                      ? Ink.image(
                          image: imagePath.contains('https://')
                              ? NetworkImage(imagePath)
                              : FileImage(File(imagePath)) as ImageProvider,
                          fit: BoxFit.cover,
                          child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    imagePath = '';
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.grey,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: AppColor.white,
                                    child: Icon(
                                      Icons.cancel,
                                      color: AppColor.black,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )),
                        )
                      : Image.asset(
                          ImagePath.cmnd1,
                        ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "• Bạn cần chụp mặt trước của CMND hoặc CCCD",
                  style: AppTextStyles.h4Black,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "• Hãy đảm bảo CMND hoặc CCCD là bản gốc và còn hiệu lực",
                  style: AppTextStyles.h4Black,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.shield_tick,
                      color: AppColor.blue,
                      size: 30,
                    ),
                    SizedBox(
                      width: 82.w,
                      child: Text(
                        "Thông tin được bảo mật an toàn trong hệ thống",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: AppTextStyles.h4Black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ButtonDefault(
                width: 80.w,
                height: 7.h,
                content: imagePath.isEmpty ? 'Chụp Mặt Trước' : 'Tiếp Tục',
                textStyle: AppTextStyles.h3White,
                backgroundBtn: AppColor.btnColor,
                voidCallBack: imagePath.isEmpty
                    ? () async {
                        try {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (image == null) return;
                          File? img = File(image.path);
                          img = await _cropImage(imageFile: img);
                          setState(() {
                            imagePath = img!.path;
                            cardFront = img;
                          });
                        } catch (e) {
                          log("Failed to pick image: $e");
                        }
                      }
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => InputCardBackPage(
                                    cardFront: cardFront!,
                                  )),
                        );
                      }),
          ],
        ),
      ),
    );
  }
}
