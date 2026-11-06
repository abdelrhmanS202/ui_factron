import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/data_table_view.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Summary Cards
          Row(
            children: [
              Expanded(
                child: CustomCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.people_alt_rounded, color: AppColors.accentLavender, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('إجمالي العملاء المسجلين', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${db.customers.length} عميل', style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.warning, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('إجمالي الرصيد المستحق (ديون)', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(AppFormatters.formatCurrency(db.totalCustomerDebt), style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Customers Data Table
          DataTableView<Customer>(
            title: 'دليل العملاء والحسابات',
            searchHint: 'البحث باسم العميل أو الكود أو الهاتف...',
            searchFilter: (c, query) =>
                c.name.contains(query) || c.code.contains(query) || c.phone.contains(query),
            headerAction: ElevatedButton.icon(
              onPressed: () => _showAddCustomerDialog(context, db),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('إضافة عميل جديد', style: TextStyle(fontSize: 12)),
            ),
            columns: const [
              DataColumnSpec(title: 'كود العميل', width: 90),
              DataColumnSpec(title: 'اسم العميل / الشركة', width: 200),
              DataColumnSpec(title: 'رقم الهاتف', width: 110),
              DataColumnSpec(title: 'العنوان / الموقع', width: 160),
              DataColumnSpec(title: 'نوع العميل', width: 110),
              DataColumnSpec(title: 'الرصيد المستحق', width: 120),
              DataColumnSpec(title: 'إجمالي المبيعات', width: 120),
              DataColumnSpec(title: 'الحالة', width: 90),
              DataColumnSpec(title: 'إجراءات', width: 120, alignment: Alignment.center),
            ],
            items: db.customers,
            rowBuilder: (c) => [
              Text(c.code, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(c.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(c.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text(c.address, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.secondarySurface, borderRadius: BorderRadius.circular(4)),
                child: Text(c.customerType, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ),
              Text(
                AppFormatters.formatCurrency(c.balance),
                style: TextStyle(
                  color: c.balance > 0 ? AppColors.warning : AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(AppFormatters.formatCurrency(c.totalSales), style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
              StatusChip(status: c.status, fontSize: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.receipt_rounded, size: 18, color: AppColors.info),
                    tooltip: 'إنشاء طلب للعميل',
                    onPressed: () {
                      db.setActiveRoute('newOrder');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.history_rounded, size: 18, color: AppColors.accentLavender),
                    tooltip: 'سجل التعاملات والديون',
                    onPressed: () => _showCustomerHistoryDialog(context, c, db),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context, MockDatabase db) {
    final codeCtrl = TextEditingController(text: 'C-100${db.customers.length + 1}');
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    String type = 'شركات كبرى';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة عميل جديد', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'كود العميل')),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم الشركة / العميل *')),
              const SizedBox(height: 12),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'رقم الهاتف *')),
              const SizedBox(height: 12),
              TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'العنوان / المنطقة الصناعية')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(labelText: 'تصنيف العميل'),
                dropdownColor: AppColors.cardSurface,
                items: ['شركات كبرى', 'شركات متوسطة', 'تجار ومصدرون', 'لوجستيات']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) type = val;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                db.addCustomer(
                  Customer(
                    id: 'CUST-${DateTime.now().millisecondsSinceEpoch}',
                    code: codeCtrl.text,
                    name: nameCtrl.text,
                    phone: phoneCtrl.text,
                    address: addressCtrl.text,
                    customerType: type,
                    balance: 0.0,
                    totalSales: 0.0,
                    lastTransaction: DateTime.now(),
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('حفظ العميل'),
          ),
        ],
      ),
    );
  }

  void _showCustomerHistoryDialog(BuildContext context, Customer customer, MockDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('سجل كشف حساب العميل: ${customer.name}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        content: SizedBox(
          width: 500,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.secondarySurface, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الرصيد المستحق الحالي:', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    Text(AppFormatters.formatCurrency(customer.balance), style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('سجل الطلبات والفواتير السابقة:', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: db.customerOrders.where((o) => o.customerId == customer.id).map((o) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('${o.orderNo} - ${o.palletName}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                    subtitle: Text('تاريخ: ${AppFormatters.formatDate(o.orderDate)}', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    trailing: Text(AppFormatters.formatCurrency(o.totalAmount), style: const TextStyle(color: AppColors.accentLavender, fontSize: 12, fontWeight: FontWeight.bold)),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق')),
        ],
      ),
    );
  }
}
