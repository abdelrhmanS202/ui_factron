import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:factron/main.dart';

void main() {
  testWidgets('ERP Smoke Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const FactronERPApp());
    expect(find.text('FACTRON'), findsWidgets);
  });
}
