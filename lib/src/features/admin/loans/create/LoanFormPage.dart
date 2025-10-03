import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/features/admin/loans/create/LoanFormContent.dart';
import 'package:crediahorro/src/features/admin/loans/create/bloc/LoanFormBloc.dart';
import 'package:crediahorro/src/services/LoanService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoanFormPage extends StatelessWidget {
  final int clienteId;
  const LoanFormPage({super.key, required this.clienteId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LoanFormBloc(loanService: LoanService(), clienteId: clienteId),
      child: const AppScaffold(title: "CREDIAHORRO", body: LoanFormContent()),
    );
  }
}
