import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/features/admin/clients/create/ClienteFormContent.dart';
import 'package:crediahorro/src/features/admin/clients/create/bloc/ClienteFormBloc.dart';
import 'package:crediahorro/src/features/admin/clients/create/bloc/ClienteFormState.dart';
import 'package:crediahorro/src/services/ClienteService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClienteFormPage extends StatelessWidget {
  const ClienteFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClienteFormBloc(ClienteService()),
      child: BlocConsumer<ClienteFormBloc, ClienteFormState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cliente creado con éxito")),
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
                : ClienteFormContent(state: state),
          );
        },
      ),
    );
  }
}
