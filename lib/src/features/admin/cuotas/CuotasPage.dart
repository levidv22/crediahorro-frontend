import 'package:crediahorro/src/features/admin/cuotas/CuotasContent.dart';
import 'package:crediahorro/src/features/admin/cuotas/bloc/CuotasBloc.dart';
import 'package:crediahorro/src/features/admin/cuotas/bloc/CuotasEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:crediahorro/src/services/CuotaService.dart';

class CuotasPage extends StatelessWidget {
  final int prestamoId;
  const CuotasPage({super.key, required this.prestamoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CuotasBloc(CuotaService())..add(LoadCuotas(prestamoId)),
      child: AppScaffold(
        title: "CREDIAHORRO",
        body: CuotasContent(prestamoId: prestamoId),
      ),
    );
  }
}
