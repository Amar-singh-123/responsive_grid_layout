import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_grid_layout/responsive_grid_layout.dart';

void main() {
  group('ResponsiveGrid', () {
    testWidgets('renders with itemBuilder', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGrid(
              itemCount: 6,
              itemsPerRow: 3,
              itemBuilder: (context, index, width) {
                return SizedBox(
                  key: Key('item_$index'),
                  height: 100,
                  child: Text('Item $index'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 5'), findsOneWidget);
    });

    testWidgets('renders with children', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGrid(
              itemsPerRow: 2,
              children: [
                Container(key: Key('child_0'), height: 100),
                Container(key: Key('child_1'), height: 100),
              ],
            ),
          ),
        ),
      );

      expect(find.byKey(Key('child_0')), findsOneWidget);
      expect(find.byKey(Key('child_1')), findsOneWidget);
    });

    testWidgets('shows empty state when no items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGrid(
              itemCount: 0,
              itemsPerRow: 3,
              itemBuilder: (context, index, width) => Container(),
              emptyState: Text('No items'),
            ),
          ),
        ),
      );

      expect(find.text('No items'), findsOneWidget);
    });
  });
}
