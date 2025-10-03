import 'package:crediahorro/src/common_widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:crediahorro/src/constants/app_colors.dart';
import 'package:crediahorro/src/constants/app_text_styles.dart';
import 'package:crediahorro/src/common_widgets/app_logo.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "CREDIAHORRO",
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const AppLogo(size: 80),
            const SizedBox(height: 10),
            Text(
              "Reportes Gráficos",
              style: AppTextStyles.screenTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  "📊 Aquí irán los gráficos interactivos",
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      initialIndex: 2,
    );
  }
}
