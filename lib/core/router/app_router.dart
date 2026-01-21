/// App Router
/// GoRouter configuration for navigation
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/screens/attendance_history_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/leave/screens/leave_form_screen.dart';
import '../../features/leave/screens/leave_list_screen.dart';
import '../../features/overtime/screens/overtime_form_screen.dart';
import '../../features/overtime/screens/overtime_list_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../widgets/main_scaffold.dart';

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/';

      // Allow splash screen to handle initial redirect
      if (isSplash) return null;

      // Redirect to login if not authenticated
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // Redirect to home if authenticated and trying to access login
      if (isAuthenticated && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main app with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/history',
            name: 'history',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AttendanceHistoryScreen()),
          ),
          GoRoute(
            path: '/leave',
            name: 'leave',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LeaveListScreen()),
            routes: [
              GoRoute(
                path: 'new',
                name: 'leave-new',
                builder: (context, state) => const LeaveFormScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // Overtime routes (accessible from profile)
      GoRoute(
        path: '/overtime',
        name: 'overtime',
        builder: (context, state) => const OvertimeListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            name: 'overtime-new',
            builder: (context, state) => const OvertimeFormScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Halaman tidak ditemukan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
  );
});
