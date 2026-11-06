import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/custom_card.dart';
import '../../data/mock/mock_database.dart';
import '../../data/models/erp_models.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  int currentStep = 0;

  // Form State
  Customer? selectedCustomer;
  bool isCustomPallet = false;
  PalletProduct? selectedReadyProduct;

  // Custom Pallet Spec
  String customName = 'بالتة خشب مخصصة';
  double customLengthCm = 120.0;
  double customWidthCm = 100.0;
  int boardCount = 5;
  double boardLengthCm = 120.0;
  double boardWidthCm = 10.0;
  int runnerCount = 9;
  double runnerLengthCm = 10.0;
  int nailCount = 60;

  int quantity = 500;
  double unitPrice = 720.0;
  double discount = 0.0;
  String notes = '';

  @override
  void initState() {
    super.initState();
    final db = Provider.of<MockDatabase>(context, listen: false);
    if (db.customers.isNotEmpty) selectedCustomer = db.customers.first;
    if (db.readyProducts.isNotEmpty) selectedReadyProduct = db.readyProducts.first;
  }

  // Cost Calculations
  double get estimatedMaterialCost {
    if (!isCustomPallet && selectedReadyProduct != null) {
      return selectedReadyProduct!.totalMaterialsCost * quantity;
    }
    // Custom calculation: boards + runners + nails
    final boardCostUnit = (boardCount * 45.0);
    final runnerCostUnit = (runnerCount * 22.0);
    final nailCostUnit = (nailCount * 0.85);
    return (boardCostUnit + runnerCostUnit + nailCostUnit) * quantity;
  }

  double get estimatedLaborCost => 35.0 * quantity;
  double get estimatedOverheadCost => 25.0 * quantity;
  double get estimatedScrapCost => estimatedMaterialCost * 0.04; // 4% waste allowance
  double get totalManufacturingCost =>
      estimatedMaterialCost + estimatedLaborCost + estimatedOverheadCost + estimatedScrapCost;
  double get totalManufacturingCostPerUnit => totalManufacturingCost / quantity;

  double get totalOrderAmount => (quantity * unitPrice) - discount;
  double get estimatedProfitAmount => totalOrderAmount - totalManufacturingCost;
  double get estimatedProfitPercent =>
      totalOrderAmount > 0 ? (estimatedProfitAmount / totalOrderAmount) * 100 : 0.0;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('تسجيل طلب عميل جديد (Order Wizard)',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('دورة العرض والتكلفة وأوامر التصنيع',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => db.setActiveRoute('orders'),
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text('العودة للطلبات'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stepper Header
          Row(
            children: [
              _buildStepIndicator(0, '1. بيانات العميل'),
              _buildStepDivider(),
              _buildStepIndicator(1, '2. نوع البالتة والمواصفات'),
              _buildStepDivider(),
              _buildStepIndicator(2, '3. وصفة الخامات BOM'),
              _buildStepDivider(),
              _buildStepIndicator(3, '4. حساب التكلفة والسعر'),
              _buildStepDivider(),
              _buildStepIndicator(4, '5. التأكيد والاعتماد'),
            ],
          ),

          const SizedBox(height: 24),

          // STEP CONTENT BODY
          if (currentStep == 0) _buildStep1Customer(db),
          if (currentStep == 1) _buildStep2PalletSpec(db),
          if (currentStep == 2) _buildStep3BOMRecipe(),
          if (currentStep == 3) _buildStep4CostCalculator(),
          if (currentStep == 4) _buildStep5Review(db),

          const SizedBox(height: 24),

          // Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentStep > 0)
                OutlinedButton.icon(
                  onPressed: () => setState(() => currentStep--),
                  icon: const Icon(Icons.chevron_right_rounded, size: 18),
                  label: const Text('الخطوة السابقة'),
                )
              else
                const SizedBox(),
              if (currentStep < 4)
                ElevatedButton.icon(
                  onPressed: () => setState(() => currentStep++),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPurple),
                  icon: const Icon(Icons.chevron_left_rounded, size: 18),
                  label: const Text('التالي: المواصفات والتكلفة'),
                )
              else
                ElevatedButton.icon(
                  onPressed: () => _confirmAndSaveOrder(db),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('اعتماد الطلب وإنشاء أمر الإنتاج'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = currentStep == stepIndex;
    final isDone = currentStep > stepIndex;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPurple : (isDone ? AppColors.secondarySurface : AppColors.cardSurface),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isActive ? AppColors.accentLavender : AppColors.border),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive || isDone ? Colors.white : AppColors.textMuted,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStepDivider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Icon(Icons.chevron_left_rounded, size: 14, color: AppColors.textMuted),
      );

  // STEP 1: Customer Selection
  Widget _buildStep1Customer(MockDatabase db) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('اختر العميل المسجل في النظام', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<Customer>(
            value: selectedCustomer,
            decoration: const InputDecoration(labelText: 'اسم العميل / الشركة *'),
            dropdownColor: AppColors.cardSurface,
            items: db.customers
                .map((c) => DropdownMenuItem(value: c, child: Text('${c.name} (${c.code})')))
                .toList(),
            onChanged: (val) => setState(() => selectedCustomer = val),
          ),
          if (selectedCustomer != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.secondarySurface, borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الهاتف: ${selectedCustomer!.phone}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text('العنوان: ${selectedCustomer!.address}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text('الرصيد الحالي: ${AppFormatters.formatCurrency(selectedCustomer!.balance)}',
                      style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // STEP 2: Pallet Specification (Ready vs Custom)
  Widget _buildStep2PalletSpec(MockDatabase db) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomCard(
                backgroundColor: !isCustomPallet ? AppColors.primaryPurple.withOpacity(0.3) : AppColors.cardSurface,
                onTap: () => setState(() => isCustomPallet = false),
                child: const Row(
                  children: [
                    Icon(Icons.inventory_2_rounded, color: AppColors.accentLavender),
                    SizedBox(width: 12),
                    Text('المسار A: بالتات قياسية جاهزة', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomCard(
                backgroundColor: isCustomPallet ? AppColors.primaryPurple.withOpacity(0.3) : AppColors.cardSurface,
                onTap: () => setState(() => isCustomPallet = true),
                child: const Row(
                  children: [
                    Icon(Icons.precision_manufacturing_rounded, color: AppColors.warning),
                    SizedBox(width: 12),
                    Text('المسار B: تصنيع مخصص حسب المواصفات', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (!isCustomPallet) ...[
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اختر المنتج القياسي من الكتالوج', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                DropdownButtonFormField<PalletProduct>(
                  value: selectedReadyProduct,
                  decoration: const InputDecoration(labelText: 'البالتة الجاهزة *'),
                  dropdownColor: AppColors.cardSurface,
                  items: db.readyProducts
                      .map((p) => DropdownMenuItem(value: p, child: Text('${p.name} - المقاس: ${p.dimensions}')))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedReadyProduct = val;
                      if (val != null) unitPrice = val.sellingPrice;
                    });
                  },
                ),
              ],
            ),
          ),
        ] else ...[
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مواصفات البالتة المخصصة', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'الطول (سم)'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => customLengthCm = double.tryParse(v) ?? 120.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'العرض (سم)'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => customWidthCm = double.tryParse(v) ?? 100.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'عدد الألواح العلوية'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => boardCount = int.tryParse(v) ?? 5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'عدد العروق الخشبية'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => runnerCount = int.tryParse(v) ?? 9,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'عدد المسامير'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => nailCount = int.tryParse(v) ?? 60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // STEP 3: BOM Recipe Inspection
  Widget _buildStep3BOMRecipe() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('وصفة الخامات المطلوبة للبالتة الواحدة (Bill of Materials - BOM)',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Table(
            border: TableBorder.all(color: AppColors.border),
            children: const [
              TableRow(
                decoration: BoxDecoration(color: AppColors.secondarySurface),
                children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('الخامة / المكون', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('الكمية/بالتة', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('تكلفة الوحدة', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('نسبة الهالك', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold))),
                ],
              ),
              TableRow(
                children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('ألواح خشب موسكي 120 سم', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('5 قطع', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('45 ج.م', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('4.0%', style: TextStyle(color: AppColors.warning, fontSize: 12))),
                ],
              ),
              TableRow(
                children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('عروق خشب زوان 10×10 سم', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('9 قطع', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('22 ج.م', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('2.0%', style: TextStyle(color: AppColors.warning, fontSize: 12))),
                ],
              ),
              TableRow(
                children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('مسامير صلب حلزونية 7سم', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('60 قطعة', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('0.85 ج.م', style: TextStyle(color: AppColors.textPrimary, fontSize: 12))),
                  Padding(padding: EdgeInsets.all(8), child: Text('1.0%', style: TextStyle(color: AppColors.warning, fontSize: 12))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // STEP 4: Cost & Price Calculator
  Widget _buildStep4CostCalculator() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ملخص حساب تكلفة التصنيع وسعر البيع والهامش',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'الكمية المطلوبة (عدد البالتات) *'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: quantity.toString()),
                  onChanged: (v) => setState(() => quantity = int.tryParse(v) ?? 500),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'سعر البيع النهائي للبالتة (ج.م) *'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: unitPrice.toString()),
                  onChanged: (v) => setState(() => unitPrice = double.tryParse(v) ?? 720.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.secondarySurface, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                _buildCostRow('تكلفة الخامات الإجمالية:', AppFormatters.formatCurrency(estimatedMaterialCost)),
                _buildCostRow('تكلفة العمالة المباشرة:', AppFormatters.formatCurrency(estimatedLaborCost)),
                _buildCostRow('المصروفات الصناعية والطاقة:', AppFormatters.formatCurrency(estimatedOverheadCost)),
                _buildCostRow('تكلفة الهالك المتوقع:', AppFormatters.formatCurrency(estimatedScrapCost)),
                const Divider(color: AppColors.border, height: 20),
                _buildCostRow('إجمالي تكلفة التصنيع:', AppFormatters.formatCurrency(totalManufacturingCost), isBold: true),
                _buildCostRow('تكلفة التصنيع للبالتة الواحدة:', AppFormatters.formatCurrency(totalManufacturingCostPerUnit), isBold: true, color: AppColors.accentLavender),
                _buildCostRow('إجمالي قيمة الطلب (سعر البيع):', AppFormatters.formatCurrency(totalOrderAmount), isBold: true, color: AppColors.success),
                _buildCostRow('هامش الربح التقديري:', '${AppFormatters.formatCurrency(estimatedProfitAmount)} (${estimatedProfitPercent.toStringAsFixed(1)}%)', isBold: true, color: AppColors.warning),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isBold = false, Color color = AppColors.textPrimary}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isBold ? AppColors.textPrimary : AppColors.textSecondary, fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  // STEP 5: Review & Save
  Widget _buildStep5Review(MockDatabase db) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('مراجعة بيانات الطلب والاعتماد النهائي',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('العميل', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            subtitle: Text(selectedCustomer?.name ?? 'غير محدد', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          ListTile(
            title: const Text('المنتج والمواصفة', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            subtitle: Text(
              isCustomPallet ? '$customName (120x100 سم)' : (selectedReadyProduct?.name ?? ''),
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          ListTile(
            title: const Text('الكمية والإجمالي', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            subtitle: Text('$quantity بالتة • الإجمالي: ${AppFormatters.formatCurrency(totalOrderAmount)}',
                style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void _confirmAndSaveOrder(MockDatabase db) {
    if (selectedCustomer == null) return;

    final newOrder = CustomerOrder(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      orderNo: 'ORD-2026-00${db.customerOrders.length + 1}',
      customerId: selectedCustomer!.id,
      customerName: selectedCustomer!.name,
      orderDate: DateTime.now(),
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 5)),
      status: 'معتمد',
      isCustom: isCustomPallet,
      palletProductId: selectedReadyProduct?.id ?? 'CUSTOM',
      palletName: isCustomPallet ? customName : selectedReadyProduct!.name,
      dimensions: isCustomPallet ? '$customLengthCm x $customWidthCm cm' : selectedReadyProduct!.dimensions,
      quantity: quantity,
      bomItems: [],
      materialsCost: estimatedMaterialCost,
      laborCost: estimatedLaborCost,
      overheadCost: estimatedOverheadCost,
      scrapCost: estimatedScrapCost,
      totalCost: totalManufacturingCost,
      unitCost: totalManufacturingCostPerUnit,
      unitPrice: unitPrice,
      totalAmount: totalOrderAmount,
    );

    db.addCustomerOrder(newOrder);
    db.setActiveRoute('orders');
  }
}
