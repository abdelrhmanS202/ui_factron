import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/custom_card.dart';
import '../../data/mock/mock_database.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedReportCategory = 'تقرير تحليل تكلفة الإنتاج والربحية';

  final List<String> reportCategories = [
    'تقرير تحليل تكلفة الإنتاج والربحية',
    'تقرير المبيعات والعملاء الأكثر تعاملاً',
    'تقرير الهالك وقصاصات الخشب النسبية',
    'تقرير حركة وتقييم مخزون الخامات',
    'تقرير إنتاجية العمال وساعات العمل',
    'تقرير الأرباح والخسائر والتدفقات النقدية',
  ];

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مركز التقارير والتحليلات الصناعية',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('استخراج وإكسپورت تقارير المبيعات، الإنتاج، التكلفة والمخزون',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تصدير التقرير بنجاح بصيغة CSV / Excel (Demo Action)'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('تصدير التقرير (Excel/CSV)', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Report Category Dropdown + Filter Card
          CustomCard(
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedReportCategory,
                    decoration: const InputDecoration(labelText: 'اختر نوع التقرير المطلوب *'),
                    dropdownColor: AppColors.cardSurface,
                    items: reportCategories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedReportCategory = val);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: AppColors.secondarySurface, borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Text('الفترة: 2026-10-01 إلى 2026-10-31', style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Report Detailed Preview Box
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedReportCategory, style: const TextStyle(color: AppColors.accentLavender, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('جدول ملخص مخرجات التقرير التحليلي:', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 16),
                Table(
                  border: TableBorder.all(color: AppColors.border),
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(color: AppColors.secondarySurface),
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: Text('كود المنتج / البيان', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(10), child: Text('الكمية المنتجة', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(10), child: Text('إجمالي المبيعات', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(10), child: Text('تكلفة الخامات والتصنيع', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: EdgeInsets.all(10), child: Text('صافي هامش الربح', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    ),
                    ...db.readyProducts.map((p) => TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.all(10), child: Text(p.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                        Padding(padding: const EdgeInsets.all(10), child: Text('${p.stockQty + 300} بالتة', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                        Padding(padding: const EdgeInsets.all(10), child: Text(AppFormatters.formatCurrency(p.sellingPrice * 500), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12))),
                        Padding(padding: const EdgeInsets.all(10), child: Text(AppFormatters.formatCurrency(p.totalManufacturingCost * 500), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
                        Padding(padding: const EdgeInsets.all(10), child: Text('${p.profitMarginPercent.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
