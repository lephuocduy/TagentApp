import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/models/entity/certificate.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_certificate/create_profile_certificate_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';

class ViewProfileCertificate extends StatefulWidget {
  String profileApplicantId;
  int selectedIndex;
  ViewProfileCertificate({
    Key? key,
    required this.profileApplicantId,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  State<ViewProfileCertificate> createState() => _ViewProfileCertificateState();
}

class _ViewProfileCertificateState extends State<ViewProfileCertificate> {
  bool more = false;

  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              more = !more;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              children: [
                const Icon(
                  Iconsax.award,
                  size: 25,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Chứng chỉ",
                  style: AppTextStyles.h3Black,
                ),
                SizedBox(
                  width: 3.w,
                ),
                if (detailProfileProvider.listCertificate.isNotEmpty &&
                    detailProfileProvider.listCertificate.length > 1)
                  more
                      ? const Icon(
                          Iconsax.arrow_circle_down,
                        )
                      : Row(children: [
                          Icon(
                            Iconsax.arrow_circle_right,
                            color: AppColor.black,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            "+" +
                                (detailProfileProvider.listCertificate.length -
                                        1)
                                    .toString(),
                            style: AppTextStyles.h4Red,
                          )
                        ]),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        if (detailProfileProvider.listCertificate.isNotEmpty && more == true)
          for (var list in detailProfileProvider.listCertificate)
            InkWell(
              onTap: widget.selectedIndex == 1
                  ? () async {
                      Certificate cer = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CreateProfileCertificatePage(
                              edit: true,
                              data: list,
                              skillGroups: detailProfileProvider.skillGroups,
                            );
                          })) ??
                          list;
                      if (cer.name.isNotEmpty) {
                        setState(() {
                          list = cer;
                        });
                      } else {
                        setState(() {
                          detailProfileProvider.listCertificate.remove(list);
                        });
                      }
                    }
                  : null,
              child: Column(
                children: [
                  Container(
                    color: AppColor.white,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                        top: 3.w,
                        bottom: 3.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            list.name.length < 45
                                ? list.name
                                : list.name.substring(0, 45) + "...",
                            style: AppTextStyles.h4Black,
                          ),
                          if (widget.selectedIndex == 1)
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: AppColor.black,
                            )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
        if (detailProfileProvider.listCertificate.isNotEmpty && more == false)
          InkWell(
            onTap: widget.selectedIndex == 1
                ? () async {
                    Certificate cer = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CreateProfileCertificatePage(
                            edit: true,
                            data: detailProfileProvider.listCertificate[0],
                            skillGroups: detailProfileProvider.skillGroups,
                          );
                        })) ??
                        detailProfileProvider.listCertificate[0];

                    if (cer.name.isNotEmpty) {
                      setState(() {
                        detailProfileProvider.listCertificate[0] = cer;
                      });
                    } else {
                      setState(() {
                        detailProfileProvider.listCertificate.removeAt(0);
                      });
                    }
                  }
                : null,
            child: Column(
              children: [
                Container(
                  color: AppColor.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      top: 3.w,
                      bottom: 3.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          detailProfileProvider.listCertificate[0].name.length <
                                  45
                              ? detailProfileProvider.listCertificate[0].name
                              : detailProfileProvider.listCertificate[0].name
                                      .substring(0, 45) +
                                  "...",
                          style: AppTextStyles.h4Black,
                        ),
                        if (widget.selectedIndex == 1)
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: AppColor.black,
                          )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          ),
        if (detailProfileProvider.listCertificate.length < 5)
          widget.selectedIndex == 1
              ? InkWell(
                  onTap: () async {
                    Certificate cer = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CreateProfileCertificatePage(
                            data: Certificate(
                              id: '',
                              name: '',
                              skillGroupId: '',
                              profileApplicantId: widget.profileApplicantId,
                              grantDate: DateTime.now(),
                              expiryDate: DateTime.now(),
                            ),
                            skillGroups: detailProfileProvider.skillGroups,
                          );
                        })) ??
                        Certificate(
                          id: '',
                          name: '',
                          skillGroupId: '',
                          profileApplicantId: widget.profileApplicantId,
                          grantDate: DateTime.now(),
                          expiryDate: DateTime.now(),
                        );

                    if (cer.name.isNotEmpty) {
                      setState(() {
                        detailProfileProvider.listCertificate.add(cer);
                      });
                    }
                  },
                  child: Container(
                    color: AppColor.white,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                        top: 3.w,
                        bottom: 3.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Thêm chứng chỉ",
                            style: AppTextStyles.h4Grey,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: AppColor.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : (detailProfileProvider.listCertificate.length != 0)
                  ? Container()
                  : Container(
                      color: AppColor.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 5.w,
                          right: 5.w,
                          top: 3.w,
                          bottom: 3.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Chưa thêm chứng chỉ",
                              style: AppTextStyles.h4Grey,
                            ),
                          ],
                        ),
                      ),
                    )
      ],
    );
  }
}
