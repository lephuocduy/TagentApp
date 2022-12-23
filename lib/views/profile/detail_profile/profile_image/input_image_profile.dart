import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:path/path.dart';

import '../../../../models/entity/store_image.dart';

class InputImageProfile extends StatefulWidget {
  final StoreImage albumImage;
  InputImageProfile({
    Key? key,
    required this.albumImage,
  }) : super(key: key);

  @override
  State<InputImageProfile> createState() => _InputImageProfileState();
}

class _InputImageProfileState extends State<InputImageProfile> {
  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: widget.albumImage.urlImage.isEmpty
          ? InkWell(
              onTap: () async {
                final image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (image == null) return;

                final directory = await getApplicationDocumentsDirectory();
                final name = basename(image.path);
                final imageFile = File('${directory.path}/$name');
                final newImage = await File(image.path).copy(imageFile.path);

                setState(() => widget.albumImage.urlImage = newImage.path);

                detailProfileProvider.listAlbumImage.add(
                  StoreImage(
                    id: widget.albumImage.id,
                    urlImage: widget.albumImage.urlImage,
                    profileApplicantId: widget.albumImage.profileApplicantId!,
                    image: newImage,
                  ),
                );
              },
              child: Container(
                height: 50.w,
                width: 37.w,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.add_circle,
                    color: AppColor.black,
                    size: 35,
                  ),
                ),
              ),
            )
          : Container(
              height: 50.w,
              width: 37.w,
              decoration: BoxDecoration(
                border: Border.all(width: 3, color: AppColor.white),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Ink.image(
                image: widget.albumImage.urlImage.contains('https://')
                    ? CachedNetworkImageProvider(widget.albumImage.urlImage)
                    : FileImage(File(widget.albumImage.urlImage))
                        as ImageProvider,
                fit: BoxFit.cover,
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        _showDeleteConfirmDialog(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.grey,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColor.white,
                          child: Icon(
                            Icons.cancel,
                            color: AppColor.black,
                            size: 30,
                          ),
                        ),
                      ),
                    )),
              ),
            ),
    );
  }

  _showDeleteConfirmDialog(context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: "Xác Nhận",
      desc: "Bạn có đồng ý xoá ảnh này?",
      btnOkText: "Đồng ý",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        setState(() => {
              detailProfileProvider.listAlbumImage
                  .removeWhere((element) => element.id == widget.albumImage.id),
              widget.albumImage.urlImage = '',
              widget.albumImage.id = '',
            });
      },
    ).show();
  }
}
