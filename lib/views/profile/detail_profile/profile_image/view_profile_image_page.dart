import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/store_image.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import 'input_image_profile.dart';

class ViewProfileImagePage extends StatefulWidget {
  String profileApplicantId;
  int selectedIndex;
  ViewProfileImagePage({
    Key? key,
    required this.profileApplicantId,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  State<ViewProfileImagePage> createState() => _ViewProfileImagePageState();
}

class _ViewProfileImagePageState extends State<ViewProfileImagePage> {
  late PageController _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    return widget.selectedIndex == 1
        ? Padding(
            padding: EdgeInsets.only(left: 7.w, right: 7.w),
            child: Column(
              children: [
                Row(
                  children: [
                    InputImageProfile(
                      albumImage:
                          detailProfileProvider.listAlbumImage.length >= 1
                              ? detailProfileProvider.listAlbumImage[0]
                              : StoreImage(
                                  id: '0',
                                  urlImage: '',
                                  profileApplicantId: widget.profileApplicantId,
                                ),
                    ),
                    InputImageProfile(
                      albumImage:
                          detailProfileProvider.listAlbumImage.length >= 2
                              ? detailProfileProvider.listAlbumImage[1]
                              : StoreImage(
                                  id: '1',
                                  urlImage: '',
                                  profileApplicantId: widget.profileApplicantId,
                                ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InputImageProfile(
                      albumImage:
                          detailProfileProvider.listAlbumImage.length >= 3
                              ? detailProfileProvider.listAlbumImage[2]
                              : StoreImage(
                                  id: '2',
                                  urlImage: '',
                                  profileApplicantId: widget.profileApplicantId,
                                ),
                    ),
                    InputImageProfile(
                      albumImage:
                          detailProfileProvider.listAlbumImage.length >= 4
                              ? detailProfileProvider.listAlbumImage[3]
                              : StoreImage(
                                  id: '3',
                                  urlImage: '',
                                  profileApplicantId: widget.profileApplicantId,
                                ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : detailProfileProvider.listAlbumImage.length != 0
            ? AspectRatio(
                aspectRatio: 0.85,
                child: PageView.builder(
                    itemCount: detailProfileProvider.listAlbumImage.length,
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return carouselView(
                          detailProfileProvider.listAlbumImage, index);
                    }),
              )
            : Container();
  }

  Widget carouselView(List<StoreImage> data, int index) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 0.0;
          if (_pageController.position.haveDimensions) {
            value = index.toDouble() - (_pageController.page ?? 0);
            value = (value * 0.038).clamp(-1, 1);
          }
          return Transform.rotate(
            angle: pi * value,
            child: carouselCard(data[index]),
          );
        });
  }

  Widget carouselCard(StoreImage data) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: data.urlImage.contains('https://')
                        ? CachedNetworkImageProvider(data.urlImage)
                        : FileImage(data.image!) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black26)
                  ]),
            ),
          ),
        )
      ],
    );
  }
}
