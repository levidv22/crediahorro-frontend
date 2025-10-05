import 'package:crediahorro/src/features/auth/login/LoginPage.dart';
import 'package:crediahorro/src/features/auth/register/RegisterPage.dart';
import 'package:crediahorro/src/features/admin/clients/create/ClienteFormPage.dart';
import 'package:crediahorro/src/features/admin/clients/edit/ClienteEditPage.dart';
import 'package:crediahorro/src/features/admin/clients/view/ClientsPage.dart';
import 'package:crediahorro/src/features/admin/cuotas/CuotasPage.dart';
import 'package:crediahorro/src/features/admin/dashboard/DashboardPage.dart';
import 'package:crediahorro/src/features/admin/loans/create/LoanFormPage.dart';
import 'package:crediahorro/src/features/admin/loans/edit/LoanEditPage.dart';
import 'package:crediahorro/src/features/admin/loans/view/LoansPage.dart';
import 'package:crediahorro/src/features/cliente/cuotas/CuotasClientePage.dart';
import 'package:crediahorro/src/features/cliente/dashboard/PrestamosClientePage.dart';
import 'package:crediahorro/src/features/cliente/prestamos/PrestamosClienteListaPage.dart';
import 'package:crediahorro/src/features/profile/profile_overview_page.dart';
import 'package:crediahorro/src/features/profile/profile_page.dart';
import 'package:crediahorro/src/features/admin/reports/reports_page.dart';
import 'package:crediahorro/src/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String clientes = '/clientes';
  static const String prestamos = '/prestamos';
  static const String prestamoNuevo = '/prestamo-nuevo';
  static const String prestamoEditar = '/prestamo-editar';
  static const String cuotas = '/cuotas';
  static const String reportes = '/reportes';
  static const String configuracion = '/configuracion';
  static const String clienteForm = '/cliente-form';
  static const String clienteEdit = '/cliente-edit';
  static const String perfil = '/perfil';
  static const String perfiloverview = '/perfiloverview';
  static const String prestamosclientes = '/prestamosclientes';
  static const String prestamosclienteslista = '/prestamosclienteslista';
  static const String cuotasclientes = '/cuotasclientes';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case clientes:
        return MaterialPageRoute(builder: (_) => const ClientsPage());
      case prestamos:
        final clienteId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => LoansPage(clienteId: clienteId),
        );
      case cuotas:
        final prestamoId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CuotasPage(prestamoId: prestamoId),
        );
      case prestamoNuevo:
        final clienteId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => LoanFormPage(clienteId: clienteId),
        );
      case prestamoEditar:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => LoanEditPage(
            clienteId: args['clienteId'],
            prestamoId: args['prestamoId'],
          ),
        );
      case reportes:
        return MaterialPageRoute(builder: (_) => const ReportsPage());
      case configuracion:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case clienteForm:
        return MaterialPageRoute(builder: (_) => const ClienteFormPage());
      case clienteEdit:
        final clienteId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ClienteEditPage(clienteId: clienteId),
        );
      case perfil:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case perfiloverview:
        return MaterialPageRoute(builder: (_) => const ProfileOverviewPage());
      case prestamosclientes:
        return MaterialPageRoute(builder: (_) => const PrestamosClientePage());
      case prestamosclienteslista:
        return MaterialPageRoute(
          builder: (_) => const PrestamosClienteListaPage(),
        );
      case cuotasclientes:
        final prestamoId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CuotasClientePage(prestamoId: prestamoId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Página no encontrada"))),
        );
    }
  }
}
