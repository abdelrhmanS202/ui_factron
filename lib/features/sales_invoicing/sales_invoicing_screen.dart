import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/data_table_view.dart';
import '../../core/widgets/print_invoice_dialog.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class SalesInvoicingScreen extends StatelessWidget {
  const SalesInvoicingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTableView<SalesInvoice>(
            title: 'فواتير المبيعات والتحصيلات الضريبية',
            searchHint: 'البحث برقم الفاتورة أو العميل...',
            searchFilter: (inv, query) =>
                inv.invoiceNo.contains(query) || inv.customerName.contains(query) || inv.orderNo.contains(query),
            columns: const [
              DataColumnSpec(title: 'رقم الفاتورة', width: 110),
              DataColumnSpec(title: 'اسم العميل', width: 180),
              DataColumnSpec(title: 'أمر البيع', width: 110),
              DataColumnSpec(title: 'البالتة والكمية', width: 180),
              DataColumnSpec(title: 'إجمالي الفاتورة', width: 120),
              DataColumnSpec(title: 'المدفوع', width: 110),
              DataColumnSpec(title: 'المتبقي', width: 110),
              DataColumnSpec(title: 'حالة السداد', width: 110),
              DataColumnSpec(title: 'إجراءات', width: 140, alignment: Alignment.center),
            ],
            items: db.invoices,
            rowBuilder: (inv) => [
              Text(inv.invoiceNo, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(inv.customerName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(inv.orderNo, style: const TextStyle(color: AppColors.info, fontSize: 12)),
              Text('${inv.palletName} (${inv.quantity} بالتة)', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              Text(AppFormatters.formatCurrency(inv.grandTotal), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(AppFormatters.formatCurrency(inv.paidAmount), style: const TextStyle(color: AppColors.info, fontSize: 12)),
              Text(
                AppFormatters.formatCurrency(inv.remainingBalance),
                style: TextStyle(
                  color: inv.remainingBalance > 0 ? AppColors.warning : AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              StatusChip(status: inv.paymentStatus, fontSize: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.print_rounded, size: 18, color: AppColors.accentLavender),
                    tooltip: 'معاينة وطباعة الفاتورة',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => PrintInvoiceDialog(invoice: inv),
                      );
                    },
                  ),
                  if (inv.remainingBalance > 0)
                    IconButton(
                      icon: const Icon(Icons.payments_rounded, size: 18, color: AppColors.success),
                      tooltip: 'تسجيل تحصيل دفعة',
                      onPressed: () => _showPaymentDialog(context, inv, db),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, SalesInvoice inv, MockDatabase db) {
    final amountCtrl = TextEditingController(text: inv.remainingBalance.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تحصيل دفعة للفاتورة: ${inv.invoiceNo}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('المتبقي الحالي: ${AppFormatters.formatCurrency(inv.remainingBalance)}', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'المبلغ المحصل (ج.م) *'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final payVal = double.tryParse(amountCtrl.text) ?? inv.remainingBalance;
              db.recordPaymentForInvoice(inv.id, payVal);
              Navigator.pop(ctx);
            },
            child: const Text('إتمام التحصيل'),
          ),
        ],
      ),
    );
  }
}
