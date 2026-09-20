import 'package:appocrm/app.dart';
import 'package:appocrm/data/crm_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  SharedPreferences.setMockInitialValues({'onboarding_complete': true});

  testWidgets('home shows follow up header', (WidgetTester tester) async {
    await tester.pumpWidget(AppomatrixApp(repository: CrmRepository()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Follow up today'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Contacts'), findsWidgets);
  });
}
