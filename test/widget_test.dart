import 'package:appocrm/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('home shows follow up header', (WidgetTester tester) async {
    await tester.pumpWidget(AppomatrixApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Follow up today'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Contacts'), findsWidgets);
  });
}
