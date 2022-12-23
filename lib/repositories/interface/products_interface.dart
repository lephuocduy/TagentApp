import 'package:it_job_mobile/models/request/product_exchange_request.dart';
import 'package:it_job_mobile/models/response/products_response.dart';

abstract class ProductsInterface {
  Future<ProductsResponse> searchProducts(String url, String query);
  Future<ProductsResponse> getProducts(String url);
  Future<ProductsResponse> getAllProduct(String url);
  Future<String> productExchange(String url, ProductExchangeRequest request, String accessToken);
}