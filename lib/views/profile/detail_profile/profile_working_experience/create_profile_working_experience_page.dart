import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:it_job_mobile/models/entity/job_position.dart';
import 'package:it_job_mobile/models/entity/working_experience.dart';
import 'package:it_job_mobile/models/response/suggest_search_response.dart';
import 'package:it_job_mobile/repositories/implement/suggest_search_implement.dart';
import 'package:it_job_mobile/repositories/implement/job_positions_implement.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../constants/url_api.dart';
import '../../../../shared/applicant_preferences.dart';
import '../../../../widgets/dialog/dialog_date_picker.dart';

class CreateProfileWorkingExperiencePage extends StatefulWidget {
  final bool edit;
  WorkingExperience data;
  List<SuggestSearchResponse> companies;
  List<JobPosition> listJobPosition;

  CreateProfileWorkingExperiencePage({
    Key? key,
    this.edit = false,
    required this.data,
    required this.companies,
    required this.listJobPosition,
  }) : super(key: key);

  @override
  State<CreateProfileWorkingExperiencePage> createState() =>
      _CreateProfileWorkingExperiencePageState();
}

class _CreateProfileWorkingExperiencePageState
    extends State<CreateProfileWorkingExperiencePage> {
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  DateTime timeNow = DateTime.now();
  String startDate = '';
  String endDate = '';
  bool checkWorking = false;
  final controllerCompany = TextEditingController();
  final controllerJobPosition = TextEditingController();
  String com = '';
  String job = '';

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
    super.initState();
    startDateTime = widget.edit ? widget.data.startDate : timeNow;
    endDateTime = widget.edit ? widget.data.endDate : timeNow;
    startDate = widget.edit
        ? DateFormat('dd/MM/yyyy').format(widget.data.startDate)
        : '';
    endDate =
        widget.edit ? DateFormat('dd/MM/yyyy').format(widget.data.endDate) : '';
    if (widget.edit &&
        DateFormat('dd/MM/yyyy')
            .format(widget.data.endDate)
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
              'Sửa Thông Tin Công Ty',
              style: AppTextStyles.h3Black,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 18, right: 20),
                child: InkWell(
                  onTap: () {
                    if ((widget.data.companyName.isEmpty ||
                            startDate.isEmpty ||
                            endDate.isEmpty ||
                            widget.data.jobPositionId.isEmpty) &&
                        (widget.data.companyName.isEmpty ||
                            startDate.isEmpty ||
                            checkWorking == false ||
                            widget.data.jobPositionId.isEmpty)) {
                      _showValidationDialog(context);
                      return;
                    }
                    Navigator.pop(
                      context,
                      WorkingExperience(
                          id: widget.data.id,
                          profileApplicantId: widget.data.profileApplicantId,
                          companyName: widget.data.companyName,
                          startDate: startDateTime,
                          endDate: checkWorking
                              ? DateTime.parse('1969-01-01').toLocal()
                              : endDateTime,
                          jobPositionId: widget.data.jobPositionId),
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
              controllerCompany.text = widget.data.companyName;
              com = await showDialog(
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
                          controller: controllerCompany,
                          onChanged: (String query) async => debounce(() async {
                            final companies = await SuggestSearchImplement()
                                .suggestSearch(UrlApi.company, query);
                            try {
                              setState(() {
                                widget.companies = companies;
                              });
                            } catch (e) {
                              //
                            }
                          }),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15),
                            prefixIcon: Icon(
                              Iconsax.search_normal,
                              color: widget.data.companyName.isEmpty
                                  ? AppColor.darkGrey
                                  : AppColor.black,
                              size: 20,
                            ),
                            suffixIcon: widget.data.companyName.isNotEmpty
                                ? GestureDetector(
                                    child: Icon(
                                      Icons.close,
                                      color: AppColor.black,
                                    ),
                                    onTap: () {
                                      widget.data.companyName = '';
                                      controllerCompany.clear();
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                  )
                                : null,
                            hintText: "Tìm công ty",
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
                                    i < widget.companies.length;
                                    i++)
                                  buildList(widget.companies[i]),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context, controllerCompany.text);
                              },
                              child: Text(
                                "Xong",
                                style: AppTextStyles.h4Black,
                              )),
                        ],
                      );
                    }),
                  ) ??
                  widget.data.companyName;
              setState(() {
                widget.data.companyName = com;
                widget.data.jobPositionId = '';
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
                child: widget.data.companyName.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.buildings4,
                                color: AppColor.grey,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Công ty",
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
                                Iconsax.buildings4,
                                color: AppColor.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                widget.data.companyName.length < 35
                                    ? widget.data.companyName
                                    : widget.data.companyName.substring(0, 35) +
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
            onTap: widget.data.companyName.isEmpty
                ? null
                : () async {
                    for (var i = 0; i < widget.listJobPosition.length; i++) {
                      if (widget.data.jobPositionId ==
                          widget.listJobPosition[i].id) {
                        controllerJobPosition.text =
                            widget.listJobPosition[i].name;
                      }
                    }
                    job = await showDialog(
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
                              title: Container(
                                color: AppColor.white,
                                child: TextFormField(
                                  autofocus: true,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.search,
                                  controller: controllerJobPosition,
                                  onChanged: (String query) async =>
                                      debounce(() async {
                                    final jobPositions =
                                        await JobPositionsImplement()
                                            .searchJobPositions(
                                                UrlApi.jobPositions, query);
                                    try {
                                      setState(() {
                                        widget.listJobPosition =
                                            jobPositions.data;
                                      });
                                    } catch (e) {
                                      //
                                    }
                                  }),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 15),
                                    prefixIcon: Icon(
                                      Iconsax.search_normal,
                                      color: controllerJobPosition.text.isEmpty
                                          ? AppColor.darkGrey
                                          : AppColor.black,
                                      size: 20,
                                    ),
                                    suffixIcon: controllerJobPosition
                                            .text.isNotEmpty
                                        ? GestureDetector(
                                            child: Icon(
                                              Icons.close,
                                              color: AppColor.black,
                                            ),
                                            onTap: () {
                                              widget.data.jobPositionId = '';
                                              controllerJobPosition.clear();
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            },
                                          )
                                        : null,
                                    hintText: "Vị trí làm việc",
                                    filled: true,
                                    fillColor: AppColor.white,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(
                                top: 20,
                              ),
                              content: SizedBox(
                                height: 100.h,
                                width: 100.w,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (var i = 0;
                                          i < widget.listJobPosition.length;
                                          i++)
                                        buildListJobPosition(
                                            widget.listJobPosition[i]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ) ??
                        widget.data.jobPositionId;
                    setState(() {
                      widget.data.jobPositionId = job;
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
                child: widget.data.jobPositionId.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.briefcase,
                                color: AppColor.grey,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "Vị trí làm việc",
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
                                Iconsax.briefcase,
                                color: AppColor.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              for (var i = 0;
                                  i < widget.listJobPosition.length;
                                  i++)
                                if (widget.data.jobPositionId ==
                                    widget.listJobPosition[i].id)
                                  Text(
                                    widget.listJobPosition[i].name.length < 35
                                        ? widget.listJobPosition[i].name
                                        : widget.listJobPosition[i].name
                                                .substring(0, 35) +
                                            "...",
                                    style: AppTextStyles.h4Black,
                                  )
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
            onTap: widget.data.jobPositionId.isEmpty
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
                                "Ngày bắt đầu làm việc",
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
                "Hiện đang làm việc tại đây",
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
                                "Ngày kết thúc làm việc",
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
                WorkingExperience(
                    id: '',
                    profileApplicantId: '',
                    companyName: '',
                    startDate: startDateTime,
                    endDate: endDateTime,
                    jobPositionId: widget.data.jobPositionId),
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

  Widget buildList(SuggestSearchResponse company) => InkWell(
        onTap: () async {
          Navigator.pop(context, company.name!);
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
                      company.name!.length < 35
                          ? company.name!
                          : company.name!.substring(0, 35) + "...",
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

  Widget buildListJobPosition(JobPosition jobPosition) => InkWell(
        onTap: () async {
          Navigator.pop(context, jobPosition.id);
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
                      jobPosition.name.length < 35
                          ? jobPosition.name
                          : jobPosition.name.substring(0, 35) + "...",
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
          WorkingExperience(
              id: '',
              profileApplicantId: '',
              companyName: '',
              startDate: startDateTime,
              endDate: endDateTime,
              jobPositionId: widget.data.jobPositionId),
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
          WorkingExperience(
              id: '',
              profileApplicantId: '',
              companyName: '',
              startDate: startDateTime,
              endDate: endDateTime,
              jobPositionId: widget.data.jobPositionId),
        );
      },
    ).show();
  }
}
