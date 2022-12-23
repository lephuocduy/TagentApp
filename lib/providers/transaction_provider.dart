import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/profile_applicant.dart';
import 'package:it_job_mobile/models/entity/transaction.dart';
import 'package:it_job_mobile/models/response/profile_applicants_response.dart';
import 'package:it_job_mobile/models/response/transaction_job_posts_response.dart';
import 'package:it_job_mobile/models/response/transaction_reward_exchanges_response.dart';
import 'package:it_job_mobile/repositories/implement/applicants_implement.dart';
import 'package:it_job_mobile/repositories/implement/profile_applicants_implement.dart';
import 'package:it_job_mobile/repositories/implement/transactions_implement.dart';
import 'package:it_job_mobile/constants/url_api.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../models/entity/applicant.dart';
import '../../shared/applicant_preferences.dart';
import '../models/response/applicants_response.dart';

class TransactionProvider extends ChangeNotifier {
  List<Applicant> applicants = [];
  List<ProfileApplicant> profileApplicants = [];
  List<Transaction> transactions = [];
  bool isLoad = false;

  Future<void> getTransaction() async {
    isLoad = true;
    transactions.clear;
    transactions = [];
    int createBy = 1;

    var value = await Future.wait([
      ApplicantsImplement().getListApplicant(UrlApi.applicant),
      ProfileApplicantsImplement().getProfileApplicantsById(
          UrlApi.profileApplicants,
          Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString()),
    ]);
    applicants = (value[0] as ApplicantsResponse).data;
    profileApplicants = (value[1] as ProfileApplicantsResponse).data;

    for (var i = 0; i < profileApplicants.length; i++) {
      createBy = i + 1;
      var liked = await TransactionsImplement().getTransactionJobPosts(
          UrlApi.transactionJobPosts, profileApplicants[i].id);
      for (var j = 0; j < liked.data.length; j++) {
        transactions.add(Transaction(
          id: liked.data[j].id,
          type: liked.data[j].typeOfTransaction,
          description: "Hồ sơ $createBy",
          total: "+ " +
              liked.data[j].total
                  .toString()
                  .substring(0, liked.data[j].total.toString().length - 2),
          createDate: liked.data[j].createDate.toLocal(),
        ));
      }
    }
    var valueStore = await Future.wait([
      TransactionsImplement().getTransactionJobPosts(UrlApi.transactionJobPosts,
          Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString()),
      TransactionsImplement().getTransactionRewardExchanges(UrlApi.transactions,
          Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString())
    ]);
    final share = (valueStore[0] as TransactionJobPostsResponse).data;
    final exchange = (valueStore[1] as TransactionRewardExchangesResponse).data;
    for (var i = 0; i < share.length; i++) {
      for (var j = 0; j < applicants.length; j++) {
        if (share[i].receiver == applicants[j].id) {
          transactions.add(Transaction(
            id: share[i].id,
            type: share[i].typeOfTransaction,
            description: applicants[j].name,
            total: "+ " +
                share[i]
                    .total
                    .toString()
                    .substring(0, share[i].total.toString().length - 2),
            createDate: share[i].createDate.toLocal(),
          ));
        }
      }
    }
    for (var i = 0; i < exchange.length; i++) {
      transactions.add(Transaction(
        id: exchange[i].id,
        type: exchange[i].typeOfTransaction,
        description: exchange[i].product.name,
        total: "- " +
            exchange[i]
                .total
                .toString()
                .substring(0, exchange[i].total.toString().length - 2),
        createDate: exchange[i].createDate.toLocal(),
      ));
    }

    transactions.sort((a, b) {
      return b.createDate.compareTo(a.createDate);
    });
    notifyListeners();
    isLoad = false;
    notifyListeners();
  }
}
