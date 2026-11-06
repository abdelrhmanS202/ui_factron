import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/data_table_view.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class HRScreen extends StatefulWidget {
  const HRScreen({super.key});

  @override
  State<HRScreen> createState() => _HRScreenState();
}

class _HRScreenState extends State<HRScreen> {
  int activeTab = 0; // 0: Employees, 1: Payroll, 2: Productivity

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTabButton(0, 'دليل الموظفين والعمال', Icons.badge_rounded),
              const SizedBox(width: 12),
              _buildTabButton(1, 'مسودة كشف الرواتب والأجور', Icons.monetization_on_rounded),
              const SizedBox(width: 12),
              _buildTabButton(2, 'تقرير إنتاجية عمال التقطيع والتسمير', Icons.speed_rounded),
            ],
          ),

          const SizedBox(height: 20),

          if (activeTab == 0) _buildEmployeesTab(db),
          if (activeTab == 1) _buildPayrollTab(db),
          if (activeTab == 2) _buildProductivityTab(db),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title, IconData icon) {
    final isActive = activeTab == index;
    return ElevatedButton.icon(
      onPressed: () => setState(() => activeTab = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppColors.primaryPurple : AppColors.cardSurface,
        foregroundColor: isActive ? Colors.white : AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isActive ? AppColors.accentLavender : AppColors.border),
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  // TAB 0: Employees
  Widget _buildEmployeesTab(MockDatabase db) {
    return DataTableView<Employee>(
      title: 'دليل العاملين بمصنع البالتات',
      columns: const [
        DataColumnSpec(title: 'كود الموظف', width: 90),
        DataColumnSpec(title: 'الاسم الثلاثي', width: 200),
        DataColumnSpec(title: 'المسمى الوظيفي', width: 160),
        DataColumnSpec(title: 'القسم / الورشة', width: 140),
        DataColumnSpec(title: 'رقم الهاتف', width: 120),
        DataColumnSpec(title: 'الراتب الأساسي', width: 120),
        DataColumnSpec(title: 'حضور اليوم', width: 110),
      ],
      items: db.employees,
      rowBuilder: (e) => [
        Text(e.code, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(e.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        Text(e.jobTitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text(e.department, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Text(e.phone, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Text(AppFormatters.formatCurrency(e.basicSalary), style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
        StatusChip(status: e.attendanceStatus, fontSize: 10),
      ],
    );
  }

  // TAB 1: Payroll Sheet
  Widget _buildPayrollTab(MockDatabase db) {
    return DataTableView<Employee>(
      title: 'مسودة مسير الرواتب والأجور لشهر أكتوبر 2026',
      columns: const [
        DataColumnSpec(title: 'الاسم', width: 200),
        DataColumnSpec(title: 'الوظيفة', width: 160),
        DataColumnSpec(title: 'الأساسي', width: 110),
        DataColumnSpec(title: 'حافز الإنتاج', width: 110),
        DataColumnSpec(title: 'خصومات وحافز', width: 110),
        DataColumnSpec(title: 'صافي الراتب المستحق', width: 140),
      ],
      items: db.employees,
      rowBuilder: (e) {
        final net = e.basicSalary + 1500;
        return [
          Text(e.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(e.jobTitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Text(AppFormatters.formatCurrency(e.basicSalary), style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const Text('1,500 ج.م', style: TextStyle(color: AppColors.success, fontSize: 12)),
          const Text('0 ج.م', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          Text(AppFormatters.formatCurrency(net), style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 13)),
        ];
      },
    );
  }

  // TAB 2: Worker Productivity
  Widget _buildProductivityTab(MockDatabase db) {
    return DataTableView<WorkerProductivity>(
      title: 'سجل ومعدل إنتاجية الفنيين والعمال لكل أمر إنتاج',
      columns: const [
        DataColumnSpec(title: 'الفني / الفريق', width: 200),
        DataColumnSpec(title: 'أمر الإنتاج', width: 120),
        DataColumnSpec(title: 'الوحدات المنجزة', width: 120),
        DataColumnSpec(title: 'الساعات المستغرقة', width: 130),
        DataColumnSpec(title: 'الوحدات المرفوضة', width: 120),
        DataColumnSpec(title: 'معدل الإنتاجية / ساعة', width: 150),
      ],
      items: db.workerProductivityList,
      rowBuilder: (w) => [
        Text(w.workerName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        Text(w.productionOrderNo, style: const TextStyle(color: AppColors.info, fontSize: 12, fontWeight: FontWeight.bold)),
        Text('${w.unitsCompleted} قطعة', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
        Text('${w.timeSpentHours} ساعة', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Text('${w.rejectedUnits} قطعة', style: const TextStyle(color: AppColors.error, fontSize: 12)),
        Text('${w.unitsPerHour.toStringAsFixed(1)} بالتة/ساعة', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
