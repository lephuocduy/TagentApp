import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_job_mobile/models/request/enable_to_earn_request.dart';
import 'package:it_job_mobile/repositories/implement/album_images_implement.dart';
import 'package:it_job_mobile/repositories/implement/applicants_implement.dart';
import 'package:it_job_mobile/views/bottom_tab_bar/bottom_tab_bar.dart';
import 'package:it_job_mobile/constants/url_api.dart';
import 'package:it_job_mobile/widgets/button/button.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sizer/sizer.dart';

import '../../constants/toast.dart';
import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../shared/applicant_preferences.dart';

class InputCardBackPage extends StatefulWidget {
  File cardFront;
  InputCardBackPage({
    Key? key,
    required this.cardFront,
  }) : super(key: key);

  @override
  State<InputCardBackPage> createState() => _InputCardBackPageState();
}

class _InputCardBackPageState extends State<InputCardBackPage> {
  String imagePath = '';
  File? cardBack;

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
                          ImagePath.cmnd2,
                        ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "• Bạn cần chụp mặt sau của CMND hoặc CCCD",
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
                content: imagePath.isEmpty ? 'Chụp Mặt Sau' : 'Gửi Đơn',
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
                            cardBack = img;
                          });
                        } catch (e) {
                          log("Failed to pick image: $e");
                        }
                      }
                    : () async {
                        if (cardBack != null) {
                          await AlbumImagesImplement()
                              .getAlbumImagesById(
                                UrlApi.albumImages,
                                "?applicantId=",
                                Jwt.parseJwt(
                                        ApplicantPreferences.getToken(''))['Id']
                                    .toString(),
                              )
                              .then((value) async => {
                                    if (value.data.isNotEmpty)
                                      {
                                        for (var i = 0;
                                            i < value.data.length;
                                            i++)
                                          {
                                            AlbumImagesImplement()
                                                .deleteAlbumImageById(
                                              UrlApi.albumImages,
                                              value.data[i].id,
                                              ApplicantPreferences.getToken(''),
                                            )
                                          }
                                      }
                                  });
                          await ApplicantsImplement().enableToEarn(
                            UrlApi.applicant,
                            EnableToEarnRequest(
                                id: Jwt.parseJwt(
                                        ApplicantPreferences.getToken(''))['Id']
                                    .toString(),
                                earnMoney: 2),
                            ApplicantPreferences.getToken(''),
                          );
                          AlbumImagesImplement().enableToEarnImageById(
                            UrlApi.albumImages,
                            Jwt.parseJwt(
                                    ApplicantPreferences.getToken(''))['Id']
                                .toString(),
                            widget.cardFront,
                            ApplicantPreferences.getToken(''),
                          );
                          AlbumImagesImplement().enableToEarnImageById(
                            UrlApi.albumImages,
                            Jwt.parseJwt(
                                    ApplicantPreferences.getToken(''))['Id']
                                .toString(),
                            cardBack!,
                            ApplicantPreferences.getToken(''),
                          );
                          showToastSuccess("Gửi đơn thành công chờ xét duyệt");
                          await Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => BottomTabBar(
                                        currentIndex: 3,
                                      )),
                              (route) => false);
                        } else {
                          showToastFail("Gửi đơn thất bại");
                        }
                      }),
          ],
        ),
      ),
    );
  }
}
