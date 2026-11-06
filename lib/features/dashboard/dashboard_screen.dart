import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/widgets/custom_charts.dart';
import '../../core/widgets/kpi_card.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter & Period Header Bar
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مؤشرات الأداء وإحصائيات المصنع',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'متابعة أداء المبيعات، خطوط الإنتاج، المخزون، والربحية',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product Filter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButton<String>(
                      value: db.selectedProductFilter,
                      underline: const SizedBox(),
                      dropdownColor: AppColors.cardSurface,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                      items: ['الكل', 'بالتة يورو 120x100', 'بالتة تصدير 120x80', 'بالتة CP3 114x114']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) db.updateDashboardProductFilter(val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Period Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: db.selectedPeriod,
                      underline: const SizedBox(),
                      dropdownColor: AppColors.primaryBlue,
                      icon: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      items: ['اليوم', 'هذا الأسبوع', 'هذا الشهر', 'هذه السنة']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) db.updateDashboardPeriod(val);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 13 KEY PERFORMANCE INDICATOR CARDS (Grid Layout)
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = isDesktop ? 4 : (constraints.maxWidth > 700 ? 2 : 1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6,
                children: [
                  KPICard(
                    title: 'مبيعات الشهر',
                    value: AppFormatters.formatCurrency(db.totalMonthlySales),
                    trend: '+14.2%',
                    isTrendPositive: true,
                    subtitle: 'مقارنة بالشهر السابق',
                    icon: Icons.monetization_on_rounded,
                    iconColor: AppColors.success,
                    onTap: () => db.setActiveRoute('salesInvoices'),
                  ),
                  KPICard(
                    title: 'التحصيلات النقدية',
                    value: AppFormatters.formatCurrency(db.totalMonthlyCollections),
                    trend: '+8.5%',
                    isTrendPositive: true,
                    subtitle: 'نسبة التحصيل 73%',
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: AppColors.info,
                    onTap: () => db.setActiveRoute('salesInvoices'),
                  ),
                  KPICard(
                    title: 'مستحقات العملاء (ديون)',
                    value: AppFormatters.formatCurrency(db.totalCustomerDebt),
                    trend: '-3.1%',
                    isTrendPositive: true,
                    subtitle: 'إجمالي المديونية الحالية',
                    icon: Icons.people_alt_rounded,
                    iconColor: AppColors.warning,
                    onTap: () => db.setActiveRoute('customers'),
                  ),
                  KPICard(
                    title: 'صافي الربح التقديري',
                    value: AppFormatters.formatCurrency(db.estimatedNetProfit),
                    trend: '+18.0%',
                    isTrendPositive: true,
                    subtitle: 'هامش الربح ~24%',
                    icon: Icons.trending_up_rounded,
                    iconColor: AppColors.primaryBlue,
                    onTap: () => db.setActiveRoute('finance'),
                  ),
                  KPICard(
                    title: 'قيمة المخزون الحالي',
                    value: AppFormatters.formatCurrency(db.totalInventoryValue),
                    subtitle: 'خامات + تحت التشغيل',
                    icon: Icons.warehouse_rounded,
                    iconColor: AppColors.info,
                    onTap: () => db.setActiveRoute('inventory'),
                  ),
                  KPICard(
                    title: 'البالتات المنتجة (الشهر)',
                    value: '${AppFormatters.formatNumber(db.totalPalletsProduced)} بالتة',
                    trend: '+12.5%',
                    subtitle: 'معدل الإنجاز 94%',
                    icon: Icons.inventory_2_rounded,
                    iconColor: AppColors.primaryBlue,
                    onTap: () => db.setActiveRoute('production'),
                  ),
                  KPICard(
                    title: 'نسبة الهالك والقصاصات',
                    value: AppFormatters.formatPercent(db.scrapPercentage),
                    trend: '-0.8%',
                    isTrendPositive: true,
                    subtitle: 'ضمن الحد المقبول (<5%)',
                    icon: Icons.high_quality_rounded,
                    iconColor: AppColors.warning,
                    onTap: () => db.setActiveRoute('scrapQuality'),
                  ),
                  KPICard(
                    title: 'أوامر الإنتاج النشطة',
                    value: '${db.openProductionOrdersCount} أوامر',
                    subtitle: 'خامات محجوزة ومجهزة',
                    icon: Icons.precision_manufacturing_rounded,
                    iconColor: AppColors.accentBlue,
                    onTap: () => db.setActiveRoute('production'),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // CHARTS SECTION (2 Rows of Charts)
          ResponsiveLayout(
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sales vs Expenses Chart (60% Width)
                Expanded(
                  flex: 3,
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'المبيعات مقابل المصروفات والتكاليف (12 شهراً)',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 260,
                          child: LineChartWidget(
                            labels: const ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر'],
                            series1: const [950, 1100, 1300, 1250, 1400, 1600, 1550, 1700, 1780, 1840],
                            series2: const [620, 710, 800, 780, 850, 920, 890, 950, 980, 1020],
                            series1Name: 'إجمالي الإيرادات (ألف ج.م)',
                            series2Name: 'التكاليف والمصروفات (ألف ج.م)',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Cost Breakdown Donut Chart (40% Width)
                Expanded(
                  flex: 2,
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'توزيع تكلفة تصنيع البالتات',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 260,
                          child: DonutChartWidget(
                            categories: const ['خامات خشب ومسامير', 'أجور وعمالة', 'مصروفات صناعية وطاقة', 'تكلفة الهالك'],
                            values: const [237250, 17500, 12500, 10250],
                            colors: const [
                              AppColors.primaryBlue,
                              AppColors.accentBlue,
                              AppColors.info,
                              AppColors.warning,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            mobile: Column(
              children: [
                CustomCard(
                  child: SizedBox(
                    height: 250,
                    child: LineChartWidget(
                      labels: const ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'],
                      series1: const [950, 1100, 1300, 1250, 1400, 1840],
                      series2: const [620, 710, 800, 780, 850, 1020],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomCard(
                  child: SizedBox(
                    height: 220,
                    child: DonutChartWidget(
                      categories: const ['خامات', 'أجور', 'مصروفات', 'هالك'],
                      values: const [237250, 17500, 12500, 10250],
                      colors: const [AppColors.primaryBlue, AppColors.accentBlue, AppColors.info, AppColors.warning],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SECOND ROW CHARTS: Bar Chart (Planned vs Actual Output)
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الإنتاج اليومي: الكميات المخططة مقابل الفعليه (آخر 7 أيام)',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: BarChartWidget(
                    labels: const ['السبت', 'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'اليوم'],
                    plannedValues: const [400, 450, 500, 500, 450, 550, 500],
                    actualValues: const [390, 440, 485, 510, 430, 540, 490],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // QUICK TABLES & ACTION LISTS
          ResponsiveLayout(
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent Orders Table
                Expanded(
                  flex: 1,
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('أحدث طلبات العملاء', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: () => db.setActiveRoute('orders'),
                              child: const Text('عرض الكل'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...db.customerOrders.take(3).map((o) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(o.orderNo, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                              subtitle: Text('${o.customerName} • ${o.palletName}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(AppFormatters.formatCurrency(o.totalAmount), style: const TextStyle(color: AppColors.primaryBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  StatusChip(status: o.status, fontSize: 10),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Low Stock Alerts Table
                Expanded(
                  flex: 1,
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('تنبيهات نقص الخامات', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: () => db.setActiveRoute('inventory'),
                              child: const Text('المخازن'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...db.rawMaterials.where((r) => r.isLowStock || r.availableStock < 3000).take(3).map((r) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                              title: Text(r.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                              subtitle: Text('المتاح: ${r.availableStock} ${r.unit} (الحد الأدنى: ${r.minStockLevel})', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                              trailing: ElevatedButton(
                                onPressed: () => db.setActiveRoute('purchasing'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                ),
                                child: const Text('طلب شراء', style: TextStyle(fontSize: 10)),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            mobile: Column(
              children: [
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('أحدث طلبات العملاء', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...db.customerOrders.take(2).map((o) => ListTile(
                            title: Text(o.orderNo, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                            subtitle: Text(o.customerName, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            trailing: StatusChip(status: o.status, fontSize: 10),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
