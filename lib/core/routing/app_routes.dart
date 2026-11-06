import 'package:flutter/material.dart';

enum ERPRoute {
  dashboard,
  customers,
  orders,
  newOrder,
  products,
  recipes,
  inventory,
  production,
  scrapQuality,
  purchasing,
  salesInvoices,
  finance,
  hr,
  maintenance,
  reports,
  permissions,
  notifications,
  settings,
}

class ERPRouteInfo {
  final ERPRoute route;
  final String title;
  final IconData icon;
  final String group;
  final String? badge;

  const ERPRouteInfo({
    required this.route,
    required this.title,
    required this.icon,
    required this.group,
    this.badge,
  });
}

class ERPNavigation {
  static const List<ERPRouteInfo> items = [
    // لوحة التحكم
    ERPRouteInfo(
      route: ERPRoute.dashboard,
      title: 'لوحة التحكم',
      icon: Icons.dashboard_rounded,
      group: 'الرئيسية',
    ),

    // العملاء والمبيعات
    ERPRouteInfo(
      route: ERPRoute.customers,
      title: 'العملاء',
      icon: Icons.people_alt_rounded,
      group: 'العملاء والمبيعات',
    ),
    ERPRouteInfo(
      route: ERPRoute.orders,
      title: 'طلبات العملاء',
      icon: Icons.shopping_cart_rounded,
      group: 'العملاء والمبيعات',
      badge: 'جديد',
    ),
    ERPRouteInfo(
      route: ERPRoute.salesInvoices,
      title: 'المبيعات والفواتير',
      icon: Icons.receipt_long_rounded,
      group: 'العملاء والمبيعات',
    ),

    // المنتجات والتصنيع
    ERPRouteInfo(
      route: ERPRoute.products,
      title: 'المنتجات الجاهزة',
      icon: Icons.inventory_2_rounded,
      group: 'المنتجات والتصنيع',
    ),
    ERPRouteInfo(
      route: ERPRoute.recipes,
      title: 'وصفات التصنيع (BOM)',
      icon: Icons.account_tree_rounded,
      group: 'المنتجات والتصنيع',
    ),
    ERPRouteInfo(
      route: ERPRoute.production,
      title: 'أوامر الإنتاج',
      icon: Icons.precision_manufacturing_rounded,
      group: 'المنتجات والتصنيع',
      badge: 'نشط',
    ),
    ERPRouteInfo(
      route: ERPRoute.scrapQuality,
      title: 'الهالك وفحص الجودة',
      icon: Icons.high_quality_rounded,
      group: 'المنتجات والتصنيع',
    ),

    // المخازن والمشتريات
    ERPRouteInfo(
      route: ERPRoute.inventory,
      title: 'إدارة المخازن',
      icon: Icons.warehouse_rounded,
      group: 'المخازن والمشتريات',
    ),
    ERPRouteInfo(
      route: ERPRoute.purchasing,
      title: 'المشتريات والموردون',
      icon: Icons.local_shipping_rounded,
      group: 'المخازن والمشتريات',
    ),

    // الحسابات والمالية
    ERPRouteInfo(
      route: ERPRoute.finance,
      title: 'الحسابات والمالية',
      icon: Icons.account_balance_wallet_rounded,
      group: 'الحسابات والمالية',
    ),

    // الموارد البشرية والأصول
    ERPRouteInfo(
      route: ERPRoute.hr,
      title: 'الموارد البشرية',
      icon: Icons.badge_rounded,
      group: 'الإدارة والتشغيل',
    ),
    ERPRouteInfo(
      route: ERPRoute.maintenance,
      title: 'الأصول والصيانة',
      icon: Icons.build_rounded,
      group: 'الإدارة والتشغيل',
    ),

    // التقارير والنظام
    ERPRouteInfo(
      route: ERPRoute.reports,
      title: 'التقارير التحليلية',
      icon: Icons.analytics_rounded,
      group: 'التقارير والنظام',
    ),
    ERPRouteInfo(
      route: ERPRoute.permissions,
      title: 'الأدوار والصلاحيات',
      icon: Icons.admin_panel_settings_rounded,
      group: 'التقارير والنظام',
    ),
    ERPRouteInfo(
      route: ERPRoute.notifications,
      title: 'الإشعارات والسجل',
      icon: Icons.notifications_active_rounded,
      group: 'التقارير والنظام',
    ),
    ERPRouteInfo(
      route: ERPRoute.settings,
      title: 'إعدادات المصنع',
      icon: Icons.settings_rounded,
      group: 'التقارير والنظام',
    ),
  ];
}
