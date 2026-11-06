import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

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
                  Text('دليل المنتجات الجاهزة وقوائم الأسعار', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('المنتجات القياسية والمواصفات المعتمدة في المصنع', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddProductDialog(context, db),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('إضافة بالتة جديدة للكتالوج', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Cards Grid of Ready Pallet Products
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 380,
              mainAxisExtent: 260,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: db.readyProducts.length,
            itemBuilder: (context, index) {
              final p = db.readyProducts[index];
              return CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.primaryPurple.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.inventory_2_rounded, color: AppColors.accentLavender, size: 20),
                        ),
                        StatusChip(status: p.status, fontSize: 10),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(p.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('كود: ${p.code} • المقاس: ${p.dimensions}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    const Spacer(),
                    const Divider(color: AppColors.border),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('تكلفة التصنيع التقديرية', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                            Text(AppFormatters.formatCurrency(p.totalManufacturingCost), style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('سعر البيع المعتمد', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                            Text(AppFormatters.formatCurrency(p.sellingPrice), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('المخزون المتاح: ${p.stockQty} بالتة', style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('هامش الربح: ${p.profitMarginPercent.toStringAsFixed(1)}%', style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, MockDatabase db) {
    final nameCtrl = TextEditingController();
    final codeCtrl = TextEditingController(text: 'PAL-NEW-0${db.readyProducts.length + 1}');
    final dimCtrl = TextEditingController(text: '120 × 100 سم');
    final priceCtrl = TextEditingController(text: '750');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة بالتة قياسية للكتالوج', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'كود المنتج')),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم البالتة *')),
              const SizedBox(height: 12),
              TextField(controller: dimCtrl, decoration: const InputDecoration(labelText: 'الأبعاد والمقاسات (طول × عرض)')),
              const SizedBox(height: 12),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'سعر البيع المعتمد (ج.م) *'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                db.addPalletProduct(
                  PalletProduct(
                    id: 'PROD-${DateTime.now().millisecondsSinceEpoch}',
                    code: codeCtrl.text,
                    name: nameCtrl.text,
                    dimensions: dimCtrl.text,
                    bomComponents: [],
                    laborCostPerUnit: 35.0,
                    overheadCostPerUnit: 25.0,
                    sellingPrice: double.tryParse(priceCtrl.text) ?? 750.0,
                    stockQty: 100,
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('حفظ المنتج'),
          ),
        ],
      ),
    );
  }
}
