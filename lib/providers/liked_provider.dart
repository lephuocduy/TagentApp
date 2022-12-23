import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/matching.dart';
import 'package:it_job_mobile/repositories/implement/likes_implement.dart';

import '../../constants/url_api.dart';

class LikedProvider extends ChangeNotifier {
  bool isLoadingJobPostLiked = false;
  List<Matching> companiesInformationJobPostLiked = [];

  bool isLoadingLiked = false;
  List<Matching> companiesInformationLiked = [];

  bool isLoadingMatching = false;
  List<Matching> companiesInformationMatching = [];

  void getJobPostLiked(String id) async {
    isLoadingJobPostLiked = true;
    companiesInformationJobPostLiked.clear();
    companiesInformationJobPostLiked = [];
    final value = await LikesImplement().getJobPostLiked(
      UrlApi.likes,
      id,
    );
    for (var i = 0; i < value.data.length; i++) {
      if (value.data[i].match == false && value.data[i].jobPost.status == 0) {
        companiesInformationJobPostLiked.add(value.data[i]);
      }
    }
    isLoadingJobPostLiked = false;
    notifyListeners();
  }

  void getLiked(String id) async {
    isLoadingLiked = true;
    companiesInformationLiked.clear();
    companiesInformationLiked = [];
    final value = await LikesImplement().getLiked(
      UrlApi.likes,
      id,
    );
    for (var i = 0; i < value.data.length; i++) {
      if (value.data[i].match == false && value.data[i].jobPost.status == 0) {
        companiesInformationLiked.add(value.data[i]);
      }
    }
    isLoadingLiked = false;
    notifyListeners();
  }

  void getMatching(
    String id,
  ) async {
    isLoadingMatching = true;
    final value = await LikesImplement().getMatching(
      UrlApi.likes,
      id,
    );
    companiesInformationMatching = value.data;
    isLoadingMatching = false;
    notifyListeners();
  }
}
