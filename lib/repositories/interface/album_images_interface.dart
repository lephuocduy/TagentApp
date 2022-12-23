import 'dart:io';

import 'package:it_job_mobile/models/response/album_images_response.dart';
import 'package:it_job_mobile/models/response/store_image_response.dart';

abstract class AlbumImagesInterface {
  Future<AlbumImagesResponse> getAlbumImagesById(String url, String getBy, String id);
  Future<List<StoreImageResponse>> postAlbumImages(String url, String id, File image, String accessToken);
  Future<String> deleteAlbumImageById(String url, String id, String accessToken);
  Future<AlbumImagesResponse> getAlbumImagesByJobPostId(String url, String id);
  Future<String> enableToEarnImageById(String url, String id, File image, String accessToken);
}
