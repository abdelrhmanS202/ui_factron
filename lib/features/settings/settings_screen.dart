import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController(text: 'مصنع فاكترون للبالتات الخشبية');
    final addrCtrl = TextEditingController(text: 'المنطقة الصناعية الثالثة - 6 أكتوبر - الجيزة');
    final currCtrl = TextEditingController(text: 'الجنيه المصري (ج.م / EGP)');
    final vatCtrl = TextEditingController(text: '14%');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('إعدادات المصنع والهوية البصرية للنظام',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('تجهيز بيانات المصنع، وحدات القياس، والضرائب والألوان الرئيسية',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),

          const SizedBox(height: 20),

          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('بيانات المصنع الأساسية', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(decoration: const InputDecoration(labelText: 'اسم المصنع بالكامل'), controller: nameCtrl),
                const SizedBox(height: 12),
                TextField(decoration: const InputDecoration(labelText: 'العنوان والمدينة'), controller: addrCtrl),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(decoration: const InputDecoration(labelText: 'العملة الافتراضية'), controller: currCtrl)),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(decoration: const InputDecoration(labelText: 'نسبة القيمة المضافة VAT'), controller: vatCtrl)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('لوحة الألوان المعتمدة (Factory Theme)', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildColorSwatch('البنفسجي الأساسي', AppColors.primaryPurple, '#170C7A'),
                    const SizedBox(width: 12),
                    _buildColorSwatch('العميق', AppColors.deepPurple, '#0D073D'),
                    const SizedBox(width: 12),
                    _buildColorSwatch('خلفية داكنة', AppColors.darkBackground, '#0B0D14'),
                    const SizedBox(width: 12),
                    _buildColorSwatch('اللافندر الفاتح', AppColors.accentLavender, '#8A7CFF'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حفظ الإعدادات بنجاح'), backgroundColor: AppColors.success),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                  icon: const Icon(Icons.save_rounded, size: 18),
                  label: const Text('حفظ إعدادات النظام'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(String label, Color color, String code) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        Text(code, style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
      ],
    );
  }
}
