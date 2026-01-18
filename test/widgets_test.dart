import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:capstone/widgets/bottom_nav.dart';
import 'package:capstone/widgets/constants.dart';

void main() {
  testWidgets('BottomNav renders', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomNav(currentIndex: 0),
      ),
    );
    expect(find.byType(BottomNav), findsOneWidget);
  });

  test('AppColors and AppTextStyles are accessible', () {
    expect(AppColors.primary, isNotNull);
    expect(AppTextStyles.bannerTitle, isNotNull);
  });
}