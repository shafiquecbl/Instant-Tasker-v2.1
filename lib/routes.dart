import 'package:flutter/widgets.dart';
import 'package:instant_tasker/models/verify_email.dart';
import 'package:instant_tasker/screens/Home_Screen/home_screen.dart';
import 'package:instant_tasker/screens/complete_profile/complete_profile_screen.dart';
import 'package:instant_tasker/screens/forgot_password/forgot_password_screen.dart';
import 'package:instant_tasker/screens/sign_in/sign_in_screen.dart';
import 'package:instant_tasker/screens/splash/splash_screen.dart';
import 'package:instant_tasker/screens/Home_Screen/pages/More/Verification/verify_cnic.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  MainScreen.routeName: (context) => MainScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  VerifyEmail.routeName: (context) => VerifyEmail(),
  VerifyCNIC.routeName: (context) => VerifyCNIC(),
};
