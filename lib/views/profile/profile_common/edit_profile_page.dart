import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/models/entity/applicant.dart';
import 'package:it_job_mobile/widgets/input/edit_field.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/url_api.dart';
import '../../../models/response/suggest_search_response.dart';
import '../../../providers/applicant_provider.dart';
import '../../../providers/detail_profile_provider.dart';
import '../../../repositories/implement/applicants_implement.dart';
import '../../../repositories/implement/suggest_search_implement.dart';
import '../../../shared/applicant_preferences.dart';
import '../../../widgets/dialog/dialog_date_picker.dart';
import '../../../widgets/input/textfield_widget.dart';
import '../../../widgets/profile/profile_widget.dart';
import '../../bottom_tab_bar/bottom_tab_bar.dart';
import 'create_profile_address_page.dart';

class EditProfilePage extends StatefulWidget {
  final Applicant applicant;
  bool update;
  EditProfilePage({
    Key? key,
    required this.applicant,
    this.update = true,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late Applicant applicant;
  DateTime dateTime = DateTime.now();
  String dob = '';
  int sexIndex = 0;
  int sex = 0;
  String address = '';
  File newAvatar = File('');
  String textValidationError = '';
  List<SuggestSearchResponse> addresses = [];
  bool deleteAvatar = false;
  bool checkName = false;
  bool checkDob = false;
  bool checkGender = false;
  bool checkAddress = false;

  @override
  void initState() {
    super.initState();
    applicant = ApplicantPreferences.getUser(widget.applicant);
    SuggestSearchImplement()
        .suggestSearch(UrlApi.provinces, "")
        .then((value) => {
              setState(() {
                addresses = value;
              })
            });
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);

      final directory = await getApplicationDocumentsDirectory();
      final name = basename(img!.path);
      final imageFile = File('${directory.path}/$name');
      final newImage = await File(img.path).copy(imageFile.path);
      setState(() {
        newAvatar = newImage;
        applicant = applicant.copy(
          avatar: newImage.path,
        );
      });
    } catch (e) {
      log("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: widget.update
              ? AppBar(
                  leading: BackButton(
                    color: AppColor.black,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18, right: 20),
                      child: InkWell(
                        onTap: () async {
                          final providerApplicant =
                              Provider.of<ApplicantProvider>(context,
                                  listen: false);
                          if (applicant.name.isEmpty &&
                              applicant.email.isEmpty) {
                            _showValidationDialog(
                                context, "Tên và E-mail không được trống");
                            return;
                          } else if (applicant.name.isEmpty &&
                              !RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')
                                  .hasMatch(applicant.email)) {
                            _showValidationDialog(context,
                                "Tên không được trống và E-mail không đúng định dạng");
                            return;
                          } else if (!RegExp(
                                  r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')
                              .hasMatch(applicant.email)) {
                            _showValidationDialog(
                                context, "E-mail không đúng định dạng");
                            return;
                          } else if (applicant.name.isEmpty ||
                              applicant.name.length > 20) {
                            _showValidationDialog(context,
                                "Tên không được trống và không được quá 20 kí tự");
                            return;
                          } else if (applicant.email.isEmpty ||
                              applicant.email.length > 25) {
                            _showValidationDialog(context,
                                "E-mail không được trống và không được quá 25 kí tự");
                            return;
                          }
                          ApplicantPreferences.setUser(applicant);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BottomTabBar(
                              currentIndex: 3,
                            );
                          }));
                          var value = await ApplicantsImplement()
                              .putApplicantById(
                                  UrlApi.applicant,
                                  Jwt.parseJwt(ApplicantPreferences.getToken(
                                          ''))['Id']
                                      .toString(),
                                  applicant,
                                  newAvatar,
                                  ApplicantPreferences.getToken(''));
                          setState(() {
                            providerApplicant.applicant = value.data!;
                          });
                          if (deleteAvatar && applicant.avatar.isEmpty) {
                            ApplicantsImplement().deleteAvatar(
                              UrlApi.file,
                              value.data!.id,
                              ApplicantPreferences.getToken(''),
                            );
                          }
                        },
                        child: Text(
                          'Xong',
                          style: AppTextStyles.h3Black,
                        ),
                      ),
                    ),
                  ],
                )
              : null,
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              if (widget.update == false)
                Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Bắt đầu tạo hồ sơ của bạn",
                      style: AppTextStyles.h2Black,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ProfileWidget(
                imagePath: applicant.avatar,
                isEdit: true,
                onClicked: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet(context)));
                },
              ),
              Divider(
                color: AppColor.grey,
                height: 5.h,
              ),
              TextFieldWidget(
                keyboardType: TextInputType.multiline,
                icon: Iconsax.user,
                label: 'Tên',
                text: applicant.name,
                onChanged: (name) => {
                  applicant = applicant.copy(name: name),
                  setState(() {
                    applicant.name.isNotEmpty
                        ? checkName = true
                        : checkName = false;
                  })
                },
              ),
              SizedBox(
                height: 3.h,
              ),
              if (widget.update) ...[
                TextFieldWidget(
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                  label: 'E-mail',
                  text: applicant.email,
                  onChanged: (email) =>
                      applicant = applicant.copy(email: email),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Iconsax.call,
                              size: 25,
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            Text(
                              'Điện thoại',
                              style: AppTextStyles.h3Black,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              applicant.phone,
                              style: AppTextStyles.h3Black,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Icon(
                              Iconsax.tick_circle,
                              color: AppColor.blue,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColor.grey,
                      height: 2.h,
                    ),
                    SizedBox(
                      height: 3.h,
                    )
                  ],
                ),
              ],
              EditField(
                onClicked: () => DialogDatePicker.showSheet(
                  context,
                  child: buildDatePicker(),
                  onClicked: () {
                    setState(() {
                      dob = DateFormat('dd/MM/yyyy').format(applicant.dob);
                      applicant = applicant.copy(dob: dateTime);
                      checkDob = true;
                    });
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                icon: Iconsax.calendar_1,
                hintText: 'Ngày sinh',
                text: DateFormat('dd/MM/yyyy')
                        .format(applicant.dob)
                        .contains("01/01/1969")
                    ? ""
                    : DateFormat('dd/MM/yyyy').format(applicant.dob),
              ),
              EditField(
                  onClicked: () => DialogDatePicker.showSheet(
                        context,
                        child: buildSexPicker(),
                        onClicked: () {
                          setState(() {
                            sex = sexIndex;
                            applicant = applicant.copy(gender: sexIndex);
                            checkGender = true;
                          });
                          Navigator.pop(context);
                        },
                      ),
                  icon: Iconsax.man,
                  hintText: 'Giới tính',
                  text: ((() {
                    if (applicant.gender == 0) {
                      return 'Nữ';
                    } else if (applicant.gender == 1) {
                      return 'Nam';
                    } else if (applicant.gender == 2) {
                      return 'Khác';
                    }
                    return '';
                  })())),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      String add = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CreateProfileAddressPage(
                              query: applicant.address,
                              addresses: addresses,
                            );
                          })) ??
                          applicant.address;
                      setState(() {
                        address = add;
                        applicant = applicant.copy(address: address);
                        address.isNotEmpty
                            ? checkAddress = true
                            : checkAddress = false;
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Iconsax.location,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 1.w,
                                ),
                                Text(
                                  'Địa chỉ',
                                  style: AppTextStyles.h3Black,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 50.w,
                                  child: Text(
                                    applicant.address,
                                    style: AppTextStyles.h3Black,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColor.grey,
                          height: 2.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  )
                ],
              ),
              if (widget.update == false)
                Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: 80.w,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed: (checkName &&
                                checkDob &&
                                checkGender &&
                                checkAddress)
                            ? () async {
                                final providerApplicant =
                                    Provider.of<ApplicantProvider>(context,
                                        listen: false);
                                final detailProfileProvider =
                                    Provider.of<DetailProfileProvider>(context,
                                        listen: false);
                                detailProfileProvider.newProfileApplicant(
                                    context, false);
                                await ApplicantPreferences.setUser(applicant);
                                await ApplicantsImplement()
                                    .putApplicantById(
                                      UrlApi.applicant,
                                      Jwt.parseJwt(
                                              ApplicantPreferences.getToken(
                                                  ''))['Id']
                                          .toString(),
                                      applicant,
                                      newAvatar,
                                      ApplicantPreferences.getToken(''),
                                    )
                                    .then((value) async => {
                                          setState(() {
                                            providerApplicant.applicant =
                                                value.data!;
                                          }),
                                        });
                              }
                            : null,
                        child: Text(
                          "Tiếp Tục",
                          style: AppTextStyles.h3White,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.black,
                          onSurface: AppColor.black,
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      );

  Widget bottomSheet(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            "Ảnh đại diện",
            style: TextStyle(fontSize: 20.0),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Chụp ảnh mới'),
            onTap: () {
              pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Chọn ảnh từ thiết bị'),
            onTap: () {
              pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Xóa ảnh'),
            onTap: () {
              setState(() {
                applicant = applicant.copy(avatar: '');
                deleteAvatar = true;
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildDatePicker() => SizedBox(
        height: 30.h,
        child: CupertinoDatePicker(
          dateOrder: DatePickerDateOrder.dmy,
          minimumYear: 1969,
          maximumYear: DateTime.now().year,
          maximumDate: DateTime.now(),
          initialDateTime: applicant.dob,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );

  List<Widget> sexList = [
    const Text('Nữ'),
    const Text('Nam'),
    const Text('Khác'),
  ];

  Widget buildSexPicker() => SizedBox(
        height: 20.h,
        child: CupertinoPicker(
          children: sexList,
          onSelectedItemChanged: (value) {
            setState(() {
              sexIndex = value;
            });
          },
          scrollController: FixedExtentScrollController(
            initialItem: applicant.gender,
          ),
          itemExtent: 25,
          diameterRatio: 1,
          useMagnifier: true,
          magnification: 1.3,
        ),
      );

  _showValidationDialog(context, String textValidationError) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.SCALE,
      title: "Thông tin chưa đúng yêu cầu",
      desc: textValidationError,
      btnOkText: "Chỉnh sửa",
      btnOkOnPress: () {},
    ).show();
  }
}
