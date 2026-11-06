/// Customer Model
class Customer {
  final String id;
  final String code;
  final String name;
  final String phone;
  final String address;
  final String customerType; // شركات / أفراد / تجار
  double balance; // الرصيد المستحق (مدين)
  double totalSales;
  DateTime lastTransaction;
  String status; // نشط / معلق
  String notes;

  Customer({
    required this.id,
    required this.code,
    required this.name,
    required this.phone,
    required this.address,
    required this.customerType,
    required this.balance,
    required this.totalSales,
    required this.lastTransaction,
    this.status = 'نشط',
    this.notes = '',
  });
}

/// BOM Component (خامة داخل الوصفة)
class BOMComponent {
  String id;
  String materialName; // ألواح 120سم / عروق 100سم / مسامير
  String unit; // قطعة / متر طولي / متر مكعب / كجم
  double quantityPerUnit; // الكمية المطلوبة للبالتة الواحدة
  double wastageRatioPercent; // نسبة الهالك المتوقع %
  double unitCost; // تكلفة الوحدة من الخامة

  BOMComponent({
    required this.id,
    required this.materialName,
    required this.unit,
    required this.quantityPerUnit,
    this.wastageRatioPercent = 5.0,
    required this.unitCost,
  });

  double get rawCost => quantityPerUnit * unitCost;
  double get scrapCost => rawCost * (wastageRatioPercent / 100);
  double get totalComponentCost => rawCost + scrapCost;
}

/// Ready Product / Pallet Specification
class PalletProduct {
  final String id;
  final String code;
  final String name;
  final String dimensions; // 120x100 cm
  List<BOMComponent> bomComponents;
  double laborCostPerUnit;
  double overheadCostPerUnit;
  double sellingPrice;
  int stockQty;
  int reorderPoint;
  String status; // متوفر / جار الانتاج / غير متوفر

  PalletProduct({
    required this.id,
    required this.code,
    required this.name,
    required this.dimensions,
    required this.bomComponents,
    required this.laborCostPerUnit,
    required this.overheadCostPerUnit,
    required this.sellingPrice,
    required this.stockQty,
    this.reorderPoint = 50,
    this.status = 'متوفر',
  });

  double get totalMaterialsCost =>
      bomComponents.fold(0, (sum, item) => sum + item.totalComponentCost);

  double get totalManufacturingCost =>
      totalMaterialsCost + laborCostPerUnit + overheadCostPerUnit;

  double get profitMarginAmount => sellingPrice - totalManufacturingCost;
  double get profitMarginPercent => sellingPrice > 0
      ? ((sellingPrice - totalManufacturingCost) / sellingPrice) * 100
      : 0.0;
}

/// Customer Order (طلب عميل)
class CustomerOrder {
  final String id;
  final String orderNo; // ORD-2026-001
  final String customerId;
  final String customerName;
  final DateTime orderDate;
  final DateTime expectedDeliveryDate;
  String status; // مسودة / عرض سعر / معتمد / قيد الإنتاج / جاهز للتسليم / تم التسليم / مكتمل
  final bool isCustom; // بالتة جاهزة أم تصنيع حسب الطلب
  final String palletProductId;
  final String palletName;
  final String dimensions;
  int quantity;
  List<BOMComponent> bomItems;

  // Cost & Price Breakdown
  double materialsCost;
  double laborCost;
  double overheadCost;
  double scrapCost;
  double totalCost;
  double unitCost;
  double unitPrice;
  double discount;
  double tax;
  double totalAmount;
  double paidAmount;
  String notes;

  CustomerOrder({
    required this.id,
    required this.orderNo,
    required this.customerId,
    required this.customerName,
    required this.orderDate,
    required this.expectedDeliveryDate,
    required this.status,
    required this.isCustom,
    required this.palletProductId,
    required this.palletName,
    required this.dimensions,
    required this.quantity,
    required this.bomItems,
    required this.materialsCost,
    required this.laborCost,
    required this.overheadCost,
    required this.scrapCost,
    required this.totalCost,
    required this.unitCost,
    required this.unitPrice,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.totalAmount,
    this.paidAmount = 0.0,
    this.notes = '',
  });

  double get remainingAmount => totalAmount - paidAmount;
}

/// Inventory Item / Raw Material
class InventoryItem {
  final String id;
  final String code;
  final String name;
  final String category; // ألواح / عروق / مسامير / خامات إضافية
  final double lengthCm;
  final double widthCm;
  final double thicknessCm;
  final String unit; // قطعة / متر طولي / متر مكعب
  double availableStock;
  double reservedStock;
  double wipStock;
  double avgUnitCost;
  double minStockLevel;
  String warehouseLocation;
  String preferredSupplier;

  InventoryItem({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.lengthCm,
    required this.widthCm,
    required this.thicknessCm,
    required this.unit,
    required this.availableStock,
    this.reservedStock = 0,
    this.wipStock = 0,
    required this.avgUnitCost,
    this.minStockLevel = 100,
    this.warehouseLocation = 'مخزن الخامات A',
    this.preferredSupplier = 'شركة الأهرام للأخشاب',
  });

  double get totalStockValue => availableStock * avgUnitCost;
  bool get isLowStock => availableStock <= minStockLevel;
}

/// Inventory Movement (حركة مخزنية)
class StockMovement {
  final String id;
  final String itemCode;
  final String itemName;
  final String movementType; // إذن إضافة / إذن صرف / تحويل مخزني / تسوية جرد
  final double quantity;
  final String unit;
  final String fromWarehouse;
  final String toWarehouse;
  final String refOrderNo;
  final DateTime date;
  final String actorName;

  StockMovement({
    required this.id,
    required this.itemCode,
    required this.itemName,
    required this.movementType,
    required this.quantity,
    required this.unit,
    required this.fromWarehouse,
    required this.toWarehouse,
    required this.refOrderNo,
    required this.date,
    required this.actorName,
  });
}

/// Production Order (أمر إنتاج)
class ProductionOrder {
  final String id;
  final String orderNo; // PROD-2026-088
  final String customerOrderNo;
  final String productName;
  final int plannedQty;
  int producedQty;
  int rejectedQty;
  final DateTime startDate;
  final DateTime endDate;
  final String supervisor;
  String stage; // تخطيط / حجز خامات / تقطيع / تجميع / فحص جودة / تام
  List<BOMComponent> bomItems;
  String status; // قيد التنفيذ / مكتمل / متأخر / معلق

  ProductionOrder({
    required this.id,
    required this.orderNo,
    required this.customerOrderNo,
    required this.productName,
    required this.plannedQty,
    this.producedQty = 0,
    this.rejectedQty = 0,
    required this.startDate,
    required this.endDate,
    required this.supervisor,
    required this.stage,
    required this.bomItems,
    this.status = 'قيد التنفيذ',
  });

  double get progressPercent =>
      plannedQty > 0 ? (producedQty / plannedQty) * 100 : 0.0;
}

/// Waste / Scrap Log (سجل الهالك)
class ScrapLog {
  final String id;
  final String logNo;
  final String productionOrderNo;
  final String materialName;
  final String scrapType; // قصاصات خشب / خشب تالف / أخطاء تقطيع
  final double quantity;
  final String unit;
  final String reason;
  final String stage;
  final String recordedBy;
  final DateTime date;
  final bool isReusable;

  ScrapLog({
    required this.id,
    required this.logNo,
    required this.productionOrderNo,
    required this.materialName,
    required this.scrapType,
    required this.quantity,
    required this.unit,
    required this.reason,
    required this.stage,
    required this.recordedBy,
    required this.date,
    this.isReusable = false,
  });
}

/// Quality Control Inspection (فحص الجودة)
class QualityCheck {
  final String id;
  final String checkNo;
  final String productionOrderNo;
  final double actualLengthCm;
  final double actualWidthCm;
  final double actualThicknessCm;
  final bool isBomMatching;
  final bool isAssemblyIntact;
  final int acceptedQty;
  final int rejectedQty;
  final String rejectionReason;
  final String inspectedBy;
  final DateTime date;
  final bool isPassed;

  QualityCheck({
    required this.id,
    required this.checkNo,
    required this.productionOrderNo,
    required this.actualLengthCm,
    required this.actualWidthCm,
    required this.actualThicknessCm,
    required this.isBomMatching,
    required this.isAssemblyIntact,
    required this.acceptedQty,
    required this.rejectedQty,
    required this.rejectionReason,
    required this.inspectedBy,
    required this.date,
    required this.isPassed,
  });
}

/// Supplier (مورد)
class Supplier {
  final String id;
  final String code;
  final String name;
  final String phone;
  final String address;
  final String suppliedCategory; // خشب سويدي / مسامير / زوان
  double totalPurchases;
  double debtBalance; // مستحقات المورد (دائن)
  DateTime lastDealDate;

  Supplier({
    required this.id,
    required this.code,
    required this.name,
    required this.phone,
    required this.address,
    required this.suppliedCategory,
    required this.totalPurchases,
    required this.debtBalance,
    required this.lastDealDate,
  });
}

/// Purchase Order (أمر شراء)
class PurchaseOrder {
  final String id;
  final String poNo;
  final String supplierName;
  final DateTime orderDate;
  final DateTime expectedDate;
  final String materialName;
  final double quantity;
  final String unit;
  final double totalAmount;
  String status; // معتمد / تم الاستلام / جزئي / قيد التوريد

  PurchaseOrder({
    required this.id,
    required this.poNo,
    required this.supplierName,
    required this.orderDate,
    required this.expectedDate,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.totalAmount,
    required this.status,
  });
}

/// Sales Invoice (فاتورة مبيعات)
class SalesInvoice {
  final String id;
  final String invoiceNo; // INV-2026-102
  final String customerName;
  final String orderNo;
  final DateTime date;
  final String palletName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;
  double paidAmount;
  String paymentStatus; // مدفوعة / مدفوعة جزئياً / غير مدفوعة

  SalesInvoice({
    required this.id,
    required this.invoiceNo,
    required this.customerName,
    required this.orderNo,
    required this.date,
    required this.palletName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.grandTotal,
    this.paidAmount = 0.0,
    required this.paymentStatus,
  });

  double get remainingBalance => grandTotal - paidAmount;
}

/// Expense Item (مصروف)
class ExpenseItem {
  final String id;
  final String expenseNo;
  final DateTime date;
  final String category; // أجور / كهرباء / صيانة / شحن / إيجار / مصاريف إدارية
  final double amount;
  final String paymentAccount; // خزينة رئيسية / بنك مصر
  final String description;

  ExpenseItem({
    required this.id,
    required this.expenseNo,
    required this.date,
    required this.category,
    required this.amount,
    required this.paymentAccount,
    required this.description,
  });
}

/// Employee / Worker (موظف / عامل)
class Employee {
  final String id;
  final String code;
  final String name;
  final String jobTitle; // فني تقطيع / فني تسمير / مشرف جودة / محاسب
  final String department; // خط الإنتاج / المخازن / الحسابات
  final String phone;
  final DateTime hireDate;
  final double basicSalary;
  String status; // على رأس العمل / إجازة
  String attendanceStatus; // حاضر / غائب / متأخر

  Employee({
    required this.id,
    required this.code,
    required this.name,
    required this.jobTitle,
    required this.department,
    required this.phone,
    required this.hireDate,
    required this.basicSalary,
    this.status = 'على رأس العمل',
    this.attendanceStatus = 'حاضر',
  });
}

/// Worker Productivity (إنتاجية عامل)
class WorkerProductivity {
  final String workerName;
  final String productionOrderNo;
  final int unitsCompleted;
  final double timeSpentHours;
  final int rejectedUnits;

  WorkerProductivity({
    required this.workerName,
    required this.productionOrderNo,
    required this.unitsCompleted,
    required this.timeSpentHours,
    required this.rejectedUnits,
  });

  double get unitsPerHour =>
      timeSpentHours > 0 ? unitsCompleted / timeSpentHours : 0.0;
}

/// Machine / Asset (ماكينة / معدة)
class MachineAsset {
  final String id;
  final String code;
  final String name;
  final String type; // منشار متعدد / منشار تقطيع / ماكينة تسمير هيدروليك
  final String location;
  final DateTime lastMaintenanceDate;
  final DateTime nextMaintenanceDate;
  String status; // تعمل بكفاءة / قيد الصيانة / متوقفة

  MachineAsset({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.location,
    required this.lastMaintenanceDate,
    required this.nextMaintenanceDate,
    this.status = 'تعمل بكفاءة',
  });
}

/// System User Role & Permissions Matrix
class UserRole {
  final String roleName;
  final String roleTitle;
  Map<String, bool> permissions;

  UserRole({
    required this.roleName,
    required this.roleTitle,
    required this.permissions,
  });
}

/// Notification Item
class SystemNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String type; // warning / success / info / error

  SystemNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });
}
