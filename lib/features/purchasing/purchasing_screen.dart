import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/data_table_view.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class PurchasingScreen extends StatefulWidget {
  const PurchasingScreen({super.key});

  @override
  State<PurchasingScreen> createState() => _PurchasingScreenState();
}

class _PurchasingScreenState extends State<PurchasingScreen> {
  int activeTab = 0; // 0: Suppliers, 1: Purchase Orders

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
              _buildTabButton(0, 'دليل الموردين الحسابات', Icons.local_shipping_rounded),
              const SizedBox(width: 12),
              _buildTabButton(1, 'أوامر الشراء والشحنات', Icons.receipt_long_rounded),
            ],
          ),

          const SizedBox(height: 20),

          if (activeTab == 0) _buildSuppliersTab(db) else _buildPurchaseOrdersTab(db),
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

  // TAB 0: Suppliers
  Widget _buildSuppliersTab(MockDatabase db) {
    return DataTableView<Supplier>(
      title: 'دليل موردي الخامات والأخشاب',
      searchHint: 'البحث باسم المورد أو الصنف...',
      searchFilter: (s, query) => s.name.contains(query) || s.suppliedCategory.contains(query),
      headerAction: ElevatedButton.icon(
        onPressed: () => _showAddSupplierDialog(context, db),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('إضافة مورد جديد', style: TextStyle(fontSize: 12)),
      ),
      columns: const [
        DataColumnSpec(title: 'كود المورد', width: 90),
        DataColumnSpec(title: 'اسم المورد / الشركة', width: 220),
        DataColumnSpec(title: 'رقم الهاتف', width: 120),
        DataColumnSpec(title: 'الخامات الموردة', width: 200),
        DataColumnSpec(title: 'إجمالي المشتريات', width: 130),
        DataColumnSpec(title: 'مستحقات المورد (دائن)', width: 140),
      ],
      items: db.suppliers,
      rowBuilder: (s) => [
        Text(s.code, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(s.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        Text(s.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text(s.suppliedCategory, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Text(AppFormatters.formatCurrency(s.totalPurchases), style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
        Text(AppFormatters.formatCurrency(s.debtBalance), style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  // TAB 1: Purchase Orders
  Widget _buildPurchaseOrdersTab(MockDatabase db) {
    return DataTableView<PurchaseOrder>(
      title: 'أوامر الشراء والشحنات الواردة',
      headerAction: ElevatedButton.icon(
        onPressed: () => _showAddPODialog(context, db),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
        icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
        label: const Text('أمر شراء جديد', style: TextStyle(fontSize: 12)),
      ),
      columns: const [
        DataColumnSpec(title: 'رقم الأمر', width: 110),
        DataColumnSpec(title: 'المورد', width: 200),
        DataColumnSpec(title: 'الشحنة / الخامة', width: 220),
        DataColumnSpec(title: 'الكمية', width: 100),
        DataColumnSpec(title: 'الإجمالي', width: 120),
        DataColumnSpec(title: 'الحالة', width: 110),
      ],
      items: db.purchaseOrders,
      rowBuilder: (po) => [
        Text(po.poNo, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(po.supplierName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        Text(po.materialName, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text('${po.quantity} ${po.unit}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
        Text(AppFormatters.formatCurrency(po.totalAmount), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
        StatusChip(status: po.status, fontSize: 10),
      ],
    );
  }

  void _showAddSupplierDialog(BuildContext context, MockDatabase db) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final catCtrl = TextEditingController(text: 'أخشاب سويدي وزوان');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة مورد جديد', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم المورد / الشركة *')),
              const SizedBox(height: 12),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'رقم الهاتف *')),
              const SizedBox(height: 12),
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'نوع الخامات الموردة')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                db.addSupplier(
                  Supplier(
                    id: 'SUP-${DateTime.now().millisecondsSinceEpoch}',
                    code: 'S-200${db.suppliers.length + 1}',
                    name: nameCtrl.text,
                    phone: phoneCtrl.text,
                    address: 'دمياط / 6 أكتوبر',
                    suppliedCategory: catCtrl.text,
                    totalPurchases: 0.0,
                    debtBalance: 0.0,
                    lastDealDate: DateTime.now(),
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('حفظ المورد'),
          ),
        ],
      ),
    );
  }

  void _showAddPODialog(BuildContext context, MockDatabase db) {
    final matCtrl = TextEditingController(text: 'شحنة مسامير مجلفنة 7سم');
    final amountCtrl = TextEditingController(text: '85000');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إنشاء أمر شراء جديد', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: matCtrl, decoration: const InputDecoration(labelText: 'اسم الشحنة / الخامة *')),
              const SizedBox(height: 12),
              TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'القيمة الإجمالية (ج.م) *'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              db.addPurchaseOrder(
                PurchaseOrder(
                  id: 'PO-${DateTime.now().millisecondsSinceEpoch}',
                  poNo: 'PO-2026-0${db.purchaseOrders.length + 51}',
                  supplierName: db.suppliers.first.name,
                  orderDate: DateTime.now(),
                  expectedDate: DateTime.now().add(const Duration(days: 3)),
                  materialName: matCtrl.text,
                  quantity: 100,
                  unit: 'طرد',
                  totalAmount: double.tryParse(amountCtrl.text) ?? 85000,
                  status: 'قيد التوريد',
                ),
              );
              Navigator.pop(ctx);
            },
            child: const Text('إنشاء الأمر'),
          ),
        ],
      ),
    );
  }
}
