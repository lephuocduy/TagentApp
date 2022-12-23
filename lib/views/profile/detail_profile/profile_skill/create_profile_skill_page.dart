import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/models/entity/profile_applicant_skill.dart';
import 'package:it_job_mobile/models/entity/skill.dart';
import 'package:it_job_mobile/models/entity/skill_level.dart';
import 'package:it_job_mobile/repositories/implement/skill_levels_implement.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_text_style.dart';
import '../../../../repositories/implement/skills_implement.dart';
import '../../../../constants/url_api.dart';

class CreateProfileSkillPage extends StatefulWidget {
  final bool edit;
  ProfileApplicantSkill data;
  List<Skill> skills;
  List<Skill> skillsProfile;
  List<Skill> skillSearch;

  CreateProfileSkillPage({
    Key? key,
    this.edit = false,
    required this.data,
    required this.skills,
    required this.skillsProfile,
    required this.skillSearch,
  }) : super(key: key);

  @override
  _CreateProfileSkillPageState createState() => _CreateProfileSkillPageState();
}

class _CreateProfileSkillPageState extends State<CreateProfileSkillPage> {
  List<SkillLevel> skillLevels = [];
  final controllerSkill = TextEditingController();
  Skill proSkill = Skill(id: '', name: '', skillGroupId: '');
  String skillLv = '';
  Skill skillData = Skill(id: '', name: '', skillGroupId: '');

  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    if (widget.edit) {
      SkillsImplement()
          .getSkillById(UrlApi.skills, widget.data.skillId)
          .then((value) => {
                skillData = value.data!,
              });
    }
  }

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

  var isSelected = false;
  bool editSkill = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.primary,
        body: ListView(physics: const BouncingScrollPhysics(), children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Sửa Kỹ Năng',
              style: AppTextStyles.h3Black,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 18, right: 20),
                child: InkWell(
                  onTap: () {
                    if ((widget.data.skillId.isEmpty ||
                        widget.data.skillLevel.isEmpty)) {
                      _showValidationDialog(context);
                      return;
                    }
                    Navigator.pop(
                      context,
                      ProfileApplicantSkill(
                        id: widget.data.id,
                        profileApplicantId: widget.data.profileApplicantId,
                        skillId: widget.data.skillId,
                        skillLevel: widget.data.skillLevel,
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
          Column(
            children: [
              InkWell(
                onTap: () async {
                  for (var i = 0; i < widget.skills.length; i++) {
                    if (widget.data.skillId == widget.skills[i].id) {
                      controllerSkill.text = widget.skills[i].name;
                    }
                  }

                  proSkill = await showDialog(
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
                              controller: controllerSkill,
                              onChanged: (String query) async =>
                                  debounce(() async {
                                final skills = await SkillsImplement()
                                    .searchSkills(widget.skillsProfile, query);
                                try {
                                  setState(() {
                                    widget.skillSearch = skills;
                                  });
                                } catch (e) {
                                  //
                                }
                              }),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 15),
                                prefixIcon: Icon(
                                  Iconsax.search_normal,
                                  color: widget.data.skillId.isEmpty
                                      ? AppColor.darkGrey
                                      : AppColor.black,
                                  size: 20,
                                ),
                                suffixIcon: widget.data.skillId.isNotEmpty
                                    ? GestureDetector(
                                        child: Icon(
                                          Icons.close,
                                          color: AppColor.black,
                                        ),
                                        onTap: () {
                                          widget.data.skillId = '';
                                          controllerSkill.clear();
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        },
                                      )
                                    : null,
                                hintText: "Tìm kỹ năng",
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
                                        i < widget.skillSearch.length;
                                        i++)
                                      buildList(widget.skillSearch[i]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ) ??
                      skillData;
                  setState(() {
                    widget.data.skillId = proSkill.id;
                    editSkill = true;
                    widget.data.skillLevel = '';
                    skillData = proSkill;
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
                    child: widget.data.skillId.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.unlimited,
                                    color: AppColor.grey,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    "Kỹ Năng",
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
                                    Iconsax.unlimited,
                                    color: AppColor.black,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  for (var i = 0; i < widget.skills.length; i++)
                                    if (widget.data.skillId ==
                                        widget.skills[i].id)
                                      Text(
                                        widget.skills[i].name.length < 35
                                            ? widget.skills[i].name
                                            : widget.skills[i].name
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
                onTap: widget.data.skillId.isEmpty
                    ? null
                    : () async {
                        await SkillLevelsImplement()
                            .getLevelById(
                                UrlApi.skillLevels, skillData.skillGroupId)
                            .then((value) => {
                                  setState(() {
                                    skillLevels = value.data;
                                  })
                                });
                        String currentLevel = widget.data.skillLevel;
                        skillLv = await showDialog(
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
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Chọn trình độ',
                                            style: AppTextStyles.h3Black,
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Wrap(
                                            spacing: 10,
                                            children: [
                                              for (var i = 0;
                                                  i < skillLevels.length;
                                                  i++)
                                                ChoiceChip(
                                                    label: Text(
                                                        skillLevels[i].name),
                                                    selected: currentLevel ==
                                                        skillLevels[i].name,
                                                    selectedColor:
                                                        AppColor.white,
                                                    labelStyle: TextStyle(
                                                        color: AppColor.black,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color: (currentLevel ==
                                                                skillLevels[i]
                                                                    .name)
                                                            ? AppColor.black
                                                            : AppColor.white,
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    backgroundColor:
                                                        AppColor.white,
                                                    onSelected: (isSelected) {
                                                      setState(() {
                                                        widget.data.skillLevel =
                                                            skillLevels[i].name;
                                                      });
                                                      Navigator.pop(
                                                          context,
                                                          widget
                                                              .data.skillLevel);
                                                    }),
                                            ],
                                          )
                                        ]),
                                  ),
                                );
                              }),
                            ) ??
                            currentLevel;
                        setState(() {
                          widget.data.skillLevel = skillLv;
                          editSkill = false;
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
                    child: widget.data.skillLevel.isEmpty || editSkill
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
                                    "Trình độ",
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
                                  Text(
                                    widget.data.skillLevel.length < 35
                                        ? widget.data.skillLevel
                                        : widget.data.skillLevel
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
                onTap: () {
                  if (widget.edit) {
                    _showDeleteConfirmDialog(context);
                    return;
                  }
                  Navigator.pop(
                    context,
                    ProfileApplicantSkill(
                      id: '',
                      profileApplicantId: '',
                      skillId: '',
                      skillLevel: '',
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
          SizedBox(
            height: 2.h,
          ),
        ]));
  }

  Widget buildList(Skill skill) => InkWell(
        onTap: () async {
          Navigator.pop(context, skill);
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
                      skill.name.length < 35
                          ? skill.name
                          : skill.name.substring(0, 35) + "...",
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
      desc: "Bạn muốn tiếp tục ",
      btnOkText: "Tiếp tục",
      btnCancelText: "Dừng lại",
      btnCancelOnPress: () {
        Navigator.pop(
          context,
          ProfileApplicantSkill(
            id: '',
            profileApplicantId: '',
            skillId: '',
            skillLevel: '',
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
      desc: "Bạn có đồng ý xoá thông tin này",
      btnOkText: "Đồng ý",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.pop(
          context,
          ProfileApplicantSkill(
            id: '',
            profileApplicantId: '',
            skillId: '',
            skillLevel: '',
          ),
        );
      },
    ).show();
  }
}
