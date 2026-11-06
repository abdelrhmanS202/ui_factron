import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 1. Line Chart Widget (Sales vs Expenses over months)
class LineChartWidget extends StatelessWidget {
  final List<String> labels;
  final List<double> series1; // e.g. Sales
  final List<double> series2; // e.g. Expenses
  final String series1Name;
  final String series2Name;

  const LineChartWidget({
    super.key,
    required this.labels,
    required this.series1,
    required this.series2,
    this.series1Name = 'المبيعات',
    this.series2Name = 'المصروفات',
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = max(
      series1.reduce(max),
      series2.reduce(max),
    );

    return Column(
      children: [
        // Legend Header (Wrap to avoid overflow)
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 8,
          children: [
            _buildLegendItem(series1Name, AppColors.primaryBlue),
            _buildLegendItem(series2Name, AppColors.warning),
          ],
        ),
        const SizedBox(height: 12),
        // Custom Painter Chart Body
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _LineChartPainter(
              labels: labels,
              series1: series1,
              series2: series2,
              maxValue: maxValue * 1.15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> series1;
  final List<double> series2;
  final double maxValue;

  _LineChartPainter({
    required this.labels,
    required this.series1,
    required this.series2,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final line1Paint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final line2Paint = Paint()
      ..color = AppColors.warning
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint1 = Paint()..color = AppColors.primaryBlue;
    final dotPaint2 = Paint()..color = AppColors.warning;

    final bottomPadding = 30.0;
    final topPadding = 10.0;
    final chartHeight = size.height - bottomPadding - topPadding;
    final chartWidth = size.width;

    // Draw horizontal gridlines (4 lines)
    for (int i = 0; i <= 3; i++) {
      final y = topPadding + (chartHeight / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }

    final double stepX = labels.length > 1 ? chartWidth / (labels.length - 1) : chartWidth;

    final Path path1 = Path();
    final Path path2 = Path();

    final textPainter = TextPainter(textDirection: TextDirection.rtl);

    for (int i = 0; i < labels.length; i++) {
      final x = i * stepX;

      // Y positions
      final y1 = topPadding + chartHeight - (series1[i] / maxValue) * chartHeight;
      final y2 = topPadding + chartHeight - (series2[i] / maxValue) * chartHeight;

      if (i == 0) {
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
      } else {
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
      }

      // Draw Dots
      canvas.drawCircle(Offset(x, y1), 3.5, dotPaint1);
      canvas.drawCircle(Offset(x, y2), 3.5, dotPaint2);

      // Draw Label
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - (textPainter.width / 2), size.height - 20));
    }

    canvas.drawPath(path1, line1Paint);
    canvas.drawPath(path2, line2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 2. Bar Chart Widget (Planned vs Actual Production or Daily Output)
class BarChartWidget extends StatelessWidget {
  final List<String> labels;
  final List<double> plannedValues;
  final List<double> actualValues;

  const BarChartWidget({
    super.key,
    required this.labels,
    required this.plannedValues,
    required this.actualValues,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = max(
      plannedValues.reduce(max),
      actualValues.reduce(max),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend('المخطط', AppColors.primaryBlue),
            const SizedBox(width: 20),
            _buildLegend('الفعلي', AppColors.success),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final groupWidth = constraints.maxWidth / labels.length;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(labels.length, (index) {
                  final pVal = plannedValues[index];
                  final aVal = actualValues[index];
                  final pHeight = maxVal > 0 ? (pVal / maxVal) * (constraints.maxHeight - 35) : 0.0;
                  final aHeight = maxVal > 0 ? (aVal / maxVal) * (constraints.maxHeight - 35) : 0.0;

                  return SizedBox(
                    width: groupWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Planned Bar
                            Container(
                              width: 12,
                              height: pHeight,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                              ),
                            ),
                            const SizedBox(width: 3),
                            // Actual Bar
                            Container(
                              width: 12,
                              height: aHeight,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          labels[index],
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

/// 3. Donut/Pie Chart Widget for Cost Breakdown (Materials, Labor, Industrial Overhead)
class DonutChartWidget extends StatelessWidget {
  final List<String> categories;
  final List<double> values;
  final List<Color> colors;

  const DonutChartWidget({
    super.key,
    required this.categories,
    required this.values,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final total = values.fold(0.0, (sum, v) => sum + v);

    return Row(
      children: [
        // Donut Visual
        SizedBox(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: _DonutPainter(values: values, colors: colors, total: total),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('الإجمالي', style: TextStyle(color: AppColors.textMuted, fontSize: 9)),
                  Text(
                    '${(total / 1000).toStringAsFixed(0)}k',
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Categories Legend List
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(categories.length, (index) {
              final pct = total > 0 ? (values[index] / total) * 100 : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: colors[index], shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        categories[index],
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${pct.toStringAsFixed(0)}%',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double total;

  _DonutPainter({required this.values, required this.colors, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final strokeWidth = 20.0;

    double startAngle = -pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = total > 0 ? (values[i] / total) * 2 * pi : 0.0;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
