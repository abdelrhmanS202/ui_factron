import 'package:flutter/material.dart';
import '../models/erp_models.dart';

/// Central In-Memory Demo Database & State Management Store for Wood Pallet ERP
class MockDatabase extends ChangeNotifier {
  // Active Navigation Route
  String _activeRouteName = 'dashboard';
  String get activeRouteName => _activeRouteName;

  void setActiveRoute(String routeName) {
    _activeRouteName = routeName;
    notifyListeners();
  }

  // Dashboard Filters
  String selectedPeriod = 'هذا الشهر';
  String selectedProductFilter = 'الكل';

  void updateDashboardPeriod(String period) {
    selectedPeriod = period;
    notifyListeners();
  }

  void updateDashboardProductFilter(String product) {
    selectedProductFilter = product;
    notifyListeners();
  }

  // Search & Global Filter
  String globalSearchQuery = '';
  void updateGlobalSearch(String query) {
    globalSearchQuery = query;
    notifyListeners();
  }

  // --- MOCK DATASETS ---

  // 1. Customers
  final List<Customer> customers = [
    Customer(
      id: 'CUST-001',
      code: 'C-1001',
      name: 'شركة جهينة للصناعات الغذائية',
      phone: '01001234567',
      address: 'المنطقة الصناعية - 6 أكتوبر',
      customerType: 'شركات كبرى',
      balance: 145000.0,
      totalSales: 890000.0,
      lastTransaction: DateTime.now().subtract(const Duration(days: 2)),
      notes: 'عميل رئيسي للبالتات المقواة 120x100',
    ),
    Customer(
      id: 'CUST-002',
      code: 'C-1002',
      name: 'مجموعة توشيبا العربي',
      phone: '01112345678',
      address: 'المنطقة الصناعية - بنها',
      customerType: 'شركات كبرى',
      balance: 210000.0,
      totalSales: 1420000.0,
      lastTransaction: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'تطلب بالتات معالجة حرارياً ISPM 15',
    ),
    Customer(
      id: 'CUST-003',
      code: 'C-1003',
      name: 'الشركة المصرية للصادرات الزراعية',
      phone: '01223456789',
      address: 'مدينة الصالحية الجديدة',
      customerType: 'تجار ومصدرون',
      balance: 65000.0,
      totalSales: 510000.0,
      lastTransaction: DateTime.now().subtract(const Duration(days: 5)),
      notes: 'بالتات خفيفة للتصدير المباشر',
    ),
    Customer(
      id: 'CUST-004',
      code: 'C-1004',
      name: 'مصنع الشرق للأدوية',
      phone: '01098765432',
      address: 'العاشر من رمضان',
      customerType: 'شركات متوسطة',
      balance: 0.0,
      totalSales: 340000.0,
      lastTransaction: DateTime.now().subtract(const Duration(days: 10)),
      notes: 'بالتات بلاستيك خشب هجين',
    ),
    Customer(
      id: 'CUST-005',
      code: 'C-1005',
      name: 'سلاسل النيل للتوزيع واللوجستيات',
      phone: '01551122334',
      address: 'طريق مصر الإسكندرية الصحراوي',
      customerType: 'لوجستيات',
      balance: 92000.0,
      totalSales: 680000.0,
      lastTransaction: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  void addCustomer(Customer c) {
    customers.insert(0, c);
    addNotification('عميل جديد', 'تم إضافة العميل ${c.name} بنجاح', 'success');
    notifyListeners();
  }

  void updateCustomer(Customer c) {
    final idx = customers.indexWhere((element) => element.id == c.id);
    if (idx != -1) {
      customers[idx] = c;
      notifyListeners();
    }
  }

  // 2. Standard Pallet Catalog & Recipes
  final List<PalletProduct> readyProducts = [
    PalletProduct(
      id: 'PROD-001',
      code: 'PAL-EUR-120100',
      name: 'بالتة يورو قياسية (Heavy Duty)',
      dimensions: '120 × 100 سم',
      bomComponents: [
        BOMComponent(id: 'BOM-1', materialName: 'ألواح خشب موسكي 120سم × 10سم', unit: 'قطعة', quantityPerUnit: 5, wastageRatioPercent: 4.0, unitCost: 45.0),
        BOMComponent(id: 'BOM-2', materialName: 'ألواح خشب موسكي 100سم × 10سم', unit: 'قطعة', quantityPerUnit: 3, wastageRatioPercent: 4.0, unitCost: 38.0),
        BOMComponent(id: 'BOM-3', materialName: 'عروق خشب زوان 10 × 10سم', unit: 'قطعة', quantityPerUnit: 9, wastageRatioPercent: 2.0, unitCost: 22.0),
        BOMComponent(id: 'BOM-4', materialName: 'مسامير حلزونية مجلفنة 7سم', unit: 'قطعة', quantityPerUnit: 60, wastageRatioPercent: 1.0, unitCost: 0.85),
      ],
      laborCostPerUnit: 35.0,
      overheadCostPerUnit: 25.0,
      sellingPrice: 720.0,
      stockQty: 420,
      reorderPoint: 100,
      status: 'متوفر',
    ),
    PalletProduct(
      id: 'PROD-002',
      code: 'PAL-EXP-12080',
      name: 'بالتة تصدير خفيفة (Light Export)',
      dimensions: '120 × 80 سم',
      bomComponents: [
        BOMComponent(id: 'BOM-5', materialName: 'ألواح خشب بيتش باين 120سم × 8سم', unit: 'قطعة', quantityPerUnit: 4, wastageRatioPercent: 5.0, unitCost: 32.0),
        BOMComponent(id: 'BOM-6', materialName: 'ألواح خشب 80سم × 8سم', unit: 'قطعة', quantityPerUnit: 3, wastageRatioPercent: 5.0, unitCost: 24.0),
        BOMComponent(id: 'BOM-7', materialName: 'عروق خشبية 8 × 8سم', unit: 'قطعة', quantityPerUnit: 6, wastageRatioPercent: 3.0, unitCost: 16.0),
        BOMComponent(id: 'BOM-8', materialName: 'مسامير صلب 6سم', unit: 'قطعة', quantityPerUnit: 48, wastageRatioPercent: 1.0, unitCost: 0.70),
      ],
      laborCostPerUnit: 28.0,
      overheadCostPerUnit: 20.0,
      sellingPrice: 480.0,
      stockQty: 180,
      reorderPoint: 80,
      status: 'متوفر',
    ),
    PalletProduct(
      id: 'PROD-003',
      code: 'PAL-CP3-114114',
      name: 'بالتة كيماويات حوامل (Chemical CP3)',
      dimensions: '114 × 114 سم',
      bomComponents: [
        BOMComponent(id: 'BOM-9', materialName: 'ألواح سميكة 114سم × 12سم', unit: 'قطعة', quantityPerUnit: 6, wastageRatioPercent: 3.0, unitCost: 52.0),
        BOMComponent(id: 'BOM-10', materialName: 'عروق خشبية مربعة 10سم', unit: 'قطعة', quantityPerUnit: 9, wastageRatioPercent: 2.0, unitCost: 28.0),
        BOMComponent(id: 'BOM-11', materialName: 'مسامير هيدروليك ممتازة', unit: 'قطعة', quantityPerUnit: 72, wastageRatioPercent: 1.0, unitCost: 0.95),
      ],
      laborCostPerUnit: 42.0,
      overheadCostPerUnit: 30.0,
      sellingPrice: 890.0,
      stockQty: 65,
      reorderPoint: 50,
      status: 'مخزون منخفض',
    ),
  ];

  void addPalletProduct(PalletProduct p) {
    readyProducts.insert(0, p);
    addNotification('منتج جديد', 'تم إضافة المنتج ${p.name} لقائمة المنتجات', 'info');
    notifyListeners();
  }

  // 3. Customer Orders
  final List<CustomerOrder> customerOrders = [
    CustomerOrder(
      id: 'ORD-101',
      orderNo: 'ORD-2026-001',
      customerId: 'CUST-001',
      customerName: 'شركة جهينة للصناعات الغذائية',
      orderDate: DateTime.now().subtract(const Duration(days: 4)),
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 3)),
      status: 'قيد الإنتاج',
      isCustom: false,
      palletProductId: 'PROD-001',
      palletName: 'بالتة يورو قياسية (Heavy Duty)',
      dimensions: '120 × 100 سم',
      quantity: 500,
      bomItems: [
        BOMComponent(id: 'B1', materialName: 'ألواح 120سم', unit: 'قطعة', quantityPerUnit: 5, unitCost: 45.0),
        BOMComponent(id: 'B2', materialName: 'عروق 10x10', unit: 'قطعة', quantityPerUnit: 9, unitCost: 22.0),
        BOMComponent(id: 'B3', materialName: 'مسامير 7سم', unit: 'قطعة', quantityPerUnit: 60, unitCost: 0.85),
      ],
      materialsCost: 237250.0,
      laborCost: 17500.0,
      overheadCost: 12500.0,
      scrapCost: 10250.0,
      totalCost: 277500.0,
      unitCost: 555.0,
      unitPrice: 720.0,
      totalAmount: 360000.0,
      paidAmount: 180000.0,
      notes: 'الطلب يتطلب معالجة حرارية وختم ISPM15',
    ),
    CustomerOrder(
      id: 'ORD-102',
      orderNo: 'ORD-2026-002',
      customerId: 'CUST-002',
      customerName: 'مجموعة توشيبا العربي',
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 6)),
      status: 'معتمد',
      isCustom: true,
      palletProductId: 'CUSTOM-01',
      palletName: 'بالتة أجهزة منزلية ثقيلة (مخصصة)',
      dimensions: '140 × 110 سم',
      quantity: 300,
      bomItems: [
        BOMComponent(id: 'BC1', materialName: 'ألواح خشب زوان 140سم', unit: 'قطعة', quantityPerUnit: 6, unitCost: 58.0),
        BOMComponent(id: 'BC2', materialName: 'عروق خشبية 110سم', unit: 'قطعة', quantityPerUnit: 9, unitCost: 35.0),
        BOMComponent(id: 'BC3', materialName: 'مسامير صلب 8سم', unit: 'قطعة', quantityPerUnit: 80, unitCost: 1.10),
      ],
      materialsCost: 225300.0,
      laborCost: 13500.0,
      overheadCost: 9000.0,
      scrapCost: 8100.0,
      totalCost: 255900.0,
      unitCost: 853.0,
      unitPrice: 1050.0,
      totalAmount: 315000.0,
      paidAmount: 105000.0,
      notes: 'تصميم خاص لحمل الأجهزة الثقيلة',
    ),
    CustomerOrder(
      id: 'ORD-103',
      orderNo: 'ORD-2026-003',
      customerId: 'CUST-003',
      customerName: 'الشركة المصرية للصادرات الزراعية',
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 2)),
      status: 'جاهز للتسليم',
      isCustom: false,
      palletProductId: 'PROD-002',
      palletName: 'بالتة تصدير خفيفة (Light Export)',
      dimensions: '120 × 80 سم',
      quantity: 1000,
      bomItems: [
        BOMComponent(id: 'B4', materialName: 'ألواح 120سم', unit: 'قطعة', quantityPerUnit: 4, unitCost: 32.0),
        BOMComponent(id: 'B5', materialName: 'مسامير 6سم', unit: 'قطعة', quantityPerUnit: 48, unitCost: 0.70),
      ],
      materialsCost: 315000.0,
      laborCost: 28000.0,
      overheadCost: 20000.0,
      scrapCost: 12000.0,
      totalCost: 375000.0,
      unitCost: 375.0,
      unitPrice: 480.0,
      totalAmount: 480000.0,
      paidAmount: 480000.0,
      notes: 'دفع كامل عند الجاهزية',
    ),
  ];

  void addCustomerOrder(CustomerOrder order) {
    customerOrders.insert(0, order);
    // Automatically create a corresponding Production Order
    final prodOrder = ProductionOrder(
      id: 'PROD-ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      orderNo: 'PROD-2026-0${productionOrders.length + 101}',
      customerOrderNo: order.orderNo,
      productName: order.palletName,
      plannedQty: order.quantity,
      startDate: DateTime.now(),
      endDate: order.expectedDeliveryDate,
      supervisor: 'المهندس أحمد محمود',
      stage: 'حجز خامات',
      bomItems: order.bomItems,
      status: 'قيد التنفيذ',
    );
    productionOrders.insert(0, prodOrder);

    addNotification(
      'طلب جديد وأمر إنتاج',
      'تم إنشاء الطلب ${order.orderNo} وأمر الإنتاج ${prodOrder.orderNo} للعميل ${order.customerName}',
      'success',
    );
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final idx = customerOrders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      customerOrders[idx].status = newStatus;
      addNotification('تحديث حالة الطلب', 'تم تغيير حالة الطلب ${customerOrders[idx].orderNo} إلى $newStatus', 'info');
      notifyListeners();
    }
  }

  // 4. Inventory Raw Materials
  final List<InventoryItem> rawMaterials = [
    InventoryItem(
      id: 'RAW-001',
      code: 'WOOD-MOS-120',
      name: 'ألواح خشب موسكي 120 × 10 × 2.2 سم',
      category: 'ألواح خشب',
      lengthCm: 120,
      widthCm: 10,
      thicknessCm: 2.2,
      unit: 'قطعة',
      availableStock: 14200,
      reservedStock: 2500,
      wipStock: 1200,
      avgUnitCost: 45.0,
      minStockLevel: 3000,
      warehouseLocation: 'مخزن الخامات أ - رصيف 1',
    ),
    InventoryItem(
      id: 'RAW-002',
      code: 'WOOD-ZOW-100',
      name: 'عروق خشب زوان مربعة 10 × 10 × 10 سم',
      category: 'عروق خشبية',
      lengthCm: 10,
      widthCm: 10,
      thicknessCm: 10,
      unit: 'قطعة',
      availableStock: 8900,
      reservedStock: 1800,
      wipStock: 900,
      avgUnitCost: 22.0,
      minStockLevel: 2000,
      warehouseLocation: 'مخزن الخامات أ - رصيف 3',
    ),
    InventoryItem(
      id: 'RAW-003',
      code: 'NAIL-GALV-70',
      name: 'مسامير صلب حلزونية مجلفنة 7 سم',
      category: 'مسامير ومثبتات',
      lengthCm: 7,
      widthCm: 0.4,
      thicknessCm: 0.4,
      unit: 'قطعة',
      availableStock: 125000,
      reservedStock: 30000,
      wipStock: 15000,
      avgUnitCost: 0.85,
      minStockLevel: 25000,
      warehouseLocation: 'مخزن المهمات ب',
    ),
    InventoryItem(
      id: 'RAW-004',
      code: 'WOOD-PINE-80',
      name: 'ألواح خشب بيتش باين 80 × 8 × 2 سم',
      category: 'ألواح خشب',
      lengthCm: 80,
      widthCm: 8,
      thicknessCm: 2.0,
      unit: 'قطعة',
      availableStock: 1800, // Low stock
      reservedStock: 1200,
      wipStock: 500,
      avgUnitCost: 24.0,
      minStockLevel: 2500,
      warehouseLocation: 'مخزن الخامات ج',
    ),
    InventoryItem(
      id: 'RAW-005',
      code: 'SCRAP-REUSE-01',
      name: 'قصاصات خشب قابلة لإعادة التدوير',
      category: 'هالك ومخلفات',
      lengthCm: 40,
      widthCm: 8,
      thicknessCm: 2,
      unit: 'متر مكعب',
      availableStock: 35,
      avgUnitCost: 1200.0,
      minStockLevel: 10,
      warehouseLocation: 'مخزن الهالك والفرز',
    ),
  ];

  void addRawMaterial(InventoryItem item) {
    rawMaterials.insert(0, item);
    notifyListeners();
  }

  // Stock Movements
  final List<StockMovement> stockMovements = [
    StockMovement(
      id: 'MOV-1001',
      itemCode: 'WOOD-MOS-120',
      itemName: 'ألواح خشب موسكي 120 سم',
      movementType: 'إذن صرف للتصنيع',
      quantity: 2500,
      unit: 'قطعة',
      fromWarehouse: 'مخزن الخامات A',
      toWarehouse: 'مخزن تحت التشغيل WIP',
      refOrderNo: 'PROD-2026-088',
      date: DateTime.now().subtract(const Duration(hours: 4)),
      actorName: 'أحمد سعيد - أمين المخزن',
    ),
    StockMovement(
      id: 'MOV-1002',
      itemCode: 'NAIL-GALV-70',
      itemName: 'مسامير صلب 7سم',
      movementType: 'إذن صرف للتصنيع',
      quantity: 30000,
      unit: 'قطعة',
      fromWarehouse: 'مخزن المهمات B',
      toWarehouse: 'مخزن تحت التشغيل WIP',
      refOrderNo: 'PROD-2026-088',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      actorName: 'أحمد سعيد - أمين المخزن',
    ),
    StockMovement(
      id: 'MOV-1003',
      itemCode: 'PAL-EXP-12080',
      itemName: 'بالتة تصدير خفيفة',
      movementType: 'إذن إضافة منتج تام',
      quantity: 1000,
      unit: 'بالتة',
      fromWarehouse: 'خط الإنتاج والجمع',
      toWarehouse: 'مخزن المنتجات التامة',
      refOrderNo: 'PROD-2026-085',
      date: DateTime.now().subtract(const Duration(days: 1)),
      actorName: 'محمود رفعت - مشرف الجودة',
    ),
  ];

  void addStockMovement(StockMovement m) {
    stockMovements.insert(0, m);
    notifyListeners();
  }

  // 5. Production Orders & Stages
  final List<ProductionOrder> productionOrders = [
    ProductionOrder(
      id: 'PROD-01',
      orderNo: 'PROD-2026-088',
      customerOrderNo: 'ORD-2026-001',
      productName: 'بالتة يورو قياسية 120×100',
      plannedQty: 500,
      producedQty: 320,
      rejectedQty: 8,
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 2)),
      supervisor: 'م. إبراهيم الخولي',
      stage: 'تجميع وتسمير',
      bomItems: [],
      status: 'قيد التنفيذ',
    ),
    ProductionOrder(
      id: 'PROD-02',
      orderNo: 'PROD-2026-089',
      customerOrderNo: 'ORD-2026-002',
      productName: 'بالتة أجهزة منزلية مخصصة',
      plannedQty: 300,
      producedQty: 50,
      rejectedQty: 2,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      supervisor: 'م. حسام الدين',
      stage: 'تقطيع الخشب',
      bomItems: [],
      status: 'قيد التنفيذ',
    ),
    ProductionOrder(
      id: 'PROD-03',
      orderNo: 'PROD-2026-085',
      customerOrderNo: 'ORD-2026-003',
      productName: 'بالتة تصدير خفيفة 120×80',
      plannedQty: 1000,
      producedQty: 1000,
      rejectedQty: 15,
      startDate: DateTime.now().subtract(const Duration(days: 4)),
      endDate: DateTime.now().subtract(const Duration(days: 1)),
      supervisor: 'م. إبراهيم الخولي',
      stage: 'تام بالمخزن',
      bomItems: [],
      status: 'مكتمل',
    ),
  ];

  void updateProductionStage(String orderId, String newStage, int newProducedQty) {
    final idx = productionOrders.indexWhere((p) => p.id == orderId);
    if (idx != -1) {
      productionOrders[idx].stage = newStage;
      productionOrders[idx].producedQty = newProducedQty;
      if (newProducedQty >= productionOrders[idx].plannedQty) {
        productionOrders[idx].status = 'مكتمل';
      }
      addNotification('تحديث مرحلة الإنتاج', 'أمر الإنتاج ${productionOrders[idx].orderNo} انتقل لمرحلة $newStage', 'info');
      notifyListeners();
    }
  }

  // 6. Scrap Logs (سجل الهالك)
  final List<ScrapLog> scrapLogs = [
    ScrapLog(
      id: 'SCRAP-001',
      logNo: 'SCR-2026-012',
      productionOrderNo: 'PROD-2026-088',
      materialName: 'ألواح خشب موسكي 120سم',
      scrapType: 'قصاصات تقطيع جافة',
      quantity: 120,
      unit: 'قطعة',
      reason: 'عقد خشبية وشروخ طبيعية في العرق',
      stage: 'تقطيع الخشب',
      recordedBy: 'فني التقطيع حسن علي',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      isReusable: true,
    ),
    ScrapLog(
      id: 'SCRAP-002',
      logNo: 'SCR-2026-013',
      productionOrderNo: 'PROD-2026-088',
      materialName: 'عروق زوان 10x10',
      scrapType: 'هالك غير قابل للاستخدام',
      quantity: 15,
      unit: 'قطعة',
      reason: 'كسر أثناء التسمير الهيدروليكي',
      stage: 'تجميع وتسمير',
      recordedBy: 'فني التجميع خالد كمال',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      isReusable: false,
    ),
  ];

  void addScrapLog(ScrapLog log) {
    scrapLogs.insert(0, log);
    addNotification('تسجيل هالك', 'تم تسجيل هالك جديد برقم ${log.logNo} على أمر ${log.productionOrderNo}', 'warning');
    notifyListeners();
  }

  // 7. Quality Checks
  final List<QualityCheck> qualityChecks = [
    QualityCheck(
      id: 'QC-101',
      checkNo: 'QC-2026-045',
      productionOrderNo: 'PROD-2026-088',
      actualLengthCm: 120.1,
      actualWidthCm: 99.9,
      actualThicknessCm: 14.4,
      isBomMatching: true,
      isAssemblyIntact: true,
      acceptedQty: 312,
      rejectedQty: 8,
      rejectionReason: 'تباعد غير منتظم بين المسامير',
      inspectedBy: 'م. رامي حلمي - رئيس الجودة',
      date: DateTime.now().subtract(const Duration(hours: 1)),
      isPassed: true,
    ),
  ];

  void addQualityCheck(QualityCheck qc) {
    qualityChecks.insert(0, qc);
    addNotification('فحص جودة', 'تم اعتماد فحص الجودة ${qc.checkNo} - القبول: ${qc.acceptedQty} قطعة', 'success');
    notifyListeners();
  }

  // 8. Suppliers & Purchase Orders
  final List<Supplier> suppliers = [
    Supplier(
      id: 'SUP-01',
      code: 'S-2001',
      name: 'شركة الأهرام لاستيراد الأخشاب',
      phone: '01011122233',
      address: 'ميناء دمياط - المنطقة اللوجستية',
      suppliedCategory: 'أخشاب موسكي وزوان سويدي',
      totalPurchases: 2450000.0,
      debtBalance: 320000.0,
      lastDealDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Supplier(
      id: 'SUP-02',
      code: 'S-2002',
      name: 'مصنع النيل للمسامير والمهمات',
      phone: '01233344455',
      address: 'العاشر من رمضان - C3',
      suppliedCategory: 'مسامير صلبه ومجلفنة',
      totalPurchases: 420000.0,
      debtBalance: 45000.0,
      lastDealDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  final List<PurchaseOrder> purchaseOrders = [
    PurchaseOrder(
      id: 'PO-01',
      poNo: 'PO-2026-050',
      supplierName: 'شركة الأهرام لاستيراد الأخشاب',
      orderDate: DateTime.now().subtract(const Duration(days: 5)),
      expectedDate: DateTime.now().add(const Duration(days: 2)),
      materialName: 'شحنة أخشاب موسكي 120سم (50 متر مكعب)',
      quantity: 50,
      unit: 'متر مكعب',
      totalAmount: 480000.0,
      status: 'قيد التوريد',
    ),
  ];

  void addSupplier(Supplier s) {
    suppliers.insert(0, s);
    notifyListeners();
  }

  void addPurchaseOrder(PurchaseOrder po) {
    purchaseOrders.insert(0, po);
    addNotification('أمر شراء', 'تم إنشاء أمر الشراء ${po.poNo} بقيمة ${po.totalAmount} ج.م', 'info');
    notifyListeners();
  }

  // 9. Sales Invoices & Receipts
  final List<SalesInvoice> invoices = [
    SalesInvoice(
      id: 'INV-01',
      invoiceNo: 'INV-2026-101',
      customerName: 'شركة جهينة للصناعات الغذائية',
      orderNo: 'ORD-2026-001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      palletName: 'بالتة يورو قياسية 120x100',
      quantity: 500,
      unitPrice: 720.0,
      subtotal: 360000.0,
      discount: 0.0,
      tax: 0.0,
      grandTotal: 360000.0,
      paidAmount: 180000.0,
      paymentStatus: 'مدفوعة جزئياً',
    ),
    SalesInvoice(
      id: 'INV-02',
      invoiceNo: 'INV-2026-102',
      customerName: 'الشركة المصرية للصادرات الزراعية',
      orderNo: 'ORD-2026-003',
      date: DateTime.now().subtract(const Duration(days: 1)),
      palletName: 'بالتة تصدير خفيفة 120x80',
      quantity: 1000,
      unitPrice: 480.0,
      subtotal: 480000.0,
      discount: 0.0,
      tax: 0.0,
      grandTotal: 480000.0,
      paidAmount: 480000.0,
      paymentStatus: 'مدفوعة بالكامل',
    ),
  ];

  void recordPaymentForInvoice(String invoiceId, double paymentAmount) {
    final idx = invoices.indexWhere((i) => i.id == invoiceId);
    if (idx != -1) {
      final inv = invoices[idx];
      inv.paidAmount += paymentAmount;
      if (inv.paidAmount >= inv.grandTotal) {
        inv.paymentStatus = 'مدفوعة بالكامل';
      } else {
        inv.paymentStatus = 'مدفوعة جزئياً';
      }
      addNotification('تحصيل مبلغ', 'تم تسجيل تحصيل مبلغ $paymentAmount ج.م للفاتورة ${inv.invoiceNo}', 'success');
      notifyListeners();
    }
  }

  // 10. Expenses & Financial Vouchers
  final List<ExpenseItem> expenses = [
    ExpenseItem(
      id: 'EXP-01',
      expenseNo: 'EXP-2026-021',
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'كهرباء وطاقة المصنع',
      amount: 42000.0,
      paymentAccount: 'الحساب البنكي - بنك مصر',
      description: 'فاتورة استهلاك الكهرباء لورش التقطيع والتسمير',
    ),
    ExpenseItem(
      id: 'EXP-02',
      expenseNo: 'EXP-2026-022',
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'صيانة ماكينات',
      amount: 18500.0,
      paymentAccount: 'الخزينة الرئيسية',
      description: 'تغيير سلاسل المنشار الرئيسي وقطع غيار الهيدروليك',
    ),
  ];

  void addExpense(ExpenseItem exp) {
    expenses.insert(0, exp);
    notifyListeners();
  }

  // 11. Employees & Productivity
  final List<Employee> employees = [
    Employee(
      id: 'EMP-01',
      code: 'E-101',
      name: 'م. إبراهيم الخولي',
      jobTitle: 'مدير خط الإنتاج',
      department: 'الإنتاج والورش',
      phone: '01009876543',
      hireDate: DateTime(2022, 3, 15),
      basicSalary: 22000.0,
      status: 'على رأس العمل',
      attendanceStatus: 'حاضر',
    ),
    Employee(
      id: 'EMP-02',
      code: 'E-102',
      name: 'حسن علي محمود',
      jobTitle: 'فني تقطيع رئيسي',
      department: 'ورشه التقطيع',
      phone: '01118765432',
      hireDate: DateTime(2023, 1, 10),
      basicSalary: 11000.0,
      status: 'على رأس العمل',
      attendanceStatus: 'حاضر',
    ),
    Employee(
      id: 'EMP-03',
      code: 'E-103',
      name: 'خالد كمال عثمان',
      jobTitle: 'فني تجميع وتسمير',
      department: 'ورشه التجميع',
      phone: '01227654321',
      hireDate: DateTime(2023, 6, 1),
      basicSalary: 9500.0,
      status: 'على رأس العمل',
      attendanceStatus: 'حاضر',
    ),
    Employee(
      id: 'EMP-04',
      code: 'E-104',
      name: 'أحمد سعيد عبد السلام',
      jobTitle: 'أمين مخزن الخامات',
      department: 'إدارة المخازن',
      phone: '01556543210',
      hireDate: DateTime(2021, 11, 20),
      basicSalary: 13500.0,
      status: 'على رأس العمل',
      attendanceStatus: 'حاضر',
    ),
  ];

  final List<WorkerProductivity> workerProductivityList = [
    WorkerProductivity(workerName: 'حسن علي (ورشه التقطيع)', productionOrderNo: 'PROD-2026-088', unitsCompleted: 450, timeSpentHours: 7.5, rejectedUnits: 5),
    WorkerProductivity(workerName: 'خالد كمال (ورشه التجميع)', productionOrderNo: 'PROD-2026-088', unitsCompleted: 320, timeSpentHours: 8.0, rejectedUnits: 8),
  ];

  // 12. Machines & Maintenance
  final List<MachineAsset> machines = [
    MachineAsset(
      id: 'MCH-01',
      code: 'MAC-CUT-01',
      name: 'منشار تقطيع متعدد أقراص (Heavy Multi-Rip)',
      type: 'منشار أخشاب',
      location: 'عنبر التقطيع الرئيسي A',
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 15)),
      nextMaintenanceDate: DateTime.now().add(const Duration(days: 15)),
      status: 'تعمل بكفاءة',
    ),
    MachineAsset(
      id: 'MCH-02',
      code: 'MAC-NAIL-02',
      name: 'ماكينة تسمير هيدروليكية أوتوماتيكية',
      type: 'ماكينة تجميع',
      location: 'عنبر التجميع B',
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 30)),
      nextMaintenanceDate: DateTime.now().add(const Duration(days: 2)),
      status: 'تحتاج صيانة وقائية',
    ),
  ];

  // 13. System Notifications
  final List<SystemNotification> notifications = [
    SystemNotification(
      id: 'NOTIF-01',
      title: 'تنبيه مخزون منخفض',
      message: 'وصل خشب البيتش باين 80سم إلى 1,800 قطعة (الحد الأدنى 2,500)',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: 'warning',
    ),
    SystemNotification(
      id: 'NOTIF-02',
      title: 'طلب إنتاج جديد متأخر',
      message: 'أمر الإنتاج PROD-2026-089 يحتاج لزيادة معدل التقطيع',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'error',
    ),
    SystemNotification(
      id: 'NOTIF-03',
      title: 'تم استلام الدفعة الأولى',
      message: 'شركة جهينة سددت 180,000 ج.م لحساب الطلب ORD-2026-001',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      type: 'success',
    ),
  ];

  void addNotification(String title, String message, String type) {
    notifications.insert(
      0,
      SystemNotification(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        message: message,
        timestamp: DateTime.now(),
        type: type,
      ),
    );
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  // 14. Roles & Permissions Matrix
  final List<UserRole> roles = [
    UserRole(
      roleName: 'owner',
      roleTitle: 'مالك المصنع',
      permissions: {'view': true, 'add': true, 'edit': true, 'delete': true, 'approve': true, 'export': true, 'print': true},
    ),
    UserRole(
      roleName: 'manager',
      roleTitle: 'مدير المصنع',
      permissions: {'view': true, 'add': true, 'edit': true, 'delete': false, 'approve': true, 'export': true, 'print': true},
    ),
    UserRole(
      roleName: 'accountant',
      roleTitle: 'المحاسب المالي',
      permissions: {'view': true, 'add': true, 'edit': true, 'delete': false, 'approve': true, 'export': true, 'print': true},
    ),
    UserRole(
      roleName: 'inventory_mgr',
      roleTitle: 'مسؤول المخازن',
      permissions: {'view': true, 'add': true, 'edit': true, 'delete': false, 'approve': false, 'export': true, 'print': true},
    ),
    UserRole(
      roleName: 'production_sup',
      roleTitle: 'مشرف الإنتاج',
      permissions: {'view': true, 'add': true, 'edit': true, 'delete': false, 'approve': false, 'export': false, 'print': true},
    ),
    UserRole(
      roleName: 'qc_mgr',
      roleTitle: 'مسؤول الجودة',
      permissions: {'view': true, 'add': true, 'edit': true, 'delete': false, 'approve': true, 'export': true, 'print': true},
    ),
  ];

  void togglePermission(String roleName, String permissionKey, bool value) {
    final role = roles.firstWhere((r) => r.roleName == roleName);
    role.permissions[permissionKey] = value;
    notifyListeners();
  }

  // Calculated Dashboard Summaries & Key Metrics
  double get totalTodaySales => 148000.0;
  double get totalMonthlySales => 1840000.0;
  double get totalMonthlyCollections => 1350000.0;
  double get totalCustomerDebt => customers.fold(0.0, (sum, c) => sum + c.balance);
  double get totalMonthlyPurchases => 920000.0;
  double get totalMonthlyExpenses => 165000.0;
  double get estimatedNetProfit => totalMonthlySales - (totalMonthlyPurchases * 0.6 + totalMonthlyExpenses);
  double get totalInventoryValue => rawMaterials.fold(0.0, (sum, i) => sum + i.totalStockValue);
  int get openProductionOrdersCount => productionOrders.where((p) => p.status == 'قيد التنفيذ').length;
  int get totalPalletsProduced => productionOrders.fold(0, (sum, p) => sum + p.producedQty);
  double get scrapPercentage => 3.8; // 3.8%
  int get delayedOrdersCount => 1;
  int get lowStockItemsCount => rawMaterials.where((r) => r.isLowStock).length;
}
