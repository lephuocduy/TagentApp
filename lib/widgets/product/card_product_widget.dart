import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/constants/toast.dart';
import 'package:it_job_mobile/models/entity/product.dart';
import 'package:it_job_mobile/models/request/product_exchange_request.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../shared/applicant_preferences.dart';
import '../../providers/product_provider.dart';

class CardProductWidget extends StatefulWidget {
  final Product product;
  const CardProductWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<CardProductWidget> createState() => _CardProductWidgetState();
}

class _CardProductWidgetState extends State<CardProductWidget> {
  int quantity = 0;
  FToast? fToast;

  @override
  void initState() {
    super.initState();
    quantity = widget.product.quantity;
    fToast = FToast();
    fToast!.init(context);
  }

  _showToast(String price) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("- $price", style: AppTextStyles.h4White),
          const SizedBox(
            width: 5,
          ),
          Icon(
            Iconsax.buy_crypto,
            color: AppColor.white,
            size: 15.0,
          ),
        ],
      ),
    );

    fToast!.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 45.0,
            right: 34.0,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3.0,
                blurRadius: 5.0,
              )
            ],
            color: AppColor.white),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Sản phẩm còn: ' + quantity.toString(),
                  style: AppTextStyles.h6Black,
                )
              ],
            ),
          ),
          Container(
            height: 75.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: widget.product.image.contains('https://')
                        ? CachedNetworkImageProvider(widget.product.image)
                        : const AssetImage(ImagePath.defaultProduct)
                            as ImageProvider,
                    fit: BoxFit.contain)),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  widget.product.price
                      .toString()
                      .substring(0, widget.product.price.toString().length - 2),
                  style: AppTextStyles.h4Black),
              const SizedBox(
                width: 5,
              ),
              Icon(
                Iconsax.buy_crypto,
                color: AppColor.black,
                size: 15.0,
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          SizedBox(
            height: 30,
            child: Text(
              widget.product.name.length < 48
                  ? widget.product.name
                  : widget.product.name.substring(0, 48) + "...",
              style: AppTextStyles.h5Black,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              color: Color(0xFFEBEBEB),
              height: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Iconsax.buy_crypto,
                  color: AppColor.black,
                  size: 25.0,
                ),
                InkWell(
                  onTap: widget.product.quantity != 0
                      ? () {
                          _showConfirmDialog(
                            context,
                            widget.product,
                          );
                        }
                      : () {
                          showToastFail("Sản phẩm này hiện tại đang hết hàng");
                        },
                  child: Text(
                    'Đổi thưởng',
                    style: AppTextStyles.h4Black,
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  _showConfirmDialog(context, Product product) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: "Xác Nhận",
      desc:
          "Bạn có đồng ý đổi ${product.price.toString().substring(0, product.price.toString().length - 2)} Tagent Coin để lấy ${product.name} không?",
      btnOkText: "Đồng ý",
      btnCancelText: "Hủy",
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        var value = await productProvider.productExchange(
            context,
            ProductExchangeRequest(
              createBy: Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id']
                  .toString(),
              productId: product.id,
              quantity: 1,
            ));
        if (value == "Successful") {
          _showToast(product.price
              .toString()
              .substring(0, product.price.toString().length - 2));
          setState(() {
            quantity--;
          });
        }
      },
    ).show();
  }
}
