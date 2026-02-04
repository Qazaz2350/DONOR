
import 'package:flutter/material.dart';

class MyNavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Default slide direction can be set here
  static final SlideDirection defaultSlideDirection = SlideDirection.left;

  // Push a new screen with a custom transition (default is SlideTransition)
  static Future<void> push(Widget page) async {
    return navigatorKey.currentState?.push(
      SlideTransitionPage(page: page, slideDirection: defaultSlideDirection),
    ).then((_) => null); // Ignore the result and return Future<void>
  }

  // Push a new screen and replace the current one (with default transition)
  static Future<void> pushReplacement(Widget page) async {
    return navigatorKey.currentState?.pushReplacement(
      SlideTransitionPage(page: page, slideDirection: defaultSlideDirection),
    ).then((_) => null); // Ignore the result and return Future<void>
  }

  // Push a new screen with named route and replace the current one
  static Future<void> pushReplacementNamed(String routeName) async {
    return navigatorKey.currentState?.pushReplacementNamed(routeName).then((_) => null);
  }

  // Push a named route
  static Future<void> pushNamed(String routeName) async {
    return navigatorKey.currentState?.pushNamed(routeName).then((_) => null);
  }

  // Pop the current screen
  static void pop() {
    return navigatorKey.currentState?.pop();
  }

  // Pop until a specific route name
  static void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  // Pop until the root route (clear stack)
  static void popUntilRoot() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  // Push and remove all previous screens (push new screen, clear stack)
  static Future<void> pushAndRemoveAll(Widget page) async {
    return navigatorKey.currentState?.pushAndRemoveUntil(
      SlideTransitionPage(page: page, slideDirection: defaultSlideDirection),
      (Route<dynamic> route) => false, // Remove all previous routes
    ).then((_) => null); // Ignore the result and return Future<void>
  }

  // Push and remove until a specific route (pop to that route, push new screen)
  static Future<void> pushAndRemoveUntil(Widget page, String routeName) async {
    return navigatorKey.currentState?.pushAndRemoveUntil(
      SlideTransitionPage(page: page, slideDirection: defaultSlideDirection),
      ModalRoute.withName(routeName),
    ).then((_) => null); // Ignore the result and return Future<void>
  }

  // Push a route with a custom transition (use provided direction)
  static Future<void> navigateToWithCustomTransition(
      Widget page, SlideDirection direction) async {
    return navigatorKey.currentState?.push(
      SlideTransitionPage(page: page, slideDirection: direction),
    ).then((_) => null); // Ignore the result and return Future<void>
  }

  // Push replacement with custom transition
  static Future<void> pushReplacementWithCustomTransition(
      Widget page, SlideDirection direction) async {
    return navigatorKey.currentState?.pushReplacement(
      SlideTransitionPage(page: page, slideDirection: direction),
    ).then((_) => null); // Ignore the result and return Future<void>
  }

  // Navigate with custom transition using named routes
  static Future<void> navigateToNamedWithCustomTransition(
      String routeName, SlideDirection direction) async {
    return navigatorKey.currentState?.pushReplacementNamed(routeName).then((_) => null);
  }

  // Pop until specific route name
  static void popUntilNamed(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }
}



class SlideTransitionPage extends PageRouteBuilder {
  final Widget page;
  final bool applySlideTransition;
  final SlideDirection slideDirection;

  // Define a shorter default animation duration
  // static const Duration defaultAnimationDuration = Duration(milliseconds: 200);

  SlideTransitionPage({
    required this.page,
    this.applySlideTransition = true,
    this.slideDirection = SlideDirection.left,
    // Duration transitionDuration =
    //     defaultAnimationDuration, // Set default duration
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            if (applySlideTransition) {
              Offset beginOffset;
              Offset endOffset;

              switch (slideDirection) {
                case SlideDirection.left:
                  beginOffset = const Offset(1.0, 0.0);
                  endOffset = Offset.zero;
                  break;
                case SlideDirection.right:
                  beginOffset = const Offset(-1.0, 0.0);
                  endOffset = Offset.zero;
                  break;
                case SlideDirection.top:
                  beginOffset = const Offset(0.0, 1.0);
                  endOffset = Offset.zero;
                  break;
                case SlideDirection.bottom:
                  beginOffset = const Offset(0.0, -1.0);
                  endOffset = Offset.zero;
                  break;
              }

              return SlideTransition(
                position: Tween<Offset>(
                  begin: beginOffset,
                  end: endOffset,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut, // Use a curve for smoother animation
                  reverseCurve: Curves
                      .easeIn, // Use a curve for smoother reverse animation
                )),
                child: child,
              );
            } else {
              return child;
            }
          },
          // transitionDuration:
          //     transitionDuration, // Use the provided or default duration
        );
}

enum SlideDirection { left, right, top, bottom }
