import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/models/response/suggest_search_response.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../repositories/implement/suggest_search_implement.dart';
import '../../../../constants/url_api.dart';
import '../../../../shared/applicant_preferences.dart';

class CreateProfileEducationPage extends StatefulWidget {
  final bool edit;
  String query;
  List<SuggestSearchResponse> educations;
  CreateProfileEducationPage(
      {Key? key, this.edit = false, this.query = '', required this.educations})
      : super(key: key);

  @override
  State<CreateProfileEducationPage> createState() =>
      _CreateProfileEducationPageState();
}

class _CreateProfileEducationPageState
    extends State<CreateProfileEducationPage> {
  final controller = TextEditingController();
  String edu = '';

  Timer? debouncer;

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
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
              'Sửa Thông Tin Trường',
              style: AppTextStyles.h3Black,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 18, right: 20),
                child: InkWell(
                  onTap: () async {
                    if (widget.query.isEmpty) {
                      _showValidationDialog(context);
                      return;
                    }
                    Navigator.pop(context, widget.query);
                  },
                  child: Text(
                    'Xong',
                    style: AppTextStyles.h3Black,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              controller.text = widget.query;
              edu = await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) =>
                        StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        backgroundColor: AppColor.primary,
                        insetPadding: EdgeInsets.all(20),
                        titlePadding: const EdgeInsets.only(
                          top: 20,
                        ),
                        contentPadding: const EdgeInsets.only(
                          top: 20,
                        ),
                        title: TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.search,
                          controller: controller,
                          onChanged: (String query) async => debounce(() async {
                            final educations = await SuggestSearchImplement()
                                .suggestSearch(UrlApi.educations, query);

                            try {
                              setState(() {
                                widget.educations = educations;
                              });
                            } catch (e) {
                              //
                            }
                          }),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15),
                            prefixIcon: Icon(
                              Iconsax.search_normal,
                              color: widget.query.isEmpty
                                  ? AppColor.darkGrey
                                  : AppColor.black,
                              size: 20,
                            ),
                            suffixIcon: widget.query.isNotEmpty
                                ? GestureDetector(
                                    child: Icon(
                                      Icons.close,
                                      color: AppColor.black,
                                    ),
                                    onTap: () {
                                      widget.query = '';
                                      controller.clear();
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                  )
                                : null,
                            hintText: "Tìm trường",
                            filled: true,
                            fillColor: AppColor.white,
                            border: InputBorder.none,
                          ),
                        ),
                        content: SizedBox(
                          height: 100.h,
                          width: 100.w,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var i = 0;
                                    i < widget.educations.length;
                                    i++)
                                  buildList(widget.educations[i]),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context, controller.text);
                              },
                              child: Text(
                                "Xong",
                                style: AppTextStyles.h4Black,
                              )),
                        ],
                      );
                    }),
                  ) ??
                  widget.query;
              setState(() {
                widget.query = edu;
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
                child: widget.query.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.teacher,
                                color: AppColor.grey,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Trường",
                                style: AppTextStyles.h4Grey,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: AppColor.grey,
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.teacher,
                                color: AppColor.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                widget.query.length < 38
                                    ? widget.query
                                    : widget.query.substring(0, 38) + "...",
                                style: AppTextStyles.h4Black,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: AppColor.black,
                          )
                        ],
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          InkWell(
            onTap: () {
              if (widget.edit) {
                _showDeleteConfirmDialog(context);
                return;
              }
              Navigator.pop(
                context,
                '',
              );
            },
            child: Container(
              height: 5.h,
              width: 100.w,
              alignment: Alignment.center,
              color: AppColor.white,
              child: Text(
                widget.edit ? "Xoá" : "Hủy",
                style: AppTextStyles.h4Red,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildList(SuggestSearchResponse education) => InkWell(
        onTap: () async {
          Navigator.pop(context, education.name!);
        },
        child: Column(
          children: [
            Container(
              color: AppColor.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 3.w, right: 3.w, top: 3.w, bottom: 3.w),
                    child: Text(
                      education.name!.length < 40
                          ? education.name!
                          : education.name!.substring(0, 40) + "...",
                      style: AppTextStyles.h4Black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            )
          ],
        ),
      );

  _showValidationDialog(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      title: "Bạn chưa điền đầy đủ thông tin",
      desc: widget.edit
          ? "Bạn muốn tiếp tục điền thông tin hay xóa?"
          : "Bạn muốn tiếp tục điền thông tin hay dừng lại?",
      btnOkText: "Tiếp tục",
      btnCancelText: widget.edit ? "Xóa" : "Dừng lại",
      btnCancelOnPress: () {
        Navigator.pop(
          context,
          '',
        );
      },
      btnOkOnPress: () {},
    ).show();
  }

  _showDeleteConfirmDialog(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: "Xác Nhận",
      desc: "Bạn có đồng ý xoá thông tin này?",
      btnOkText: "Đồng ý",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.pop(
          context,
          '',
        );
      },
    ).show();
  }
}
