import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:it_job_mobile/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_image_path.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../providers/applicant_provider.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isPasswordVisible = true;

  @override
  void initState() {
    final providerTransaction =
        Provider.of<TransactionProvider>(context, listen: false);
    super.initState();
    providerTransaction.getTransaction();
  }

  @override
  Widget build(BuildContext context) {
    final providerApplicant = Provider.of<ApplicantProvider>(context);
    final providerTransaction =
        Provider.of<TransactionProvider>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: AppColor.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Lịch Sử Giao Dịch',
            style: AppTextStyles.h3Black,
          ),
          actions: [],
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () async => {
                              if (isPasswordVisible)
                                {
                                  await providerApplicant.getWalletAsync(),
                                },
                              setState(
                                  () => isPasswordVisible = !isPasswordVisible)
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
                                  providerApplicant.wallet.toString().substring(
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
            providerTransaction.isLoad
                ? SizedBox(
                    height: 88.h,
                    child: ListView.builder(
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(children: [
                                SizedBox(
                                  width: 5.w,
                                ),
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.04),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40.w,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.04),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 30.w,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.04),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 15.w,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.04),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 20.w,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.04),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : providerTransaction.transactions.isNotEmpty
                    ? SizedBox(
                        height: 88.h,
                        child: ListView.builder(
                          itemCount: providerTransaction.transactions.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(children: [
                                  Expanded(
                                    flex: 1,
                                    child: Icon(
                                      Iconsax.card_coin,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (providerTransaction
                                                  .transactions[index].type ==
                                              "Share job post") ...[
                                            Text("Chia sẻ bài tuyển dụng"),
                                            Text("đến " +
                                                providerTransaction
                                                    .transactions[index]
                                                    .description),
                                          ],
                                          if (providerTransaction
                                                  .transactions[index].type ==
                                              "Like job post") ...[
                                            Text(providerTransaction
                                                .transactions[index]
                                                .description),
                                            Text("đã thích bài tuyển dụng"),
                                          ],
                                          if (providerTransaction
                                                  .transactions[index].type ==
                                              "Match") ...[
                                            Text(providerTransaction
                                                .transactions[index]
                                                .description),
                                            Text("đã được kết nối với công ty"),
                                          ],
                                          if (providerTransaction
                                                  .transactions[index].type ==
                                              "Reward exchange") ...[
                                            Text("Đổi sản phẩm"),
                                            Text(
                                              providerTransaction
                                                  .transactions[index]
                                                  .description,
                                            ),
                                          ]
                                        ],
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  providerTransaction
                                                      .transactions[index]
                                                      .total,
                                                  style: providerTransaction
                                                              .transactions[
                                                                  index]
                                                              .total
                                                              .indexOf("-") ==
                                                          -1
                                                      ? AppTextStyles.h3Success
                                                      : AppTextStyles.h3Red),
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
                                          Text(
                                            DateFormat('H:m - dd/MM/yyyy')
                                                .format(providerTransaction
                                                    .transactions[index]
                                                    .createDate),
                                            style: AppTextStyles.h5Black,
                                          ),
                                        ],
                                      ))
                                ]),
                              ),
                            );
                          },
                        ),
                      )
                    : Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            SvgPicture.asset(
                              ImagePath.jobPostEmpty,
                              fit: BoxFit.cover,
                              width: 50.w,
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              "Không có giao dịch nào",
                              style: AppTextStyles.h4Black,
                            )
                          ],
                        ),
                      ),
          ],
        ));
  }
}
