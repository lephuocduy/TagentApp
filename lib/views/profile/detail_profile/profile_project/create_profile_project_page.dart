import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:it_job_mobile/models/entity/project.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../widgets/dialog/dialog_date_picker.dart';

class CreateProfileProjectPage extends StatefulWidget {
  final bool edit;
  Project data;
  CreateProfileProjectPage({
    Key? key,
    this.edit = false,
    required this.data,
  }) : super(key: key);

  @override
  _CreateProfileProjectPageState createState() =>
      _CreateProfileProjectPageState();
}

class _CreateProfileProjectPageState extends State<CreateProfileProjectPage> {
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  DateTime timeNow = DateTime.now();
  String startDate = '';
  String endDate = '';
  bool checkWorking = false;
  final controllerProjectName = TextEditingController();
  final controllerProjectDescription = TextEditingController();
  final controllerProjectLink = TextEditingController();
  final controllerProjectSkill = TextEditingController();
  final controllerProjectJob = TextEditingController();

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
  void initState() {
    controllerProjectName.text = widget.data.name;
    controllerProjectDescription.text = widget.data.description;
    controllerProjectJob.text = widget.data.jobPosition;
    controllerProjectSkill.text = widget.data.skill;
    controllerProjectLink.text = widget.data.link;
    super.initState();
    startDateTime = widget.edit ? widget.data.startTime : timeNow;
    endDateTime = widget.edit ? widget.data.endTime : timeNow;
    startDate = widget.edit
        ? DateFormat('dd/MM/yyyy').format(widget.data.startTime)
        : '';
    endDate =
        widget.edit ? DateFormat('dd/MM/yyyy').format(widget.data.endTime) : '';
    if (widget.edit &&
        DateFormat('dd/MM/yyyy')
            .format(widget.data.endTime)
            .contains('01/01/1969')) {
      checkWorking = true;
    }
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
              'Sửa Thông Tin Dự Án',
              style: AppTextStyles.h3Black,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 18, right: 20),
                child: InkWell(
                  onTap: () {
                    widget.data.name = controllerProjectName.text;
                    widget.data.description = controllerProjectDescription.text;
                    widget.data.jobPosition = controllerProjectJob.text;
                    widget.data.skill = controllerProjectSkill.text;
                    widget.data.link = controllerProjectLink.text;
                    if ((widget.data.name.isEmpty ||
                            startDate.isEmpty ||
                            endDate.isEmpty ||
                            widget.data.description.isEmpty ||
                            widget.data.link.isEmpty ||
                            widget.data.skill.isEmpty ||
                            widget.data.jobPosition.isEmpty) &&
                        (widget.data.name.isEmpty ||
                            startDate.isEmpty ||
                            checkWorking == false ||
                            widget.data.description.isEmpty ||
                            widget.data.link.isEmpty ||
                            widget.data.skill.isEmpty ||
                            widget.data.jobPosition.isEmpty)) {
                      _showValidationDialog(context);
                      return;
                    }
                    Navigator.pop(
                      context,
                      Project(
                        id: widget.data.id,
                        name: widget.data.name,
                        link: widget.data.link,
                        description: widget.data.description,
                        startTime: startDateTime,
                        endTime: checkWorking
                            ? DateTime.parse('1969-01-01').toLocal()
                            : endDateTime,
                        skill: widget.data.skill,
                        jobPosition: widget.data.jobPosition,
                        profileApplicantId: widget.data.profileApplicantId,
                      ),
                    );
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
                  Iconsax.global,
                  size: 20,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Tên dự án",
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
                controller: controllerProjectName,
                onChanged: (value) {
                  setState(() {
                    widget.data.name = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: widget.data.name.isNotEmpty
                      ? GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: AppColor.black,
                          ),
                          onTap: () {
                            widget.data.name = '';
                            controllerProjectName.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                      : null,
                  hintText: "Nhập tên dự án",
                  hintStyle: AppTextStyles.h4Grey,
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
                const Icon(
                  Iconsax.book,
                  size: 20,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Giới thiệu dự án",
                  style: AppTextStyles.h3Black,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
            color: AppColor.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: 5.w,
                right: 5.w,
                top: 3.w,
                bottom: 3.w,
              ),
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLines: 4,
                maxLength: 500,
                controller: controllerProjectDescription,
                onChanged: (value) {
                  setState(() {
                    widget.data.description = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: widget.data.description.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: GestureDetector(
                            child: Icon(
                              Icons.close,
                              color: AppColor.black,
                            ),
                            onTap: () {
                              widget.data.description = '';
                              controllerProjectDescription.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                        )
                      : null,
                ),
                style: AppTextStyles.h4Black,
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Row(
              children: [
                const Icon(
                  Iconsax.link,
                  size: 20,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Link dự án",
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
                controller: controllerProjectLink,
                onChanged: (value) {
                  setState(() {
                    widget.data.link = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: widget.data.link.isNotEmpty
                      ? GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: AppColor.black,
                          ),
                          onTap: () {
                            widget.data.link = '';
                            controllerProjectLink.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                      : null,
                  hintText: "Nhập link dự án",
                  hintStyle: AppTextStyles.h4Grey,
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
                const Icon(
                  Iconsax.cpu,
                  size: 20,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Công nghệ sử dụng",
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
                maxLines: 2,
                autofocus: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: controllerProjectSkill,
                onChanged: (value) {
                  setState(() {
                    widget.data.skill = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: widget.data.skill.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            child: Icon(
                              Icons.close,
                              color: AppColor.black,
                            ),
                            onTap: () {
                              widget.data.skill = '';
                              controllerProjectSkill.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                        )
                      : null,
                  hintText: "Nhập công nghệ dự án sử dụng",
                  hintStyle: AppTextStyles.h4Grey,
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
                const Icon(
                  Iconsax.location,
                  size: 20,
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  "Vị trí trong dự án",
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
                controller: controllerProjectJob,
                onChanged: (value) {
                  setState(() {
                    widget.data.jobPosition = value;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: widget.data.jobPosition.isNotEmpty
                      ? GestureDetector(
                          child: Icon(
                            Icons.close,
                            color: AppColor.black,
                          ),
                          onTap: () {
                            widget.data.jobPosition = '';
                            controllerProjectJob.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )
                      : null,
                  hintText: "Nhập vị trí trong dự án",
                  hintStyle: AppTextStyles.h4Grey,
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
          InkWell(
            onTap: () => DialogDatePicker.showSheet(
              context,
              child: buildStartDatePicker(),
              onClicked: () {
                setState(() {
                  startDate = DateFormat('dd/MM/yyyy').format(startDateTime);
                  FocusScope.of(context).requestFocus(FocusNode());
                });
                Navigator.pop(context);
              },
            ),
            child: Container(
              color: AppColor.white,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                  top: 3.w,
                  bottom: 3.w,
                ),
                child: startDate.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.calendar_1,
                                color: AppColor.grey,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Ngày bắt đầu dự án",
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
                                Iconsax.calendar_1,
                                color: AppColor.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                startDate,
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
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  activeColor: AppColor.black,
                  value: checkWorking,
                  onChanged: (value) {
                    setState(() {
                      checkWorking = !checkWorking;
                      endDate = '';
                    });
                  }),
              Text(
                "Dự án vẫn đang phát triển",
                style:
                    checkWorking ? AppTextStyles.h4Black : AppTextStyles.h4Grey,
              )
            ],
          ),
          InkWell(
            onTap: startDate.isEmpty || checkWorking
                ? null
                : () => DialogDatePicker.showSheet(
                      context,
                      child: buildEndDatePicker(),
                      onClicked: () {
                        setState(() {
                          endDate =
                              DateFormat('dd/MM/yyyy').format(endDateTime);
                        });
                        Navigator.pop(context);
                      },
                    ),
            child: Container(
              color: AppColor.white,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                  top: 3.w,
                  bottom: 3.w,
                ),
                child: endDate.isEmpty || checkWorking
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.calendar_1,
                                color: AppColor.grey,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Ngày kết thúc dự án",
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
                                Iconsax.calendar_1,
                                color: AppColor.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                endDate,
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
                Project(
                  id: '',
                  name: '',
                  startTime: startDateTime,
                  endTime: endDateTime,
                  description: widget.data.description,
                  jobPosition: widget.data.jobPosition,
                  link: widget.data.link,
                  skill: widget.data.skill,
                  profileApplicantId: '',
                ),
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
          ),
        ],
      ),
    );
  }

  Widget buildStartDatePicker() => SizedBox(
        height: 30.h,
        child: CupertinoDatePicker(
          dateOrder: DatePickerDateOrder.dmy,
          minimumYear: 1970,
          maximumYear: timeNow.year,
          maximumDate: timeNow,
          initialDateTime: timeNow,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => startDateTime = dateTime),
        ),
      );

  Widget buildEndDatePicker() => SizedBox(
        height: 30.h,
        child: CupertinoDatePicker(
          dateOrder: DatePickerDateOrder.dmy,
          minimumDate: startDateTime,
          maximumYear: timeNow.year,
          maximumDate: timeNow,
          initialDateTime: timeNow,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => endDateTime = dateTime),
        ),
      );

  _showValidationDialog(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      title: "Bạn chưa điền đầy đủ thông tin",
      desc: widget.edit
          ? "Bạn muốn tiếp tục điền thông tin hay xóa tất cả?"
          : "Bạn muốn tiếp tục điền thông tin hay dừng lại?",
      btnOkText: "Tiếp tục",
      btnCancelText: widget.edit ? "Xóa" : "Dừng lại",
      btnCancelOnPress: () {
        Navigator.pop(
          context,
          Project(
            id: '',
            name: '',
            startTime: startDateTime,
            endTime: endDateTime,
            description: widget.data.description,
            jobPosition: widget.data.jobPosition,
            link: widget.data.link,
            skill: widget.data.skill,
            profileApplicantId: '',
          ),
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
          Project(
            id: '',
            name: '',
            startTime: startDateTime,
            endTime: endDateTime,
            description: widget.data.description,
            jobPosition: widget.data.jobPosition,
            link: widget.data.link,
            skill: widget.data.skill,
            profileApplicantId: '',
          ),
        );
      },
    ).show();
  }
}
