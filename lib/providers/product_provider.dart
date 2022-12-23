import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/toast.dart';
import 'package:it_job_mobile/models/entity/product.dart';
import 'package:it_job_mobile/models/request/product_exchange_request.dart';
import 'package:provider/provider.dart';

import '../../repositories/implement/products_implement.dart';
import '../../constants/url_api.dart';
import '../shared/applicant_preferences.dart';
import '../views/profile/profile_setting/reward_exchange/reward_exchange_page.dart';
import 'applicant_provider.dart';

class ProductProvider extends ChangeNotifier {
  double _total = 0;
  double get total => _total;
  List<Product> products = [];
  int quantity = 0;
  int _quantityCard = 0;
  int get quantityCard => _quantityCard;

  void getProducts(BuildContext context) {
    ProductsImplement().getProducts(UrlApi.products).then((value) => {
          products = value.data,
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RewardExchangePage(
              products: products,
            );
          })),
        });
  }

  bool isLoad = false;

  Future<String> productExchange(
      BuildContext context, ProductExchangeRequest request) async {
    isLoad = true;
    notifyListeners();
    var result = "Fail";
    final providerApplicant =
        Provider.of<ApplicantProvider>(context, listen: false);
    await ProductsImplement()
        .productExchange(UrlApi.transactions, request, ApplicantPreferences.getToken(''),)
        .then((value) async => {
              if (value == "Successful")
                {
                  await providerApplicant.getWalletAsync(),
                  showToastSuccess("Đổi thưởng thành công"),
                  result = "Successful",
                },
            });
    isLoad = false;
    notifyListeners();
    return result;
  }
}
