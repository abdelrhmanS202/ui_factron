import 'package:flutter/material.dart';
import '../../data/models/erp_models.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class PrintInvoiceDialog extends StatelessWidget {
  final SalesInvoice invoice;

  const PrintInvoiceDialog({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // White printable invoice style
      contentPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'معاينة الطباعة - فاتورة ضريبية',
            style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.black54),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Factory Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مصنع فاكترون للبالتات الخشبية',
                        style: TextStyle(color: Color(0xFF170C7A), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('تجهيز وتصنيع كافة أنواع البالتات والمعالجة الحرارية ISPM15',
                          style: TextStyle(color: Colors.black54, fontSize: 10)),
                      const Text('المنطقة الصناعية - 6 أكتوبر - مصر | هاتف: 02-38380000',
                          style: TextStyle(color: Colors.black54, fontSize: 10)),
                      const Text('سجل تجاري: 102938 | بطاقة ضريبية: 492-102-882',
                          style: TextStyle(color: Colors.black54, fontSize: 10)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text('فاتورة رقم: ${invoice.invoiceNo}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                        const SizedBox(height: 2),
                        Text('التاريخ: ${AppFormatters.formatDate(invoice.date)}',
                            style: const TextStyle(fontSize: 10, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 32, thickness: 1.5, color: Colors.black26),

              // Customer Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('العميل المستلم:', style: TextStyle(fontSize: 10, color: Colors.black54)),
                        Text(invoice.customerName,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('رقم أمر البيع المرتبط:', style: TextStyle(fontSize: 10, color: Colors.black54)),
                        Text(invoice.orderNo,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF170C7A))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Table Items
              Table(
                border: TableBorder.all(color: Colors.black26, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFF170C7A)),
                    children: [
                      _buildHeaderCell('البيان / نوع البالتة'),
                      _buildHeaderCell('الكمية'),
                      _buildHeaderCell('سعر الوحدة'),
                      _buildHeaderCell('الإجمالي'),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildBodyCell(invoice.palletName),
                      _buildBodyCell('${invoice.quantity} بالتة'),
                      _buildBodyCell(AppFormatters.formatCurrency(invoice.unitPrice)),
                      _buildBodyCell(AppFormatters.formatCurrency(invoice.subtotal)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Total Calculation Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        _buildSummaryRow('المبلغ الإجمالي:', AppFormatters.formatCurrency(invoice.subtotal)),
                        _buildSummaryRow('الخصم:', AppFormatters.formatCurrency(invoice.discount)),
                        _buildSummaryRow('الضريبة (14%):', AppFormatters.formatCurrency(invoice.tax)),
                        const Divider(thickness: 1.5, color: Colors.black87),
                        _buildSummaryRow('صافي القيمة المستحقة:', AppFormatters.formatCurrency(invoice.grandTotal), isBold: true),
                        _buildSummaryRow('المبلغ المدفوع:', AppFormatters.formatCurrency(invoice.paidAmount)),
                        _buildSummaryRow('المتبقي (الرصيد):', AppFormatters.formatCurrency(invoice.remainingBalance), isBold: true, color: Colors.red.shade700),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Signatures Area
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('توقيع الحسابات / المحاسب', style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      Text('__________________', style: TextStyle(color: Colors.black38)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('توقيع وإختام العميل المستلم', style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
                      SizedBox(height: 30),
                      Text('__________________', style: TextStyle(color: Colors.black38)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, size: 16),
          label: const Text('إلغاء'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إرسال أمر الطباعة والتصدير بنجاح (Demo Print Action)'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF170C7A)),
          icon: const Icon(Icons.print_rounded, size: 16),
          label: const Text('طباعة / تصدير PDF'),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBodyCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black87, fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: isBold ? Colors.black87 : Colors.black54, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 11, color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
