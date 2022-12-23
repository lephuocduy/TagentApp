import 'dart:io';

class StoreImageRequest {
  StoreImageRequest({
    required this.id,
    required this.profileApplicantId,
    required this.image,
  });

  String id;
  String profileApplicantId;
  File image;
}
