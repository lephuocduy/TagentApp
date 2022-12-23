import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/company.dart';
import 'package:it_job_mobile/repositories/implement/blocks_implement.dart';
import 'package:it_job_mobile/constants/url_api.dart';
import 'package:it_job_mobile/widgets/button/button.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_image_path.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../models/entity/block.dart';
import '../../../../shared/applicant_preferences.dart';

class ViewCompanyBlockedPage extends StatefulWidget {
  List<Block> blockedList;
  List<Company> companies;
  ViewCompanyBlockedPage(
      {Key? key, required this.blockedList, required this.companies})
      : super(key: key);

  @override
  State<ViewCompanyBlockedPage> createState() => _ViewCompanyBlockedPageState();
}

class _ViewCompanyBlockedPageState extends State<ViewCompanyBlockedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppColor.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Công Ty Đã Chặn',
          style: AppTextStyles.h3Black,
        ),
      ),
      body: widget.blockedList.isNotEmpty
          ? Column(
              children: [
                for (var list in widget.blockedList)
                  Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        height: 5.h,
                        width: 100.w,
                        color: AppColor.white,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var i = 0; i < widget.companies.length; i++)
                                if (list.companyId == widget.companies[i].id)
                                  Text(
                                    widget.companies[i].name.length < 40
                                        ? widget.companies[i].name
                                        : widget.companies[i].name
                                                .substring(0, 40) +
                                            "...",
                                    style: AppTextStyles.h4Black,
                                  ),
                              ButtonDefault(
                                width: 100,
                                height: 3.h,
                                content: "Bỏ Chặn",
                                textStyle: AppTextStyles.h4White,
                                backgroundBtn: AppColor.black,
                                voidCallBack: () {
                                  _showUnblockConfirmDialog(context, list.id);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            )
          : Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Image.asset(
                    ImagePath.blockedCompany,
                    fit: BoxFit.cover,
                    width: 50.w,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    "Bạn chưa chặn công ty nào",
                    style: AppTextStyles.h4Black,
                  )
                ],
              ),
            ),
    );
  }

  _showUnblockConfirmDialog(context, String id) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: "Xác Nhận",
      desc: "Bỏ chặn công ty này?",
      btnOkText: "Đồng ý",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        BlocksImplement()
            .unBlock(UrlApi.blocks, id, ApplicantPreferences.getToken(''));
        setState(() {
          widget.blockedList.removeWhere((element) => element.id == id);
        });
      },
    ).show();
  }
}
