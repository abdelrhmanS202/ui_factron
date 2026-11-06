import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusChip({
    super.key,
    required this.status,
    this.fontSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData? icon;

    switch (status) {
      case 'معتمد':
      case 'مكتمل':
      case 'تم التسليم':
      case 'متوفر':
      case 'مدفوعة بالكامل':
      case 'تعمل بكفاءة':
      case 'حاضر':
      case 'نشط':
        bg = AppColors.successBg;
        fg = AppColors.success;
        icon = Icons.check_circle_rounded;
        break;

      case 'قيد الإنتاج':
      case 'قيد التنفيذ':
      case 'تجميع وتسمير':
      case 'قيد التوريد':
      case 'مدفوعة جزئياً':
      case 'تحتاج صيانة وقائية':
      case 'جاهز للتسليم':
        bg = AppColors.infoBg;
        fg = AppColors.info;
        icon = Icons.sync_rounded;
        break;

      case 'مخزون منخفض':
      case 'معلق':
      case 'مسودة':
      case 'عرض سعر':
      case 'متأخر':
      case 'إجازة':
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        icon = Icons.warning_amber_rounded;
        break;

      case 'ملغي':
      case 'غير متوفر':
      case 'غير مدفوعة':
      case 'قيد الصيانة':
      case 'متوقفة':
      case 'غائب':
      case 'مرتجع':
        bg = AppColors.errorBg;
        fg = AppColors.error;
        icon = Icons.cancel_rounded;
        break;

      default:
        bg = const Color(0xFFF1F5F9);
        fg = AppColors.textSecondary;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 2, color: fg),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
