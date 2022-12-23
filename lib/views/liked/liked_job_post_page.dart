import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_text_style.dart';
import '../../models/entity/featured_job_post.dart';
import '../../providers/post_provider.dart';

class LikedJobPostPage extends StatelessWidget {
  String jobPosition = '';
  bool view;
  final FeaturedJobPost companyInformation;
  LikedJobPostPage({
    Key? key,
    required this.companyInformation,
    required this.view
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
              final provider =
                  Provider.of<PostProvider>(context, listen: false);
              provider.getJobPostDetail(context, companyInformation, 1, view);
            },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  // ignore: unnecessary_cast
                  (companyInformation.albumImages.isNotEmpty
                          ? companyInformation.albumImages[0].urlImage
                                  .contains('https://')
                              ? CachedNetworkImageProvider(companyInformation.albumImages[0].urlImage)
                              : const NetworkImage(
                                  'https://mucinmanhtai.com/wp-content/themes/BH-WebChuan-032320/assets/images/default-thumbnail-400.jpg')
                          : const NetworkImage(
                              'https://mucinmanhtai.com/wp-content/themes/BH-WebChuan-032320/assets/images/default-thumbnail-400.jpg'))
                      as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7, 1],
            )),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),
                  buildTitle(),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  buildJobPosition(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() => Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              companyInformation.title,
              style: AppTextStyles.h4White,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      );

  Widget buildJobPosition() => Builder(builder: (context) {
        final provider = Provider.of<PostProvider>(context);
        final listJobPosition = provider.listJobPosition;

        for (var i = 0; i < listJobPosition.length; i++) {
          if (companyInformation.jobPositionId == listJobPosition[i].id) {
            jobPosition = listJobPosition[i].name;
          }
        }
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.white,
              ),
              width: 6,
              height: 6,
            ),
            SizedBox(
              width: 2.w,
            ),
            SizedBox(
              width: 30.w,
              child: Text(
                jobPosition,
                style: AppTextStyles.h5White,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        );
      });
}
