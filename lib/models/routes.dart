import 'package:hypertransit/screens/home_screen.dart';
import 'package:hypertransit/screens/login_screen.dart';
import 'package:hypertransit/screens/welcome_screen.dart';

const String welcomeRoute = "/welcome";
const String homeRoute = "/home";
const String loginRoute = "/login";
const String splashRoute = "/splash";

final routes = {
  welcomeRoute: (context) => welcomeScreen(),
  homeRoute: (context) => HomeScreen(),
  loginRoute: (context) => LoginScreen(),
  
};
