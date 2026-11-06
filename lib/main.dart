import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/responsive.dart';
import 'core/widgets/app_header.dart';
import 'core/widgets/app_sidebar.dart';
import 'data/mock/mock_database.dart';

import 'features/customers/customers_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/finance/finance_screen.dart';
import 'features/hr/hr_screen.dart';
import 'features/inventory/inventory_screen.dart';
import 'features/maintenance/maintenance_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/orders/new_order_screen.dart';
import 'features/orders/orders_list_screen.dart';
import 'features/permissions/permissions_screen.dart';
import 'features/production/production_screen.dart';
import 'features/products/products_screen.dart';
import 'features/purchasing/purchasing_screen.dart';
import 'features/recipes/recipes_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/sales_invoicing/sales_invoicing_screen.dart';
import 'features/scrap_quality/scrap_quality_screen.dart';
import 'features/settings/settings_screen.dart';

void main() {
  runApp(const FactronERPApp());
}

class FactronERPApp extends StatelessWidget {
  const FactronERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MockDatabase(),
      child: MaterialApp(
        title: 'FACTRON ERP - مصنع البالتات الخشبية',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: ERPMainLayout(),
        ),
      ),
    );
  }
}

class ERPMainLayout extends StatefulWidget {
  const ERPMainLayout({super.key});

  @override
  State<ERPMainLayout> createState() => _ERPMainLayoutState();
}

class _ERPMainLayoutState extends State<ERPMainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<MockDatabase>(context);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    // Get Active Screen Info
    final activeRoute = db.activeRouteName;
    final routeInfo = ERPNavigation.items.firstWhere(
      (item) => item.route.name == activeRoute,
      orElse: () => ERPNavigation.items.first,
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.darkBackground,
      drawer: !isDesktop
          ? const Drawer(
              backgroundColor: AppColors.secondarySurface,
              child: AppSidebar(),
            )
          : null,
      body: Row(
        children: [
          // Sidebar for Desktop
          if (isDesktop) const AppSidebar(),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                AppHeader(
                  title: routeInfo.title,
                  onToggleSidebar: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),

                // Active Page View
                Expanded(
                  child: Container(
                    color: AppColors.darkBackground,
                    child: _buildActivePage(activeRoute),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePage(String activeRoute) {
    switch (activeRoute) {
      case 'dashboard':
        return const DashboardScreen();
      case 'customers':
        return const CustomersScreen();
      case 'orders':
        return const OrdersListScreen();
      case 'newOrder':
        return const NewOrderScreen();
      case 'products':
        return const ProductsScreen();
      case 'recipes':
        return const RecipesScreen();
      case 'inventory':
        return const InventoryScreen();
      case 'production':
        return const ProductionScreen();
      case 'scrapQuality':
        return const ScrapQualityScreen();
      case 'purchasing':
        return const PurchasingScreen();
      case 'salesInvoices':
        return const SalesInvoicingScreen();
      case 'finance':
        return const FinanceScreen();
      case 'hr':
        return const HRScreen();
      case 'maintenance':
        return const MaintenanceScreen();
      case 'reports':
        return const ReportsScreen();
      case 'permissions':
        return const PermissionsScreen();
      case 'notifications':
        return const NotificationsScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }
}
