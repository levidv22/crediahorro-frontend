import 'package:crediahorro/src/features/cliente/cuotas/CuotasClienteContent.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteBloc.dart';
import 'package:crediahorro/src/features/cliente/cuotas/bloc/CuotasClienteEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/services/UsuariosService.dart';

class CuotasClientePage extends StatelessWidget {
  final int prestamoId;

  const CuotasClientePage({super.key, required this.prestamoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CuotasClienteBloc(UsuariosService())
            ..add(LoadCuotasCliente(prestamoId)),
      child: AppScaffold(
        title: "Mis Cuotas",
        body: const CuotasClienteContent(),
      ),
    );
  }
}
