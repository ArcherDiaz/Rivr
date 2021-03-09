import 'package:firebase_core/firebase_core.dart';
import 'package:rivr/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:rivr/Screens/RoomScreen.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;

void main() {
  Firebase.initializeApp();
  runApp(AppWrapper(),);
}

//TODO: rivr/home
//TODO: rivr/live?code=${roomCode}
/*
Features:
	Make Invite Only Rooms
		Escape from the open world to a small paradise with your friend and family in a private Rivr room
	Connect across all Platforms
		From desktop for connecting to smartphones for connectig on the go, Rivr is available to you
	Join Public Rooms
		Meet and make new friends online through public video/audio chat rooms
	Unlimited Chat
		Chat unlimitedly with the benefit of our Auto-Traceless Tecchnology


App Capabilites
	Higly responsive
	High Security
	Seamless connections
	Minimalistic Design

*/


class AppWrapper extends StatelessWidget {

  final AppRouterDelegate _routerDelegate = AppRouterDelegate();
  final AppRouteInformationParser _routeInformationParser = AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Rivr | Online Live Streaming",
      color: colors.bg,
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }

}

class AppRouterDelegate extends RouterDelegate<RoutePathClass> with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePathClass> {

  final GlobalKey<NavigatorState> navigatorKey;
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  List<RoutePathClass> _routeHistoryList = [RoutePathClass.home(),]; ///this is the history of the user's page navigation, and also controls which page they are currently on
  RoutePathClass get currentConfiguration {
    print("3: configure - ${_routeHistoryList.last.title}");
    return _routeHistoryList.last;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if(_routeHistoryList.last.isHomePage)
          MaterialPage(
            child: HomeScreen(
              key: ValueKey("HomeScreen"),
              route: _routeHistoryList.last,
              updatePage: _changePageRoute,
            ),
          ),

        if(_routeHistoryList.last.isLivePage)
          MaterialPage(
            child: RoomScreen(

            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _routeHistoryList.removeLast();
        notifyListeners();
        return true;
      },
    );
  }

  void _changePageRoute(RoutePathClass route){
    if(_routeHistoryList.any((element) => element.title == route.title)) {
      _routeHistoryList.removeWhere((element) => element.title == route.title);
    }
    _routeHistoryList.add(route,);
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(RoutePathClass path) async {
    print("2: Set New Route - ${path.title}");
    _routeHistoryList.add(path);
    notifyListeners();
    return;
  }

}
class AppRouteInformationParser extends RouteInformationParser<RoutePathClass> {

  @override
  Future<RoutePathClass> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    String _fullPath = uri.path.toLowerCase() + uri.query.toLowerCase();
    List<String> segments = uri.pathSegments;
    Map<String, dynamic> _extra = Map();
    _extra.addAll(uri.queryParameters);

    print("1: URI Path: $_fullPath");

    if(segments.length == 0) {
      return RoutePathClass.home();
    }

    if(_fullPath.contains("home")) {
      return RoutePathClass.home();
    }
    if(_fullPath.contains("live") || _fullPath.contains("code")) {
      return RoutePathClass.live(_extra);
    }

    return RoutePathClass.home();
  }

  @override
  RouteInformation restoreRouteInformation(RoutePathClass path) {
    print("4: restore Route - ${path.title}");
    if(path.isHomePage) {
      return RouteInformation(location: '/home');
    }
    if(path.isLivePage) {
      if(path.extra == null || path.extra.isEmpty){
        return RouteInformation(location: '/live');
      }
      String _parameters = "";
      path.extra.forEach((key, value) {
        _parameters = "$_parameters?$key=${value.toString()}";
      });
      return RouteInformation(location: '/live$_parameters');
    }

    return null;
  }

}



class RoutePathClass {

  final IconData icon;
  final String title;
  String id;
  Map<String, dynamic> extra;
  final List<String> subPages;

  RoutePathClass.home() : icon = Icons.home_outlined, title = "Home", id = null, extra = null, subPages = null;
  RoutePathClass.live(this.extra,) : icon = Icons.live_tv_outlined, title = "Live", id = null, subPages = null;

  bool get isHomePage => icon == Icons.home_outlined;
  bool get isLivePage => icon == Icons.live_tv_outlined;

}
