import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/data_table_view.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class ScrapQualityScreen extends StatefulWidget {
  const ScrapQualityScreen({super.key});

  @override
  State<ScrapQualityScreen> createState() => _ScrapQualityScreenState();
}

class _ScrapQualityScreenState extends State<ScrapQualityScreen> {
  int activeTab = 0; // 0: Scrap Log, 1: Quality Control

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
              _buildTabButton(0, 'سجل الهالك وقصاصات الأخشاب', Icons.delete_outline_rounded),
              const SizedBox(width: 12),
              _buildTabButton(1, 'فحص وقوائم جودة التصنيع (QC)', Icons.high_quality_rounded),
            ],
          ),

          const SizedBox(height: 20),

          if (activeTab == 0) _buildScrapTab(db) else _buildQCTab(db),
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

  // TAB 0: Scrap Log
  Widget _buildScrapTab(MockDatabase db) {
    return DataTableView<ScrapLog>(
      title: 'سجل الهالك اليومي ونسب الهالك',
      headerAction: ElevatedButton.icon(
        onPressed: () => _showAddScrapDialog(context, db),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('تسجيل هالك جديد', style: TextStyle(fontSize: 12)),
      ),
      columns: const [
        DataColumnSpec(title: 'رقم الإذن', width: 100),
        DataColumnSpec(title: 'أمر الإنتاج', width: 120),
        DataColumnSpec(title: 'اسم الخامة', width: 180),
        DataColumnSpec(title: 'تصنيف الهالك', width: 140),
        DataColumnSpec(title: 'الكمية', width: 90),
        DataColumnSpec(title: 'السبب والتحليل', width: 200),
        DataColumnSpec(title: 'إعادة الاستخدام', width: 110),
        DataColumnSpec(title: 'المسجل', width: 120),
      ],
      items: db.scrapLogs,
      rowBuilder: (s) => [
        Text(s.logNo, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(s.productionOrderNo, style: const TextStyle(color: AppColors.info, fontSize: 12, fontWeight: FontWeight.bold)),
        Text(s.materialName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(s.scrapType, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text('${s.quantity} ${s.unit}', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(s.reason, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        StatusChip(status: s.isReusable ? 'قابل للترجيع' : 'هالك نهائي', fontSize: 10),
        Text(s.recordedBy, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  // TAB 1: Quality Control
  Widget _buildQCTab(MockDatabase db) {
    return DataTableView<QualityCheck>(
      title: 'تقارير وفحوصات الجودة للأوامر المنتهية',
      headerAction: ElevatedButton.icon(
        onPressed: () => _showAddQCDialog(context, db),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
        icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
        label: const Text('تسجيل فحص جودة جديد', style: TextStyle(fontSize: 12)),
      ),
      columns: const [
        DataColumnSpec(title: 'رقم الفحص', width: 100),
        DataColumnSpec(title: 'أمر الإنتاج', width: 120),
        DataColumnSpec(title: 'المقاسات الفعلية (سم)', width: 160),
        DataColumnSpec(title: 'مطابقة الوصفة BOM', width: 120),
        DataColumnSpec(title: 'سلامة التجميع', width: 110),
        DataColumnSpec(title: 'الكمية المقبولة', width: 100),
        DataColumnSpec(title: 'الكمية المرفوضة', width: 100),
        DataColumnSpec(title: 'قرار الجودة', width: 110),
      ],
      items: db.qualityChecks,
      rowBuilder: (q) => [
        Text(q.checkNo, style: const TextStyle(color: AppColors.accentLavender, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(q.productionOrderNo, style: const TextStyle(color: AppColors.info, fontSize: 12, fontWeight: FontWeight.bold)),
        Text('${q.actualLengthCm}x${q.actualWidthCm}x${q.actualThicknessCm}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
        StatusChip(status: q.isBomMatching ? 'مطابق' : 'غير مطابق', fontSize: 10),
        StatusChip(status: q.isAssemblyIntact ? 'سليم' : 'عالي العيوب', fontSize: 10),
        Text('${q.acceptedQty} قطعة', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
        Text('${q.rejectedQty} قطعة', style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
        StatusChip(status: q.isPassed ? 'معتمد' : 'مرفوض', fontSize: 10),
      ],
    );
  }

  void _showAddScrapDialog(BuildContext context, MockDatabase db) {
    final materialCtrl = TextEditingController(text: 'ألواح خشب موسكي 120سم');
    final qtyCtrl = TextEditingController(text: '25');
    final reasonCtrl = TextEditingController(text: 'عقد طبيعية وشروخ');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل هالك خامات جديد', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: materialCtrl, decoration: const InputDecoration(labelText: 'اسم الخامة / المكون')),
              const SizedBox(height: 12),
              TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'الكمية التالفة *'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: reasonCtrl, decoration: const InputDecoration(labelText: 'سبب الهالك / المرحلة')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              db.addScrapLog(
                ScrapLog(
                  id: 'SCRAP-${DateTime.now().millisecondsSinceEpoch}',
                  logNo: 'SCR-2026-0${db.scrapLogs.length + 15}',
                  productionOrderNo: 'PROD-2026-088',
                  materialName: materialCtrl.text,
                  scrapType: 'قصاصات تقطيع',
                  quantity: double.tryParse(qtyCtrl.text) ?? 25,
                  unit: 'قطعة',
                  reason: reasonCtrl.text,
                  stage: 'تقطيع الخشب',
                  recordedBy: 'فني الجودة',
                  date: DateTime.now(),
                  isReusable: true,
                ),
              );
              Navigator.pop(ctx);
            },
            child: const Text('تسجيل الهالك'),
          ),
        ],
      ),
    );
  }

  void _showAddQCDialog(BuildContext context, MockDatabase db) {
    final acceptedCtrl = TextEditingController(text: '300');
    final rejectedCtrl = TextEditingController(text: '5');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل فحص جودة جديد (QC)', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: acceptedCtrl, decoration: const InputDecoration(labelText: 'الكمية المقبولة (بالتة) *'), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              TextField(controller: rejectedCtrl, decoration: const InputDecoration(labelText: 'الكمية المرفوضة *'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              db.addQualityCheck(
                QualityCheck(
                  id: 'QC-${DateTime.now().millisecondsSinceEpoch}',
                  checkNo: 'QC-2026-0${db.qualityChecks.length + 50}',
                  productionOrderNo: 'PROD-2026-088',
                  actualLengthCm: 120.0,
                  actualWidthCm: 100.0,
                  actualThicknessCm: 14.5,
                  isBomMatching: true,
                  isAssemblyIntact: true,
                  acceptedQty: int.tryParse(acceptedCtrl.text) ?? 300,
                  rejectedQty: int.tryParse(rejectedCtrl.text) ?? 5,
                  rejectionReason: 'مسامير غير منتظمة',
                  inspectedBy: 'م. رامي حلمي',
                  date: DateTime.now(),
                  isPassed: true,
                ),
              );
              Navigator.pop(ctx);
            },
            child: const Text('اعتماد الفحص'),
          ),
        ],
      ),
    );
  }
}
