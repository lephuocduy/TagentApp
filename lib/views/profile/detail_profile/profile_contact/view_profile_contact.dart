import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/models/entity/contacts.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/profile/detail_profile/profile_contact/create_profile_contact_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:social_media_flutter/widgets/icons.dart';
import 'package:social_media_flutter/widgets/text.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';

class ViewProfileContact extends StatefulWidget {
  String githubLink;
  String linkedInLink;
  String facebookLink;
  int selectedIndex;
  ViewProfileContact({
    Key? key,
    required this.githubLink,
    required this.linkedInLink,
    required this.facebookLink,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  State<ViewProfileContact> createState() => _ViewProfileContactState();
}

class _ViewProfileContactState extends State<ViewProfileContact> {
  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    detailProfileProvider.githubLink = widget.githubLink;
    detailProfileProvider.linkedInLink = widget.linkedInLink;
    detailProfileProvider.facebookLink = widget.facebookLink;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Row(
            children: [
              const Icon(
                Iconsax.call,
                size: 25,
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                "Liên hệ",
                style: AppTextStyles.h3Black,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        if (widget.githubLink.isNotEmpty)
          Column(
            children: [
              Container(
                color: AppColor.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5.w,
                    right: 5.w,
                    top: 1.w,
                    bottom: 1.w,
                  ),
                  child: SocialWidget(
                    placeholderText: widget.githubLink,
                    iconData: SocialIconsFlutter.github,
                    iconColor: AppColor.black,
                    link: 'https://www.github.com/' + widget.githubLink,
                    placeholderStyle:
                        TextStyle(color: AppColor.black, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        if (widget.linkedInLink.isNotEmpty)
          Column(
            children: [
              Container(
                color: AppColor.white,
                child: Padding(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      top: 1.w,
                      bottom: 1.w,
                    ),
                    child: SocialWidget(
                      placeholderText: widget.linkedInLink,
                      iconData: SocialIconsFlutter.linkedin_box,
                      iconColor: AppColor.blue,
                      link: 'https://www.linkedin.com/' + widget.linkedInLink,
                      placeholderStyle:
                          TextStyle(color: AppColor.black, fontSize: 20),
                    )),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        if (widget.facebookLink.isNotEmpty)
          Column(
            children: [
              Container(
                color: AppColor.white,
                child: Padding(
                    padding: EdgeInsets.only(
                      left: 5.w,
                      right: 5.w,
                      top: 1.w,
                      bottom: 1.w,
                    ),
                    child: SocialWidget(
                      placeholderText: widget.facebookLink,
                      iconData: SocialIconsFlutter.facebook_box,
                      iconColor: AppColor.blue,
                      link: 'https://www.facebook.com/' + widget.facebookLink,
                      placeholderStyle:
                          TextStyle(color: AppColor.black, fontSize: 20),
                    )),
              ),
              SizedBox(
                height: 1.h,
              ),
            ],
          ),
        widget.selectedIndex == 1
            ? InkWell(
                onTap: () async {
                  Contacts contact = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return CreateProfileContactPage(
                      githubLink: widget.githubLink,
                      linkedInLink: widget.linkedInLink,
                      facebookLink: widget.facebookLink,
                    );
                  }));
                  setState(() {
                    widget.githubLink = contact.githubLink;
                    detailProfileProvider.detailProfile!.githubLink =
                        widget.githubLink;
                    widget.linkedInLink = contact.linkedInLink;
                    detailProfileProvider.detailProfile!.linkedInLink =
                        widget.linkedInLink;
                    widget.facebookLink = contact.facebookLink;
                    detailProfileProvider.detailProfile!.facebookLink =
                        widget.facebookLink;
                  });
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
                          (widget.githubLink.isNotEmpty &&
                                  widget.linkedInLink.isNotEmpty &&
                                  widget.facebookLink.isNotEmpty)
                              ? "Sửa thông tin liên lạc"
                              : "Thêm thông tin liên lạc",
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
            : (widget.githubLink.isNotEmpty ||
                    widget.linkedInLink.isNotEmpty ||
                    widget.facebookLink.isNotEmpty)
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
                            "Chưa thêm thông tin liên lạc",
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
