import 'package:crediahorro/src/common_widgets/app_scaffold_usuario.dart';
import 'package:crediahorro/src/features/cliente/prestamos/PrestamosClienteListaContent.dart';
import 'package:crediahorro/src/features/cliente/prestamos/bloc/PrestamosClienteListaBloc.dart';
import 'package:crediahorro/src/features/cliente/prestamos/bloc/PrestamosClienteListaEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/services/UsuariosService.dart';

class PrestamosClienteListaPage extends StatelessWidget {
  const PrestamosClienteListaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PrestamosClienteListaBloc(UsuariosService())
            ..add(LoadPrestamosClienteLista()),
      child: const AppScaffoldUsuario(
        title: "CREDIAHORRO",
        body: PrestamosClienteListaContent(),
        initialIndex: 1,
      ),
    );
  }
}
