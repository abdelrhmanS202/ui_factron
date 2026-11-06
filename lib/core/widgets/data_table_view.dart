import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'custom_card.dart';

class DataColumnSpec {
  final String title;
  final double? width;
  final Alignment alignment;

  const DataColumnSpec({
    required this.title,
    this.width,
    this.alignment = Alignment.centerRight,
  });
}

class DataTableView<T> extends StatefulWidget {
  final String title;
  final List<DataColumnSpec> columns;
  final List<T> items;
  final List<Widget> Function(T item) rowBuilder;
  final Widget? headerAction;
  final String? searchHint;
  final bool Function(T item, String query)? searchFilter;
  final int rowsPerPage;

  const DataTableView({
    super.key,
    required this.title,
    required this.columns,
    required this.items,
    required this.rowBuilder,
    this.headerAction,
    this.searchHint,
    this.searchFilter,
    this.rowsPerPage = 10,
  });

  @override
  State<DataTableView<T>> createState() => _DataTableViewState<T>();
}

class _DataTableViewState<T> extends State<DataTableView<T>> {
  String _searchQuery = '';
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Apply search filter
    final filteredItems = widget.items.where((item) {
      if (_searchQuery.isEmpty || widget.searchFilter == null) return true;
      return widget.searchFilter!(item, _searchQuery);
    }).toList();

    // Pagination
    final totalPages = (filteredItems.length / widget.rowsPerPage).ceil();
    final safePage = totalPages == 0 ? 0 : _currentPage.clamp(0, totalPages - 1);
    final startIndex = safePage * widget.rowsPerPage;
    final pageItems = filteredItems.skip(startIndex).take(widget.rowsPerPage).toList();

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header Bar
          Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${filteredItems.length} عنصر',
                  style: const TextStyle(color: AppColors.primaryBlue, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              if (widget.searchFilter != null)
                SizedBox(
                  width: 220,
                  height: 36,
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                        _currentPage = 0;
                      });
                    },
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: widget.searchHint ?? 'بحث...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 16, color: AppColors.textMuted),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      fillColor: const Color(0xFFF1F5F9),
                      filled: true,
                    ),
                  ),
                ),
              if (widget.headerAction != null) ...[
                const SizedBox(width: 12),
                widget.headerAction!,
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Scrollable Table Area
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 340),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                dataRowColor: WidgetStateProperty.all(AppColors.cardSurface),
                dividerThickness: 1.0,
                horizontalMargin: 12,
                columnSpacing: 16,
                columns: widget.columns.map((col) {
                  return DataColumn(
                    label: Container(
                      width: col.width,
                      alignment: col.alignment,
                      child: Text(
                        col.title,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                rows: pageItems.map((item) {
                  final cells = widget.rowBuilder(item);
                  return DataRow(
                    cells: List.generate(cells.length, (index) {
                      final col = widget.columns[index];
                      return DataCell(
                        Container(
                          width: col.width,
                          alignment: col.alignment,
                          child: cells[index],
                        ),
                      );
                    }),
                  );
                }).toList(),
              ),
            ),
          ),

          if (pageItems.isEmpty) ...[
            const SizedBox(height: 32),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 40, color: AppColors.textMuted),
                  SizedBox(height: 8),
                  Text('لا توجد بيانات مطابقة للبحث', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],

          const SizedBox(height: 16),

          // Pagination Controls
          if (totalPages > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عرض ${startIndex + 1} إلى ${(startIndex + pageItems.length).clamp(0, filteredItems.length)} من أصل ${filteredItems.length}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      onPressed: safePage > 0 ? () => setState(() => _currentPage--) : null,
                    ),
                    Text(
                      'صفحة ${safePage + 1} من $totalPages',
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textSecondary),
                      onPressed: safePage < totalPages - 1 ? () => setState(() => _currentPage++) : null,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
