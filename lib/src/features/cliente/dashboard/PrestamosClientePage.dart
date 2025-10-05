import 'package:crediahorro/src/common_widgets/app_scaffold_usuario.dart';
import 'package:crediahorro/src/features/cliente/dashboard/PrestamosClienteContent.dart';
import 'package:crediahorro/src/features/cliente/dashboard/bloc/PrestamosClienteBloc.dart';
import 'package:crediahorro/src/features/cliente/dashboard/bloc/PrestamosClienteEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/services/UsuariosService.dart';

class PrestamosClientePage extends StatelessWidget {
  const PrestamosClientePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PrestamosClienteBloc(UsuariosService())..add(LoadPrestamosCliente()),
      child: const AppScaffoldUsuario(
        title: "CREDIAHORRO",
        body: PrestamosClienteContent(),
        initialIndex: 0,
      ),
    );
  }
}
