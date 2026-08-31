import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myhealth_ai/features/admin/admin_shell.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/auth/login_screen.dart';
import 'package:myhealth_ai/features/auth/register_screen.dart';
import 'package:myhealth_ai/features/patient_home/patient_shell.dart';
import 'package:myhealth_ai/features/staff/patients/patient_chart_screen.dart';
import 'package:myhealth_ai/features/staff/staff_shell.dart';

/// Route path constants (flutter-dart-code-review §11).
abstract final class AppRoutes {
  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Patient
  static const String patientHome = '/patient';
  static const String timeline = '/patient/timeline';
  static const String records = '/patient/records';
  static const String recordDetail = '/patient/records/:id';
  static const String vitals = '/patient/vitals';
  static const String medications = '/patient/medications';
  static const String booking = '/patient/booking';
  static const String appointments = '/patient/appointments';
  static const String aiSummary = '/patient/ai-summary';
  static const String patientProfile = '/patient/profile';
  static const String patientSettings = '/patient/settings';

  // Staff
  static const String staffDashboard = '/staff';
  static const String staffPatientSearch = '/staff/patients';
  static const String staffPatientChart = '/staff/patients/:id';
  static const String staffTasks = '/staff/tasks';
  static const String staffSchedule = '/staff/schedule';
  static const String staffAnalytics = '/staff/analytics';

  // Admin
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminDepartments = '/admin/departments';
  static const String adminAiSettings = '/admin/ai-settings';
  static const String adminAuditLog = '/admin/audit-log';
  static const String adminAnalytics = '/admin/analytics';
}

/// Riverpod provider for GoRouter with dynamic Auth & Role Guard redirects.
final routerProvider = Provider<GoRouter>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (currentUser == null) {
        return isAuthRoute ? null : AppRoutes.login;
      }

      // Role-gated redirection
      final role = currentUser.role.name;
      final loc = state.matchedLocation;

      if (isAuthRoute) {
        if (role == 'patient') return AppRoutes.patientHome;
        if (role == 'staff') return AppRoutes.staffDashboard;
        if (role == 'admin') return AppRoutes.adminDashboard;
      }

      if (role == 'patient' && !loc.startsWith('/patient')) {
        return AppRoutes.patientHome;
      }
      if (role == 'staff' && !loc.startsWith('/staff')) {
        return AppRoutes.staffDashboard;
      }
      if (role == 'admin' && !loc.startsWith('/admin')) {
        return AppRoutes.adminDashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Patient Shell
      GoRoute(
        path: AppRoutes.patientHome,
        name: 'patientHome',
        builder: (context, state) => const PatientShell(),
      ),

      // Staff Shell & Subroutes
      GoRoute(
        path: AppRoutes.staffDashboard,
        name: 'staffDashboard',
        builder: (context, state) => const StaffShell(),
      ),
      GoRoute(
        path: AppRoutes.staffPatientChart,
        name: 'staffPatientChart',
        builder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '1';
          final patientId = int.tryParse(idStr) ?? 1;
          return PatientChartScreen(patientId: patientId);
        },
      ),

      // Admin Shell
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) => const AdminShell(),
      ),
    ],
  );
});
