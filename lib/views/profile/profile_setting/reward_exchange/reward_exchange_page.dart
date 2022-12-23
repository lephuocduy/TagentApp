import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/models/entity/product.dart';
import 'package:it_job_mobile/repositories/implement/products_implement.dart';
import 'package:it_job_mobile/providers/product_provider.dart';
import 'package:it_job_mobile/constants/url_api.dart';
import 'package:it_job_mobile/widgets/product/card_product_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../providers/applicant_provider.dart';

class RewardExchangePage extends StatefulWidget {
  List<Product> products;
  RewardExchangePage({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<RewardExchangePage> createState() => _RewardExchangePageState();
}

class _RewardExchangePageState extends State<RewardExchangePage> {
  final controller = TextEditingController();
  String productName = '';
  bool isPasswordVisible = true;

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
  Widget build(BuildContext context) {
    final providerApplicant = Provider.of<ApplicantProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: AppColor.black,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Đổi Thưởng',
              style: AppTextStyles.h3Black,
            ),
            actions: [
              Padding(
                  padding:
                      const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () => {
                                setState(() =>
                                    isPasswordVisible = !isPasswordVisible)
                              },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColor.black,
                            size: 22,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 5,
                            left: 5,
                          ),
                          child: SizedBox(
                            width: 22.w,
                            height: 25,
                            child: Row(
                              mainAxisAlignment: isPasswordVisible
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.end,
                              children: [
                                if (isPasswordVisible) ...[
                                  Text(
                                    "*****",
                                    style: AppTextStyles.h3White,
                                    textAlign: TextAlign.center,
                                  ),
                                ] else ...[
                                  Text(
                                    providerApplicant.wallet
                                        .toString()
                                        .substring(
                                            0,
                                            providerApplicant.wallet
                                                    .toString()
                                                    .length -
                                                2),
                                    style: AppTextStyles.h4White,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Iconsax.buy_crypto,
                                    color: AppColor.white,
                                    size: 20,
                                  )
                                ]
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.search,
                  controller: controller,
                  onChanged: (String query) async => debounce(() async {
                    final products = await ProductsImplement()
                        .searchProducts(UrlApi.products, query);
                    try {
                      setState(() {
                        productName = query;
                        widget.products = products.data;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    } catch (e) {
                      //
                    }
                  }),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 15),
                    prefixIcon: Icon(
                      Iconsax.search_normal,
                      color: productName.isEmpty
                          ? AppColor.darkGrey
                          : AppColor.black,
                      size: 20,
                    ),
                    suffixIcon: productName.isNotEmpty
                        ? GestureDetector(
                            child: Icon(
                              Icons.close,
                              color: AppColor.black,
                            ),
                            onTap: () async {
                              productName = '';
                              controller.text = '';
                              controller.clear();
                              final products = await ProductsImplement()
                                  .searchProducts(UrlApi.products, '');
                              try {
                                setState(() {
                                  widget.products = products.data;
                                });
                              } catch (e) {
                                //
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          )
                        : null,
                    hintText: "Tìm sản phẩm",
                    filled: true,
                    fillColor: AppColor.white,
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                SizedBox(
                  height: 85.h,
                  child: _buildList(context),
                ),
              ],
            ),
          ),
        ),
        if (productProvider.isLoad)
          Center(
              child: SpinKitCircle(
            size: 80,
            color: AppColor.black,
          ))
      ],
    );
  }

  Widget _buildList(context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
          width: 100.w - 30.0,
          height: 85.h,
          child: GridView.builder(
            primary: false,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              return CardProductWidget(product: widget.products[index]);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}
