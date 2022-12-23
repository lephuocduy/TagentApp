import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:it_job_mobile/models/entity/contacts.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';

class CreateProfileContactPage extends StatefulWidget {
  String githubLink;
  String linkedInLink;
  String facebookLink;
  CreateProfileContactPage({
    Key? key,
    required this.githubLink,
    required this.linkedInLink,
    required this.facebookLink,
  }) : super(key: key);

  @override
  State<CreateProfileContactPage> createState() =>
      _CreateProfileContactPageState();
}

class _CreateProfileContactPageState extends State<CreateProfileContactPage> {
  final controllerGithub = TextEditingController();
  final controllerLinkedIn = TextEditingController();
  final controllerFacebook = TextEditingController();
  @override
  void initState() {
    super.initState();
    controllerGithub.text = widget.githubLink;
    controllerLinkedIn.text = widget.linkedInLink;
    controllerFacebook.text = widget.facebookLink;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Sửa Thông Tin Liên Lạc',
              style: AppTextStyles.h3Black,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 18, right: 20),
                child: InkWell(
                  onTap: () {
                    widget.githubLink = controllerGithub.text;
                    widget.linkedInLink = controllerLinkedIn.text;
                    widget.facebookLink = controllerFacebook.text;
                    Navigator.pop(
                        context,
                        Contacts(
                          githubLink: widget.githubLink,
                          linkedInLink: widget.linkedInLink,
                          facebookLink: widget.facebookLink,
                        ));
                  },
                  child: Text(
                    'Xong',
                    style: AppTextStyles.h3Black,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.github,
                  size: 20,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Github",
                  style: AppTextStyles.h3Black,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            color: AppColor.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: 3.w,
                right: 5.w,
                top: 0,
                bottom: 0,
              ),
              child: TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: controllerGithub,
                onChanged: (value) {
                  setState(() {
                    widget.githubLink = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: widget.githubLink.isNotEmpty
                      ? GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: AppColor.black,
                          ),
                          onTap: () {
                            widget.githubLink = '';
                            controllerGithub.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                      : null,
                  hintText: "Nhập username",
                  filled: true,
                  fillColor: AppColor.white,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.linkedin,
                  size: 20,
                  color: AppColor.blue,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "LinkedIn",
                  style: AppTextStyles.h3Black,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            color: AppColor.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: 3.w,
                right: 5.w,
                top: 0,
                bottom: 0,
              ),
              child: TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: controllerLinkedIn,
                onChanged: (value) {
                  setState(() {
                    widget.linkedInLink = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: widget.linkedInLink.isNotEmpty
                      ? GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: AppColor.black,
                          ),
                          onTap: () {
                            widget.linkedInLink = '';
                            controllerLinkedIn.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                      : null,
                  hintText: "Nhập username",
                  filled: true,
                  fillColor: AppColor.white,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.facebookSquare,
                  size: 20,
                  color: AppColor.blue,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Facebook",
                  style: AppTextStyles.h3Black,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            color: AppColor.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: 3.w,
                right: 5.w,
                top: 0,
                bottom: 0,
              ),
              child: TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: controllerFacebook,
                onChanged: (value) {
                  setState(() {
                    widget.facebookLink = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: widget.facebookLink.isNotEmpty
                      ? GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: AppColor.black,
                          ),
                          onTap: () {
                            widget.facebookLink = '';
                            controllerFacebook.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                      : null,
                  hintText: "Nhập username",
                  filled: true,
                  fillColor: AppColor.white,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}
