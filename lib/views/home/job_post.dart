import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/models/entity/featured_job_post.dart';
import 'package:it_job_mobile/providers/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class JobPostPage extends StatefulWidget {
  final FeaturedJobPost companyInformation;
  final bool isFront;
  const JobPostPage({
    Key? key,
    required this.companyInformation,
    required this.isFront,
  }) : super(key: key);

  @override
  State<JobPostPage> createState() => _JobPostPageState();
}

class _JobPostPageState extends State<JobPostPage> {
  String jobPosition = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<PostProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront ? buildFrontPost() : buildPost(),
    );
  }

  Widget buildFrontPost() => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<PostProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 0 : 400;
          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: Stack(
              children: [
                buildPost(),
                buildStamps(),
              ],
            ),
          );
        }),
        onPanStart: (details) {
          final provider = Provider.of<PostProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<PostProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<PostProvider>(context, listen: false);
          provider.endPosition(context, widget.companyInformation);
        },
      );

  Widget buildPost() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  // ignore: unnecessary_cast
                  (widget.companyInformation.albumImages.isNotEmpty
                          ? widget.companyInformation.albumImages[0].urlImage
                                  .contains('https://')
                              ? CachedNetworkImageProvider(widget
                                  .companyInformation.albumImages[0].urlImage)
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
                    height: 1.h,
                  ),
                  buildJobPosition(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildTitle() => Row(
        children: [
          SizedBox(
            width: 75.w,
            child: Text(
              widget.companyInformation.title,
              style: AppTextStyles.h1White,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      );

  Widget buildJobPosition() => Builder(builder: (context) {
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.white,
              ),
              width: 12,
              height: 12,
            ),
            SizedBox(
              width: 2.w,
            ),
            SizedBox(
              width: 75.w,
              child: Text(
                widget.companyInformation.jobPosition.name,
                style: AppTextStyles.h2White,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        );
      });

  Widget buildStamps() {
    final provider = Provider.of<PostProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case PostStatus.like:
        final child = buildStamp(
          angle: -0.5,
          color: AppColor.success,
          text: 'THÍCH',
          opacity: opacity,
        );
        return Positioned(top: 64, left: 50, child: child);
      case PostStatus.dislike:
        final child = buildStamp(
          angle: 0.5,
          color: AppColor.red,
          text: 'BỎ QUA',
          opacity: opacity,
        );
        return Positioned(top: 64, right: 50, child: child);
      case PostStatus.information:
        final child = buildStamp(
          color: AppColor.blue,
          text: 'XEM THÔNG TIN',
          opacity: opacity,
        );
        return Positioned(bottom: 128, right: 0, left: 0, child: child);
      default:
        return Container();
    }
  }

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
