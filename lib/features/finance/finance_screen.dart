import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/data_table_view.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  int activeTab = 0; // 0: Financial Summary & P&L, 1: Expenses, 2: Safes & Banks

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
              _buildTabButton(0, 'قائمة الأرباح والخسائر والملخص', Icons.analytics_rounded),
              const SizedBox(width: 12),
              _buildTabButton(1, 'سجل المصروفات التشغيلية', Icons.receipt_long_rounded),
              const SizedBox(width: 12),
              _buildTabButton(2, 'الخزائن والحسابات البنكية', Icons.account_balance_rounded),
            ],
          ),

          const SizedBox(height: 20),

          if (activeTab == 0) _buildProfitLossTab(db),
          if (activeTab == 1) _buildExpensesTab(db),
          if (activeTab == 2) _buildAccountsTab(db),
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

  // TAB 0: P&L Statement
  Widget _buildProfitLossTab(MockDatabase db) {
    final grossRevenue = db.totalMonthlySales;
    final cogs = db.totalMonthlyPurchases * 0.65; // Cost of Goods Sold approx
    final grossProfit = grossRevenue - cogs;
    final operatingExpenses = db.totalMonthlyExpenses;
    final netProfit = grossProfit - operatingExpenses;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('قائمة الأرباح والخسائر التقديرية (P&L Summary)', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildPLRow('إجمالي إيرادات المبيعات (+)', AppFormatters.formatCurrency(grossRevenue), color: AppColors.success, isBold: true),
          _buildPLRow('تكلفة البضاعة المباعة خامات وطاقة (-)', AppFormatters.formatCurrency(cogs), color: AppColors.warning),
          const Divider(color: AppColors.border, height: 24),
          _buildPLRow('مجمل الربح (Gross Profit)', AppFormatters.formatCurrency(grossProfit), color: AppColors.info, isBold: true),
          _buildPLRow('المصروفات التشغيلية والأجور (-)', AppFormatters.formatCurrency(operatingExpenses), color: AppColors.error),
          const Divider(color: AppColors.border, height: 24),
          _buildPLRow('صافي الربح التقديري (Net Profit)', AppFormatters.formatCurrency(netProfit), color: AppColors.accentLavender, isBold: true),
        ],
      ),
    );
  }

  Widget _buildPLRow(String title, String amount, {required Color color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: isBold ? AppColors.textPrimary : AppColors.textSecondary, fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(amount, style: TextStyle(color: color, fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  // TAB 1: Expenses
  Widget _buildExpensesTab(MockDatabase db) {
    return DataTableView<ExpenseItem>(
      title: 'سجل المصروفات الإدارية والصناعية',
      headerAction: ElevatedButton.icon(
        onPressed: () => _showAddExpenseDialog(context, db),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('تسجيل مصروف جديد', style: TextStyle(fontSize: 12)),
      ),
      columns: const [
        DataColumnSpec(title: 'رقم السند', width: 110),
        DataColumnSpec(title: 'تصنيف المصروف', width: 160),
        DataColumnSpec(title: 'المبلغ', width: 120),
        DataColumnSpec(title: 'الحساب المدفوع منه', width: 180),
        DataColumnSpec(title: 'الوصف والبيان', width: 250),
      ],
      items: db.expenses,
      rowBuilder: (e) => [
        Text(e.expenseNo, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(e.category, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        Text(AppFormatters.formatCurrency(e.amount), style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(e.paymentAccount, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text(e.description, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }

  // TAB 2: Safes & Banks
  Widget _buildAccountsTab(MockDatabase db) {
    return Row(
      children: [
        Expanded(
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.point_of_sale_rounded, color: AppColors.success, size: 24),
                    SizedBox(width: 8),
                    Text('الخزينة الرئيسية بالمصنع', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('الرصيد النقدي المتاح:', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 4),
                Text(AppFormatters.formatCurrency(485000.0), style: const TextStyle(color: AppColors.success, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_balance_rounded, color: AppColors.info, size: 24),
                    SizedBox(width: 8),
                    Text('حساب بنك مصر (جاري)', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('الرصيد البنكي المتاح:', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 4),
                Text(AppFormatters.formatCurrency(1250000.0), style: const TextStyle(color: AppColors.info, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddExpenseDialog(BuildContext context, MockDatabase db) {
    final catCtrl = TextEditingController(text: 'كهرباء وطاقة');
    final amountCtrl = TextEditingController(text: '12000');
    final descCtrl = TextEditingController(text: 'مصاريف تشغيل صيانة دورية');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل مصروف جديد', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'تصنيف المصروف *')),
              const SizedBox(height: 12),
              TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'المبلغ (ج.م) *'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'الوصف والبيان')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              db.addExpense(
                ExpenseItem(
                  id: 'EXP-${DateTime.now().millisecondsSinceEpoch}',
                  expenseNo: 'EXP-2026-0${db.expenses.length + 25}',
                  date: DateTime.now(),
                  category: catCtrl.text,
                  amount: double.tryParse(amountCtrl.text) ?? 12000,
                  paymentAccount: 'الخزينة الرئيسية',
                  description: descCtrl.text,
                ),
              );
              Navigator.pop(ctx);
            },
            child: const Text('تسجيل المصروف'),
          ),
        ],
      ),
    );
  }
}
