import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../providers/detail_profile_provider.dart';

class ViewProfileJobPosition extends StatefulWidget {
  String jobPositionId;
  int selectedIndex;
  ViewProfileJobPosition({
    Key? key,
    required this.jobPositionId,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  State<ViewProfileJobPosition> createState() => _ViewProfileJobPositionState();
}

class _ViewProfileJobPositionState extends State<ViewProfileJobPosition> {
  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    detailProfileProvider.jobPositionId = widget.jobPositionId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Row(
            children: [
              const Icon(
                Iconsax.crown,
                size: 25,
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                "Vị trí công việc",
                style: AppTextStyles.h3Black,
              ),
              Text(
                "*",
                style: AppTextStyles.h4Red,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        InkWell(
          onTap: widget.selectedIndex == 1
              ? () async {
                  await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) =>
                            StatefulBuilder(builder: (context, setState) {
                          return Container(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    "Chọn vị trí công việc",
                                    style: AppTextStyles.h2Black,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Wrap(
                                    spacing: 5,
                                    runSpacing: 1.1,
                                    children: [
                                      for (var i = 0;
                                          i <
                                              detailProfileProvider
                                                  .listJobPosition.length;
                                          i++)
                                        ChoiceChip(
                                            label: Text(detailProfileProvider
                                                .listJobPosition[i].name),
                                            selected: widget.jobPositionId ==
                                                detailProfileProvider
                                                    .listJobPosition[i].id,
                                            labelStyle: TextStyle(
                                                color: AppColor.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: (widget.jobPositionId ==
                                                        detailProfileProvider
                                                            .listJobPosition[i]
                                                            .id)
                                                    ? AppColor.black
                                                    : AppColor.white,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            backgroundColor: AppColor.white,
                                            selectedColor: AppColor.white,
                                            onSelected: (isSelected) {
                                              setState(() {
                                                widget.jobPositionId =
                                                    detailProfileProvider
                                                        .listJobPosition[i].id;
                                                detailProfileProvider
                                                        .detailProfile!
                                                        .jobPositionId =
                                                    widget.jobPositionId;
                                              });
                                              Navigator.pop(context);
                                            }),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ) ??
                      widget.jobPositionId;
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              : null,
          child: Container(
            color: AppColor.white,
            child: Padding(
              padding: EdgeInsets.only(
                left: 5.w,
                right: 5.w,
                top: 3.w,
                bottom: 3.w,
              ),
              child: widget.jobPositionId.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Thêm vị trí công việc",
                          style: AppTextStyles.h4Grey,
                        ),
                        if (widget.selectedIndex == 1)
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
                        for (var i = 0;
                            i < detailProfileProvider.listJobPosition.length;
                            i++)
                          if (widget.jobPositionId ==
                              detailProfileProvider.listJobPosition[i].id)
                            Text(
                              detailProfileProvider.listJobPosition[i].name,
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
        )
      ],
    );
  }
}
