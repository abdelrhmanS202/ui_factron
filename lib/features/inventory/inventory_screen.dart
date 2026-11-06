import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/data_table_view.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int activeTab = 0; // 0: Raw Materials, 1: Warehouses Overview, 2: Movements & Material Issue

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
              _buildTabButton(0, 'أصناف الخامات والمهمات', Icons.category_rounded),
              const SizedBox(width: 12),
              _buildTabButton(1, 'نظرة عامة على المخازن الأربعة', Icons.warehouse_rounded),
              const SizedBox(width: 12),
              _buildTabButton(2, 'حركات المخزون وأذون الصرف', Icons.swap_horiz_rounded),
            ],
          ),

          const SizedBox(height: 20),

          if (activeTab == 0) _buildRawMaterialsTab(db),
          if (activeTab == 1) _buildWarehousesTab(db),
          if (activeTab == 2) _buildMovementsTab(db),
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

  // TAB 0: Raw Materials Table
  Widget _buildRawMaterialsTab(MockDatabase db) {
    return DataTableView<InventoryItem>(
      title: 'رصيد الخامات والمستلزمات (الألواح والعروق والمسامير)',
      searchHint: 'البحث باسم الخامة أو الكود...',
      searchFilter: (item, query) => item.name.contains(query) || item.code.contains(query),
      headerAction: ElevatedButton.icon(
        onPressed: () => _showAddMaterialDialog(context, db),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('إضافة خامة جديدة', style: TextStyle(fontSize: 12)),
      ),
      columns: const [
        DataColumnSpec(title: 'كود الخامة', width: 120),
        DataColumnSpec(title: 'اسم الخامة / الصنف', width: 220),
        DataColumnSpec(title: 'التصنيف', width: 110),
        DataColumnSpec(title: 'الوحدة', width: 70),
        DataColumnSpec(title: 'الرصيد المتاح', width: 100),
        DataColumnSpec(title: 'تحت التشغيل (WIP)', width: 110),
        DataColumnSpec(title: 'متوسط التكلفة', width: 100),
        DataColumnSpec(title: 'قيمة المخزون', width: 120),
        DataColumnSpec(title: 'موقع التخزين', width: 140),
      ],
      items: db.rawMaterials,
      rowBuilder: (r) => [
        Text(r.code, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(r.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        Text(r.category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text(r.unit, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Text(
          '${AppFormatters.formatNumber(r.availableStock)} ${r.unit}',
          style: TextStyle(
            color: r.isLowStock ? AppColors.warning : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        Text('${AppFormatters.formatNumber(r.wipStock)} ${r.unit}', style: const TextStyle(color: AppColors.info, fontSize: 12)),
        Text('${r.avgUnitCost} ج.م', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text(AppFormatters.formatCurrency(r.totalStockValue), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(r.warehouseLocation, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  // TAB 1: 4 Separated Warehouses Overview
  Widget _buildWarehousesTab(MockDatabase db) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _buildWarehouseCard('مخزن الخامات الرئيسي A', 'الأخشاب السويد والموسكي والمسامير', '14,200 ألواح | 8,900 عروق', AppColors.primaryPurple, Icons.forest_rounded),
        _buildWarehouseCard('مخزن تحت التشغيل (WIP)', 'الخامات المصروفة لأوامر الإنتاج الجارية', '1,200 ألواح | 900 عروق', AppColors.info, Icons.precision_manufacturing_rounded),
        _buildWarehouseCard('مخزن المنتجات التامة', 'البالتات الجاهزة للتسليم للعملاء', '665 بالتة جاهزة', AppColors.success, Icons.inventory_2_rounded),
        _buildWarehouseCard('مخزن الهالك والفرز', 'قصاصات الخشب القابلة لإعادة التدوير والهالك', '35 متر مكعب قصاصات', AppColors.warning, Icons.delete_outline_rounded),
      ],
    );
  }

  Widget _buildWarehouseCard(String title, String desc, String stat, Color color, IconData icon) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(desc, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.secondarySurface, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الرصيد الحالي بالمخزن:', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                Text(stat, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Movements & Material Issue Notes
  Widget _buildMovementsTab(MockDatabase db) {
    return DataTableView<StockMovement>(
      title: 'سجل حركات المخزون وأذون الصرف للتصنيع',
      columns: const [
        DataColumnSpec(title: 'كود الحركة', width: 100),
        DataColumnSpec(title: 'الصنف / الخامة', width: 200),
        DataColumnSpec(title: 'نوع الحركة', width: 140),
        DataColumnSpec(title: 'الكمية', width: 100),
        DataColumnSpec(title: 'من مخزن', width: 130),
        DataColumnSpec(title: 'إلى مخزن', width: 140),
        DataColumnSpec(title: 'رقم الأمر المرتبط', width: 120),
        DataColumnSpec(title: 'المسؤول', width: 140),
      ],
      items: db.stockMovements,
      rowBuilder: (m) => [
        Text(m.id, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(m.itemName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: AppColors.primaryPurple.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
          child: Text(m.movementType, style: const TextStyle(color: AppColors.accentLavender, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        Text('${m.quantity} ${m.unit}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(m.fromWarehouse, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        Text(m.toWarehouse, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        Text(m.refOrderNo, style: const TextStyle(color: AppColors.info, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(m.actorName, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  void _showAddMaterialDialog(BuildContext context, MockDatabase db) {
    final codeCtrl = TextEditingController(text: 'RAW-00${db.rawMaterials.length + 1}');
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '1000');
    final costCtrl = TextEditingController(text: '35');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة خامة جديدة للمخزن', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'كود الخامة')),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الخامة / الصنف *')),
              const SizedBox(height: 12),
              TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'الكمية الافتتاحية *'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: costCtrl, decoration: const InputDecoration(labelText: 'متوسط تكلفة الوحدة (ج.م)'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                db.addRawMaterial(
                  InventoryItem(
                    id: 'RAW-${DateTime.now().millisecondsSinceEpoch}',
                    code: codeCtrl.text,
                    name: nameCtrl.text,
                    category: 'ألواح خشب',
                    lengthCm: 120,
                    widthCm: 10,
                    thicknessCm: 2.2,
                    unit: 'قطعة',
                    availableStock: double.tryParse(qtyCtrl.text) ?? 1000,
                    avgUnitCost: double.tryParse(costCtrl.text) ?? 35,
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('حفظ الخامة'),
          ),
        ],
      ),
    );
  }
}
