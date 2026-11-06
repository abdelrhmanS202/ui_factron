import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock/mock_database.dart';
import '../routing/app_routes.dart';
import '../theme/app_theme.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);
    final activeRoute = db.activeRouteName;

    // Group navigation items by category
    final Map<String, List<ERPRouteInfo>> groupedItems = {};
    for (var item in ERPNavigation.items) {
      groupedItems.putIfAbsent(item.group, () => []).add(item);
    }

    return Container(
      width: 270,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBackground, // Deep Navy Blue #0B1A30
      ),
      child: Column(
        children: [
          // 1. BRAND HEADER SECTION
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: const BoxDecoration(
              color: Color(0xFF071224), // Deeper contrast blue
              border: Border(
                bottom: BorderSide(color: Color(0x1AFFFFFF), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x402563EB),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.warehouse_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FACTRON',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'مصنع البالتات الخشبية ERP',
                        style: TextStyle(
                          color: Color(0xFF93C5FD),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. EXPANDED NAVIGATION MENU LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              itemCount: groupedItems.keys.length,
              itemBuilder: (context, groupIndex) {
                final groupTitle = groupedItems.keys.elementAt(groupIndex);
                final items = groupedItems[groupTitle]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12, top: 16, bottom: 8),
                      child: Text(
                        groupTitle,
                        style: const TextStyle(
                          color: Color(0xFF64748B), // Slate gray header
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...items.map((item) {
                      final isSelected = activeRoute == item.route.name;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            // Active Right Strip Indicator for RTL
                            if (isSelected)
                              Positioned(
                                right: 0,
                                top: 6,
                                bottom: 6,
                                child: Container(
                                  width: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.sidebarActiveIndicator,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              leading: Icon(
                                item.icon,
                                color: isSelected ? AppColors.sidebarActiveIndicator : const Color(0xFF94A3B8),
                                size: 20,
                              ),
                              title: Text(
                                item.title,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: item.badge != null
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.accentBlue
                                            : const Color(0xFF334155),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item.badge!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : null,
                              onTap: () {
                                db.setActiveRoute(item.route.name);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),

          // 3. SIDEBAR FOOTER STATUS BAR
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF071224),
              border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'النظام متصل بيئة العرض',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'FACTRON v1.0 • Demo State',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 9),
                        overflow: TextOverflow.ellipsis,
                      ),
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
