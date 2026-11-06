import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/data_table_view.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTableView<MachineAsset>(
            title: 'دليل الماكينات والصيانة الوقائية بمناشر وعنابر التصنيع',
            columns: const [
              DataColumnSpec(title: 'كود المعدة', width: 110),
              DataColumnSpec(title: 'اسم الماكينة / المنشار', width: 250),
              DataColumnSpec(title: 'النوع والتصنيف', width: 140),
              DataColumnSpec(title: 'موقع العنبر', width: 160),
              DataColumnSpec(title: 'آخر صيانة', width: 110),
              DataColumnSpec(title: 'الصيانة القادمة', width: 120),
              DataColumnSpec(title: 'الحالة الفنية', width: 130),
            ],
            items: db.machines,
            rowBuilder: (m) => [
              Text(m.code, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(m.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(m.type, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text(m.location, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              Text(AppFormatters.formatDate(m.lastMaintenanceDate), style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text(AppFormatters.formatDate(m.nextMaintenanceDate), style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
              StatusChip(status: m.status, fontSize: 10),
            ],
          ),
        ],
      ),
    );
  }
}
