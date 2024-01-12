import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla

      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) =>  ProductScreen(productId: state.params['id'] ?? 'no-id'),
      ),
      GoRoute(
        path: '/product-show/:id',
        builder: (context, state) =>  ProductShowScreen(productId: state.params['id'] ?? 'no-id'),
      ),
    ],
    redirect: (context, state) {
      final isGointTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if (isGointTo == '/splash' && authStatus == AuthStatus.checking)return null;
      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGointTo == '/login' || isGointTo == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGointTo == '/login' ||
            isGointTo == '/register' ||
            isGointTo == '/splash') return '/';
      }

      return null;
    },
  );
});
