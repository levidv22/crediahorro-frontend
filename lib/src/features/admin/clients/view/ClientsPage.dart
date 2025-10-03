import 'package:crediahorro/src/features/admin/clients/view/ClientsContent.dart';
import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsBloc.dart';
import 'package:crediahorro/src/features/admin/clients/view/bloc/ClientsEvent.dart';
import 'package:crediahorro/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/services/ClienteService.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientsBloc(ClienteService())..add(LoadClients()),
      child: Builder(
        builder: (context) => AppScaffold(
          title: "CREDIAHORRO",
          body: ClientsContent(),
          initialIndex: 1,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRouter.clienteForm,
              );

              if (result == true && context.mounted) {
                context.read<ClientsBloc>().add(LoadClients());
              }
            },
            backgroundColor: Colors.white,
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text("Agregar", style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
