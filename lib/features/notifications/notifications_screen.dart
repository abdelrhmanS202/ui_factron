import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/custom_card.dart';
import '../../data/mock/mock_database.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('مركز الإشعارات وتنبيهات النظام', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('تنبيهات نقص الخامات والمستحقات والطلبات المتأخرة', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),

          const SizedBox(height: 20),

          CustomCard(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.notifications.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.border),
              itemBuilder: (context, index) {
                final n = db.notifications[index];
                return ListTile(
                  leading: Icon(
                    n.type == 'warning'
                        ? Icons.warning_amber_rounded
                        : n.type == 'error'
                            ? Icons.error_outline_rounded
                            : Icons.check_circle_outline_rounded,
                    color: n.type == 'warning'
                        ? AppColors.warning
                        : n.type == 'error'
                            ? AppColors.error
                            : AppColors.success,
                    size: 28,
                  ),
                  title: Text(n.title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(n.message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  trailing: Text(
                    AppFormatters.formatDateTime(n.timestamp),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
