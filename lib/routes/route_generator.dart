import 'package:flutter/material.dart';

import 'package:it_job_mobile/views/forgot_password/forgot_password_page.dart';

import '../../constants/route.dart';

import '../../views/sign_in/sign_in_page.dart';
import '../../views/pages/not_found_page.dart';
import '../../views/pages/onboarding_page.dart';
import '../../views/sign_up/sign_up_page.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutePath.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case RoutePath.signInRoute:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case RoutePath.forgotPasswordRouter:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case RoutePath.signUpRouter:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
