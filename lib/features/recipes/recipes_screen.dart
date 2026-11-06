import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/custom_card.dart';
import '../../data/mock/mock_database.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('إدارة وصفات التصنيع (Bill of Materials - BOM)',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('ربط الخامات والأبعاد والألواح والمسامير ونسب الهالك لكل منتج',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),

          const SizedBox(height: 20),

          ...db.readyProducts.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_tree_rounded, color: AppColors.accentLavender),
                          const SizedBox(width: 8),
                          Text('وصفة: ${p.name}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.secondarySurface, borderRadius: BorderRadius.circular(4)),
                            child: Text(p.dimensions, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                          ),
                        ],
                      ),
                      Text('إجمالي خامات الوحدة: ${AppFormatters.formatCurrency(p.totalMaterialsCost)}',
                          style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Table(
                    border: TableBorder.all(color: AppColors.border),
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: AppColors.secondarySurface),
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text('الخامة / المكون', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text('الكمية للوحدة', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text('سعر الخامة', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text('نسبة الهالك', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text('إجمالي تكلفة المكون', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                        ],
                      ),
                      ...p.bomComponents.map((c) => TableRow(
                        children: [
                          Padding(padding: const EdgeInsets.all(8), child: Text(c.materialName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text('${c.quantityPerUnit} ${c.unit}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text('${c.unitCost} ج.م', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text('${c.wastageRatioPercent}%', style: const TextStyle(color: AppColors.warning, fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(8), child: Text(AppFormatters.formatCurrency(c.totalComponentCost), style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12))),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
