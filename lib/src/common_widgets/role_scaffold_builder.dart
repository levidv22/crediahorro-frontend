import 'package:flutter/material.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold_usuario.dart';

/// Construye el Scaffold correspondiente según el rol del usuario.
/// - Si es ADMIN (o vacío) → AppScaffold
/// - Si es USUARIO → AppScaffoldUsuario
Widget buildRoleBasedScaffold({
  required String role,
  required String title,
  required Widget body,
  Widget? floatingActionButton,
  required String viewName, // "profile" o "settings"
}) {
  int initialIndex;

  if (role == "USUARIO") {
    // 👤 Cliente
    if (viewName == "profile") {
      initialIndex = 2;
    } else if (viewName == "settings") {
      initialIndex = 3;
    } else {
      initialIndex = 0;
    }

    return AppScaffoldUsuario(
      title: title,
      body: body,
      floatingActionButton: floatingActionButton,
      initialIndex: initialIndex,
    );
  } else {
    // 🧑‍💼 Administrador
    if (viewName == "profile") {
      initialIndex = 3;
    } else if (viewName == "settings") {
      initialIndex = 4;
    } else {
      initialIndex = 0;
    }

    return AppScaffold(
      title: title,
      body: body,
      floatingActionButton: floatingActionButton,
      initialIndex: initialIndex,
    );
  }
}
