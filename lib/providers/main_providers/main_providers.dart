import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../applicant_provider.dart';
import '../block_provider.dart';
import '../liked_provider.dart';
import '../post_provider.dart';
import '../product_provider.dart';
import '../sign_in_provider.dart';
import '../transaction_provider.dart';

class MainProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<SignInProvider>(
      create: (context) => SignInProvider(),
    ),
    ChangeNotifierProvider<ApplicantProvider>(
      create: (context) => ApplicantProvider(),
    ),
    ChangeNotifierProvider<PostProvider>(
      create: (context) => PostProvider(),
    ),
    ChangeNotifierProvider<BlockProvider>(
      create: (context) => BlockProvider(),
    ),
    ChangeNotifierProvider<LikedProvider>(
      create: (context) => LikedProvider(),
    ),
    ChangeNotifierProvider<ProductProvider>(
      create: (context) => ProductProvider(),
    ),
    ChangeNotifierProvider<TransactionProvider>(
      create: (context) => TransactionProvider(),
    ),
    ChangeNotifierProvider<DetailProfileProvider>(
      create: (context) => DetailProfileProvider(),
    ),
  ];
}
