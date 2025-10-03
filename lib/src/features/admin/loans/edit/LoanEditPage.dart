import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/features/admin/loans/edit/LoanEditContent.dart';
import 'package:crediahorro/src/features/admin/loans/edit/bloc/LoanEditBloc.dart';
import 'package:crediahorro/src/features/admin/loans/edit/bloc/LoanEditEvent.dart';
import 'package:crediahorro/src/services/LoanService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoanEditPage extends StatelessWidget {
  final int clienteId;
  final int prestamoId;

  const LoanEditPage({
    super.key,
    required this.clienteId,
    required this.prestamoId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoanEditBloc(
        loanService: LoanService(),
        clienteId: clienteId,
        prestamoId: prestamoId,
      )..add(LoanEditStarted(prestamoId)),
      child: const AppScaffold(title: "CREDIAHORRO", body: LoanEditContent()),
    );
  }
}
