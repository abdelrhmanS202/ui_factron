import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/data_table_view.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTableView<CustomerOrder>(
            title: 'طلبات العملاء وأوامر البيع',
            searchHint: 'البحث برقم الطلب أو العميل أو البالتة...',
            searchFilter: (o, query) =>
                o.orderNo.contains(query) || o.customerName.contains(query) || o.palletName.contains(query),
            headerAction: ElevatedButton.icon(
              onPressed: () => db.setActiveRoute('newOrder'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
              label: const Text('تسجيل طلب جديد', style: TextStyle(fontSize: 12)),
            ),
            columns: const [
              DataColumnSpec(title: 'رقم الطلب', width: 110),
              DataColumnSpec(title: 'اسم العميل', width: 180),
              DataColumnSpec(title: 'البالتة المطلوبة', width: 180),
              DataColumnSpec(title: 'الكمية', width: 80),
              DataColumnSpec(title: 'سعر الوحدة', width: 90),
              DataColumnSpec(title: 'إجمالي القيمة', width: 110),
              DataColumnSpec(title: 'المبلغ المدفوع', width: 110),
              DataColumnSpec(title: 'الحالة الحالية', width: 110),
              DataColumnSpec(title: 'تغيير الحالة / إجراء', width: 130, alignment: Alignment.center),
            ],
            items: db.customerOrders,
            rowBuilder: (o) => [
              Text(o.orderNo, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(o.customerName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(o.palletName, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text('${o.quantity} بالتة', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
              Text(AppFormatters.formatCurrency(o.unitPrice), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text(AppFormatters.formatCurrency(o.totalAmount), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(AppFormatters.formatCurrency(o.paidAmount), style: const TextStyle(color: AppColors.info, fontSize: 12)),
              StatusChip(status: o.status, fontSize: 10),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSecondary),
                color: AppColors.cardSurface,
                onSelected: (newStatus) {
                  db.updateOrderStatus(o.id, newStatus);
                },
                itemBuilder: (context) => [
                  'عرض سعر',
                  'معتمد',
                  'قيد الإنتاج',
                  'فحص الجودة',
                  'جاهز للتسليم',
                  'تم التسليم',
                  'مكتمل'
                ].map((s) => PopupMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)))).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
