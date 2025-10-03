import 'package:crediahorro/src/features/admin/loans/view/LoansContent.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansBloc.dart';
import 'package:crediahorro/src/features/admin/loans/view/bloc/LoansEvent.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/services/ClienteService.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';

class LoansPage extends StatelessWidget {
  final int clienteId;
  const LoansPage({super.key, required this.clienteId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoansBloc(ClienteService())..add(LoansLoaded(clienteId)),
      child: Builder(
        builder: (context) {
          return AppScaffold(
            title: "CREDIAHORRO",
            body: LoansContent(clienteId: clienteId),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRouter.prestamoNuevo,
                  arguments: clienteId,
                );
                if (result == true && context.mounted) {
                  context.read<LoansBloc>().add(LoansLoaded(clienteId));
                }
              },
              backgroundColor: Colors.white,
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text(
                "Agregar",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
