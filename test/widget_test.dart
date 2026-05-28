import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder_app/main.dart';

void main() {
  testWidgets('app renders splash screen', (tester) async {
    await tester.pumpWidget(const RecipeFinderApp());

    expect(find.text('Recipe Finder'), findsOneWidget);
  });
}
