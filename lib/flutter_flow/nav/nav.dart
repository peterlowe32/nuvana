import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '/auth/base_auth_user_provider.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';
GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier, {bool bypassLogin = false}) => GoRouter(
  initialLocation: bypassLogin ? '/home' : '/',
  debugLogDiagnostics: true,
  refreshListenable: appStateNotifier,
  navigatorKey: appNavigatorKey,
  errorBuilder: (context, state) =>
      appStateNotifier.loggedIn ? HomeCopyWidget() : LoginWidget(),
  routes: [
    FFRoute(name: '_initialize', path: '/', builder: (context, _) =>
      appStateNotifier.loggedIn ? HomeCopyWidget() : LoginWidget()),
    FFRoute(name: BibleIndexWidget.routeName, path: BibleIndexWidget.routePath, builder: (context, params) =>
      BibleIndexWidget(
        getBooksShortName: params.getParam('getBooksShortName', ParamType.String),
        getChaptersNumbers: params.getParam('getChaptersNumbers', ParamType.String),
        getVersesNumbers: params.getParam('getVersesNumbers', ParamType.String),
      )),
    FFRoute(name: VersionWidget.routeName, path: VersionWidget.routePath, builder: (context, _) => VersionWidget()),
    FFRoute(name: LoginWidget.routeName, path: LoginWidget.routePath, builder: (context, _) => LoginWidget()),
    FFRoute(name: HomeWidget.routeName, path: HomeWidget.routePath, builder: (context, params) =>
      HomeWidget(reflectivePrompt: params.getParam('reflectivePrompt', ParamType.String))),
    FFRoute(name: HomeCopyWidget.routeName, path: HomeCopyWidget.routePath, builder: (context, params) =>
      HomeCopyWidget(reflectivePrompt: params.getParam('reflectivePrompt', ParamType.String))),
    FFRoute(name: RealhomepageWidget.routeName, path: RealhomepageWidget.routePath, builder: (context, _) => RealhomepageWidget()),
    FFRoute(name: ActualhomepageWidget.routeName, path: ActualhomepageWidget.routePath, builder: (context, _) => ActualhomepageWidget()),
    FFRoute(name: MainuiWidget.routeName, path: MainuiWidget.routePath, builder: (context, _) => MainuiWidget()),
    FFRoute(name: JdfasdfWidget.routeName, path: JdfasdfWidget.routePath, builder: (context, _) => JdfasdfWidget()),
    FFRoute(name: NewkindasituationWidget.routeName, path: NewkindasituationWidget.routePath, builder: (context, _) => NewkindasituationWidget()),
    FFRoute(name: DdWidget.routeName, path: DdWidget.routePath, builder: (context, _) => DdWidget()),
  ].map((r) => r.toRoute(appStateNotifier)).toList(),
);

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
    name: name,
    path: path,
    redirect: (context, state) {
      if (appStateNotifier.shouldRedirect) {
        final redirectLocation = appStateNotifier.getRedirectLocation();
        appStateNotifier.clearRedirectLocation();
        return redirectLocation;
      }

      if (requireAuth && !appStateNotifier.loggedIn) {
        appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
        return '/login';
      }
      return null;
    },
    pageBuilder: (context, state) {
      fixStatusBarOniOS16AndBelow(context);
      final ffParams = FFParameters(state, asyncParams);
      final page = ffParams.hasFutures
          ? FutureBuilder(
              future: ffParams.completeFutures(),
              builder: (context, _) => builder(context, ffParams),
            )
          : builder(context, ffParams);
      final transitionInfo = state.extra != null &&
              state.extra is Map &&
              (state.extra as Map).containsKey(kTransitionInfoKey)
          ? (state.extra as Map)[kTransitionInfoKey] as TransitionInfo
          : TransitionInfo.appDefault();
      return transitionInfo.hasTransition
          ? CustomTransitionPage(
              key: state.pageKey,
              child: page,
              transitionDuration: transitionInfo.duration,
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(context, animation, secondaryAnimation, child),
            )
          : MaterialPage(key: state.pageKey, child: page);
    },
    routes: routes,
  );
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  Map<String, dynamic> futureParamValues = {};

  bool get isEmpty => state.uri.queryParameters.isEmpty;

  bool isAsyncParam(MapEntry<String, String> param) =>
      asyncParams.containsKey(param.key);

  bool get hasFutures => state.uri.queryParameters.entries.any(isAsyncParam);

  Future<bool> completeFutures() async {
    final futures = state.uri.queryParameters.entries.where(isAsyncParam).map(
      (param) async {
        final doc = await asyncParams[param.key]!(param.value).onError((_, __) => null);
        if (doc != null) {
          futureParamValues[param.key] = doc;
          return true;
        }
        return false;
      },
    );
    return (await Future.wait(futures)).every((e) => e);
  }

  T? getParam<T>(String name, ParamType type, {bool isList = false, List<String>? collectionNamePath}) {
    if (futureParamValues.containsKey(name)) {
      return futureParamValues[name] as T?;
    }
    final param = state.uri.queryParameters[name];
    if (param == null) return null;
    return deserializeParam<T>(param, type, isList, collectionNamePath: collectionNamePath);
  }
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => const TransitionInfo(hasTransition: false);
}
