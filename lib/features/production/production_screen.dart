import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/data_table_view.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  bool showKanban = true;

  final List<String> productionStages = [
    'تخطيط الإنتاج',
    'حجز الخامات',
    'صرف الخامات',
    'تقطيع الخشب',
    'تجهيز المكونات',
    'تجميع وتسمير',
    'فحص الجودة',
    'اعتماد المنتج التام',
    'تام بالمخزن',
    'جاهز للتسليم',
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
                  Text('أوامر الإنتاج ومتابعة مراحل التصنيع',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('متابعة التدفق الصناعي من التقطيع للتجميع والجودة',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.view_kanban_rounded, color: showKanban ? AppColors.accentLavender : AppColors.textMuted),
                    tooltip: 'عرض لوحة Kanban',
                    onPressed: () => setState(() => showKanban = true),
                  ),
                  IconButton(
                    icon: Icon(Icons.table_chart_rounded, color: !showKanban ? AppColors.accentLavender : AppColors.textMuted),
                    tooltip: 'عرض الجدول',
                    onPressed: () => setState(() => showKanban = false),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (showKanban) _buildKanbanBoard(db) else _buildTableView(db),
        ],
      ),
    );
  }

  // KANBAN BOARD VIEW
  Widget _buildKanbanBoard(MockDatabase db) {
    return SizedBox(
      height: 600,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: productionStages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final stage = productionStages[index];
          final ordersInStage = db.productionOrders.where((p) => p.stage == stage).toList();

          return Container(
            width: 280,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondarySurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${index + 1}. $stage',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${ordersInStage.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: ordersInStage.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final p = ordersInStage[idx];
                      return CustomCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(p.orderNo, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
                                StatusChip(status: p.status, fontSize: 9),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(p.productName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('الطلب: ${p.customerOrderNo}', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: p.progressPercent / 100,
                              backgroundColor: AppColors.secondarySurface,
                              color: AppColors.success,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${p.producedQty} / ${p.plannedQty} بالتة', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                                Text('المشرف: ${p.supervisor}', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => _showUpdateStageDialog(context, p, db),
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 4)),
                                child: const Text('تحديث التقدم', style: TextStyle(fontSize: 10)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // TABLE VIEW
  Widget _buildTableView(MockDatabase db) {
    return DataTableView<ProductionOrder>(
      title: 'جدول أوامر الإنتاج',
      columns: const [
        DataColumnSpec(title: 'رقم أمر الإنتاج', width: 120),
        DataColumnSpec(title: 'رقم طلب العميل', width: 120),
        DataColumnSpec(title: 'اسم البالتة والمنتج', width: 200),
        DataColumnSpec(title: 'المخطط', width: 80),
        DataColumnSpec(title: 'المنجز', width: 80),
        DataColumnSpec(title: 'المرفوض', width: 80),
        DataColumnSpec(title: 'المرحلة الحالية', width: 130),
        DataColumnSpec(title: 'نسبة الإنجاز', width: 110),
        DataColumnSpec(title: 'إجراء', width: 100, alignment: Alignment.center),
      ],
      items: db.productionOrders,
      rowBuilder: (p) => [
        Text(p.orderNo, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(p.customerOrderNo, style: const TextStyle(color: AppColors.info, fontSize: 12)),
        Text(p.productName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
        Text('${p.plannedQty}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
        Text('${p.producedQty}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
        Text('${p.rejectedQty}', style: const TextStyle(color: AppColors.error, fontSize: 12)),
        StatusChip(status: p.stage, fontSize: 10),
        Text('${p.progressPercent.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
        IconButton(
          icon: const Icon(Icons.edit_rounded, size: 18, color: AppColors.accentLavender),
          onPressed: () => _showUpdateStageDialog(context, p, db),
        ),
      ],
    );
  }

  void _showUpdateStageDialog(BuildContext context, ProductionOrder p, MockDatabase db) {
    String currentStage = p.stage;
    final producedCtrl = TextEditingController(text: p.producedQty.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تحديث تقدم أمر الإنتاج: ${p.orderNo}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: currentStage,
                decoration: const InputDecoration(labelText: 'المرحلة الحالية'),
                dropdownColor: AppColors.cardSurface,
                items: productionStages.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) {
                  if (val != null) currentStage = val;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: producedCtrl,
                decoration: const InputDecoration(labelText: 'الكمية المنتجة الفعلية (بالتة)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final newQty = int.tryParse(producedCtrl.text) ?? p.producedQty;
              db.updateProductionStage(p.id, currentStage, newQty);
              Navigator.pop(ctx);
            },
            child: const Text('حفظ التعديل'),
          ),
        ],
      ),
    );
  }
}
