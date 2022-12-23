import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:it_job_mobile/models/entity/certificate.dart';
import 'package:it_job_mobile/models/entity/skill_group.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../widgets/dialog/dialog_date_picker.dart';

class CreateProfileCertificatePage extends StatefulWidget {
  final bool edit;
  Certificate data;
  List<SkillGroup> skillGroups;

  CreateProfileCertificatePage(
      {Key? key,
      this.edit = false,
      required this.data,
      required this.skillGroups})
      : super(key: key);

  @override
  State<CreateProfileCertificatePage> createState() =>
      _CreateProfileCertificatePageState();
}

class _CreateProfileCertificatePageState
    extends State<CreateProfileCertificatePage> {
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  DateTime timeNow = DateTime.now();
  String startDate = '';
  String endDate = '';
  bool checkWorking = false;
  final controller = TextEditingController();
  String cer = '';
  String skillGr = '';

  @override
  void initState() {
    super.initState();
    startDateTime = widget.edit ? widget.data.grantDate : timeNow;
    endDateTime = widget.edit ? widget.data.expiryDate : timeNow;
    startDate = widget.edit
        ? DateFormat('dd/MM/yyyy').format(widget.data.grantDate)
        : '';
    endDate = widget.edit
        ? DateFormat('dd/MM/yyyy').format(widget.data.expiryDate)
        : '';
    if (widget.edit &&
        DateFormat('dd/MM/yyyy')
            .format(widget.data.expiryDate)
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
              'Sửa Thông Tin Chứng Chỉ',
              style: AppTextStyles.h3Black,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 18, right: 20),
                child: InkWell(
                  onTap: () {
                    if ((widget.data.name.isEmpty ||
                            widget.data.skillGroupId.isEmpty ||
                            startDate.isEmpty ||
                            endDate.isEmpty) &&
                        (widget.data.name.isEmpty ||
                            widget.data.skillGroupId.isEmpty ||
                            startDate.isEmpty ||
                            checkWorking == false)) {
                      _showValidationDialog(context);
                      return;
                    }
                    Navigator.pop(
                      context,
                      Certificate(
                        id: widget.data.id,
                        name: widget.data.name,
                        skillGroupId: widget.data.skillGroupId,
                        profileApplicantId: widget.data.profileApplicantId,
                        grantDate: startDateTime,
                        expiryDate: checkWorking
                            ? DateTime.parse('1969-01-01').toLocal()
                            : endDateTime,
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
          InkWell(
            onTap: () async {
              String currentGr = widget.data.skillGroupId;
              skillGr = await showDialog(
                    context: context,
                    builder: (context) =>
                        StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        backgroundColor: AppColor.primary,
                        insetPadding: const EdgeInsets.all(20),
                        contentPadding: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        content: Container(
                          width: 100.w,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                              'Chọn Nhóm Chứng Chỉ',
                              style: AppTextStyles.h3Black,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Wrap(
                              spacing: 10,
                              children: [
                                for (var i = 0;
                                    i < widget.skillGroups.length;
                                    i++)
                                  ChoiceChip(
                                      label: Text(widget.skillGroups[i].name),
                                      selected:
                                          currentGr == widget.skillGroups[i].id,
                                      selectedColor: AppColor.white,
                                      labelStyle: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: (currentGr ==
                                                  widget.skillGroups[i].id)
                                              ? AppColor.black
                                              : AppColor.white,
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      backgroundColor: AppColor.white,
                                      onSelected: (isSelected) {
                                        setState(() {
                                          widget.data.skillGroupId =
                                              widget.skillGroups[i].id;
                                        });
                                        Navigator.pop(
                                            context, widget.data.skillGroupId);
                                      }),
                              ],
                            )
                          ]),
                        ),
                      );
                    }),
                  ) ??
                  currentGr;
              setState(() {
                widget.data.skillGroupId = skillGr;
                widget.data.name = "";
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
                child: widget.data.skillGroupId.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.medal_star,
                                color: AppColor.grey,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Nhóm chứng chỉ",
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
                                Iconsax.medal_star,
                                color: AppColor.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              for (var i = 0;
                                  i < widget.skillGroups.length;
                                  i++)
                                if (widget.data.skillGroupId ==
                                    widget.skillGroups[i].id)
                                  Text(
                                    widget.skillGroups[i].name.length < 35
                                        ? widget.skillGroups[i].name
                                        : widget.skillGroups[i].name
                                                .substring(0, 35) +
                                            "...",
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
            onTap: widget.data.skillGroupId.isEmpty
                ? null
                : () async {
                    controller.text = widget.data.name;
                    cer = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) =>
                              StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              backgroundColor: AppColor.primary,
                              insetPadding: EdgeInsets.all(20),
                              contentPadding: const EdgeInsets.only(
                                top: 20,
                              ),
                              content: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      autofocus: true,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.search,
                                      controller: controller,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(top: 15),
                                        prefixIcon: Icon(
                                          Iconsax.edit_2,
                                          color: widget.data.name.isEmpty
                                              ? AppColor.darkGrey
                                              : AppColor.black,
                                          size: 20,
                                        ),
                                        suffixIcon: widget.data.name.isNotEmpty
                                            ? GestureDetector(
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColor.black,
                                                ),
                                                onTap: () {
                                                  widget.data.name = '';
                                                  controller.clear();
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                },
                                              )
                                            : null,
                                        hintText: "Nhập chứng chỉ",
                                        filled: true,
                                        fillColor: AppColor.white,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    SizedBox(
                                      height: 100.h,
                                      width: 100.w,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(
                                        context,
                                        controller.text,
                                      );
                                    },
                                    child: Text(
                                      "Xong",
                                      style: AppTextStyles.h4Black,
                                    )),
                              ],
                            );
                          }),
                        ) ??
                        widget.data.name;

                    setState(() {
                      widget.data.name = cer;
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
                child: widget.data.name.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.award,
                                color: AppColor.grey,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Chứng chỉ",
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
                                Iconsax.award,
                                color: AppColor.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                widget.data.name.length < 38
                                    ? widget.data.name
                                    : widget.data.name.substring(0, 38) + "...",
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
            onTap: widget.data.name.isEmpty
                ? null
                : () => DialogDatePicker.showSheet(
                      context,
                      child: buildStartDatePicker(),
                      onClicked: () {
                        setState(() {
                          startDate =
                              DateFormat('dd/MM/yyyy').format(startDateTime);
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
                                "Ngày chứng chỉ được cấp",
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
                "Chứng chỉ không có thời hạn",
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
                                "Ngày chứng chỉ hết hạn",
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
                Certificate(
                  id: '',
                  name: '',
                  skillGroupId: '',
                  profileApplicantId: '',
                  grantDate: DateTime.now(),
                  expiryDate: DateTime.now(),
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
          )
        ],
      ),
    );
  }

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
          Certificate(
            id: '',
            name: '',
            skillGroupId: '',
            profileApplicantId: '',
            grantDate: DateTime.now(),
            expiryDate: DateTime.now(),
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
          Certificate(
            id: '',
            name: '',
            skillGroupId: '',
            profileApplicantId: '',
            grantDate: DateTime.now(),
            expiryDate: DateTime.now(),
          ),
        );
      },
    ).show();
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
}
