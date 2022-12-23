import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/views/wallet/input_card_front_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../providers/post_provider.dart';
import '../../widgets/button/button.dart';

class IntroducePage extends StatelessWidget {
  const IntroducePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
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
                  'Quyền lợi',
                  style: AppTextStyles.h3Black,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.card,
                      color: AppColor.black,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Kích hoạt ví',
                      style: AppTextStyles.h4Black,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.gift,
                      color: AppColor.black,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Mở cửa hàng đổi thưởng',
                      style: AppTextStyles.h4Black,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  children: [
                    Icon(
                      Iconsax.buy_crypto,
                      color: AppColor.black,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      'Nhận Tagent coin khi tham gia hoạt động',
                      style: AppTextStyles.h4Black,
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Divider(
                  color: AppColor.grey,
                  height: 2.h,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'Điều kiện',
                  style: AppTextStyles.h4darkGrey,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "Cung cấp hình ảnh giấy tờ tuỳ thân của bạn và chờ xét duyệt",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: AppTextStyles.h4Black,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Divider(
                  color: AppColor.grey,
                  height: 2.h,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'Hoạt động đổi thưởng',
                  style: AppTextStyles.h4darkGrey,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          color: AppColor.black,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Thích',
                          style: AppTextStyles.h4Black,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '+ ${postProvider.configuration.earnByLike}',
                          style: AppTextStyles.h4Success,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Icon(
                          Iconsax.buy_crypto,
                          color: AppColor.black,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: AppColor.black,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Chia sẻ',
                          style: AppTextStyles.h4Black,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '+ ${postProvider.configuration.earnByShare}',
                          style: AppTextStyles.h4Success,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Icon(
                          Iconsax.buy_crypto,
                          color: AppColor.black,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.unlimited,
                          color: AppColor.black,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Kết nối',
                          style: AppTextStyles.h4Black,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '+ ${postProvider.configuration.earnByMatch}',
                          style: AppTextStyles.h4Success,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Icon(
                          Iconsax.buy_crypto,
                          color: AppColor.black,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  height: 50.w,
                  width: 100.w,
                  child: Image.asset(
                    ImagePath.wallet,
                  ),
                ),
              ],
            ),
            ButtonDefault(
                width: 80.w,
                height: 7.h,
                content: 'Tiếp Tục',
                textStyle: AppTextStyles.h3White,
                backgroundBtn: AppColor.btnColor,
                voidCallBack: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => InputCardFrontPage()),
                  );
                })
          ],
        ),
      ),
    );
  }
}
