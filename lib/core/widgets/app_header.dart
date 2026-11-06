import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock/mock_database.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onToggleSidebar;

  const AppHeader({
    super.key,
    required this.title,
    this.onToggleSidebar,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x050F172A),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sidebar Toggle Button for Mobile/Tablet
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
              onPressed: onToggleSidebar,
            ),

          // Breadcrumb & Page Title
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'الرئيسية',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text('/', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.accentBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Global Search Input (Desktop)
          if (isDesktop)
            SizedBox(
              width: 260,
              height: 40,
              child: TextField(
                onChanged: db.updateGlobalSearch,
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'بحث عام في النظام...',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      '⌘K',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  fillColor: const Color(0xFFF1F5F9),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.5),
                  ),
                ),
              ),
            ),

          const SizedBox(width: 16),

          // Primary Quick Action Button
          ElevatedButton.icon(
            onPressed: () {
              db.setActiveRoute('newOrder');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
            label: Text(
              isDesktop ? 'طلب جديد' : 'طلب',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 14),

          // Notifications Popup Button
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 22),
                onPressed: () => _showNotificationsDialog(context, db),
              ),
              if (db.notifications.any((n) => !n.isRead))
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${db.notifications.where((n) => !n.isRead).length}',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // User Profile Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentBlue, width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.person_rounded, size: 16, color: Colors.white),
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 10),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'م. أسامة منصور',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'صاحب المصنع',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textMuted),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context, MockDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: const Row(
          children: [
            Icon(Icons.notifications_active_rounded, color: AppColors.primaryBlue),
            SizedBox(width: 8),
            Text('مركز الإشعارات والتنبيهات', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 350,
          child: ListView.separated(
            itemCount: db.notifications.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final n = db.notifications[index];
              return ListTile(
                leading: Icon(
                  n.type == 'warning'
                      ? Icons.warning_amber_rounded
                      : n.type == 'error'
                          ? Icons.error_outline_rounded
                          : Icons.check_circle_outline_rounded,
                  color: n.type == 'warning'
                      ? AppColors.warning
                      : n.type == 'error'
                          ? AppColors.error
                          : AppColors.success,
                ),
                title: Text(n.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                subtitle: Text(n.message, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                trailing: Text(
                  '${n.timestamp.hour}:${n.timestamp.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
                onTap: () {
                  db.markNotificationAsRead(n.id);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
