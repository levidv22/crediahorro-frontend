import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/features/admin/clients/edit/ClienteEditContent.dart';
import 'package:crediahorro/src/features/admin/clients/edit/bloc/ClienteEditBloc.dart';
import 'package:crediahorro/src/features/admin/clients/edit/bloc/ClienteEditEvent.dart';
import 'package:crediahorro/src/features/admin/clients/edit/bloc/ClienteEditState.dart';
import 'package:crediahorro/src/services/ClienteService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClienteEditPage extends StatelessWidget {
  final int clienteId;
  const ClienteEditPage({super.key, required this.clienteId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ClienteEditBloc(ClienteService())..add(LoadClienteById(clienteId)),
      child: BlocConsumer<ClienteEditBloc, ClienteEditState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cliente actualizado con éxito")),
            );
            Navigator.pop(context, true);
          }
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
          }
        },
        builder: (context, state) {
          return AppScaffold(
            title: "CREDIAHORRO",
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ClienteEditContent(state: state),
          );
        },
      ),
    );
  }
}
