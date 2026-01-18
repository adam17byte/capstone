import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:capstone/auth/login_page.dart';
import 'package:capstone/auth/register_page.dart';
import 'package:capstone/auth/forgot_password_page.dart';

void main() {
  testWidgets('LoginPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(find.byType(LoginPage), findsOneWidget);
  });
  testWidgets('RegisterPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterPage()));
    expect(find.byType(RegisterPage), findsOneWidget);
  });
  testWidgets('ForgotPasswordPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ForgotPasswordPage()));
    expect(find.byType(ForgotPasswordPage), findsOneWidget);
  });
}