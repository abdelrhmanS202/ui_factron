import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_card.dart';
import '../../data/mock/mock_database.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    final List<Map<String, String>> permKeys = [
      {'key': 'view', 'title': 'عرض الواجهة'},
      {'key': 'add', 'title': 'إضافة جديد'},
      {'key': 'edit', 'title': 'تعديل البيانات'},
      {'key': 'delete', 'title': 'حذف السجلات'},
      {'key': 'approve', 'title': 'اعتماد الفواتير/الطلبات'},
      {'key': 'export', 'title': 'تصدير التقارير'},
      {'key': 'print', 'title': 'الطباعة المعاينة'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('مصفوفة الأدوار والصلاحيات لمستخدمي النظام',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('تحديد الصلاحيات لكل دور (مالك المصنع، مدير، محاسب، أمين مخزن، مشرف إنتاج، جودة)',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),

          const SizedBox(height: 20),

          CustomCard(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(color: AppColors.border),
                defaultColumnWidth: const FixedColumnWidth(140),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: AppColors.secondarySurface),
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('الدور الوظيفي', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                      ...permKeys.map((p) => Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(p['title']!, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
                      )),
                    ],
                  ),
                  ...db.roles.map((r) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(r.roleTitle, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      ...permKeys.map((p) {
                        final permKey = p['key']!;
                        final isChecked = r.permissions[permKey] ?? false;
                        return Checkbox(
                          value: isChecked,
                          activeColor: AppColors.primaryPurple,
                          onChanged: (val) {
                            if (val != null) {
                              db.togglePermission(r.roleName, permKey, val);
                            }
                          },
                        );
                      }),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
