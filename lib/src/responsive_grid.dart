import 'package:flutter/material.dart';

/// A custom responsive grid widget that automatically calculates item widths
/// based on the number of items per row with configurable spacing.
///
/// **Enhanced Features:**
/// - Animation support for smooth item appearance
/// - Loading state with skeleton effect
/// - Empty state widget
/// - Item tap callbacks
/// - Scroll controller support
/// - Better error handling
///
/// This widget supports both fixed and responsive modes:
/// - Fixed mode: Specify exactly how many items per row
/// - Responsive mode: Automatically adjusts based on screen width
///
/// You can use either the builder pattern OR pass children directly:
///
/// **Builder pattern:**
/// ```dart
/// ResponsiveGrid(
///   itemCount: items.length,
///   itemsPerRow: 3,
///   itemBuilder: (context, index, width) {
///     return MyCard(data: items[index]);
///   },
/// )
/// ```
///
/// **Children pattern:**
/// ```dart
/// ResponsiveGrid(
///   itemsPerRow: 3,
///   children: [
///     Card(child: Text('Item 1')),
///     Card(child: Text('Item 2')),
///     Card(child: Text('Item 3')),
///   ],
/// )
/// ```
///
/// **With animation:**
/// ```dart
/// ResponsiveGrid(
///   itemCount: items.length,
///   itemsPerRow: 3,
///   animateItems: true,
///   animationDuration: Duration(milliseconds: 300),
///   itemBuilder: (context, index, width) {
///     return MyCard(data: items[index]);
///   },
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
  /// Total number of items to display (required if using itemBuilder)
  final int? itemCount;

  /// Builder function that creates each item
  /// Provides context, index, and calculated width for the item
  /// (required if not using children)
  final Widget Function(BuildContext context, int index, double itemWidth)?
      itemBuilder;

  /// List of children widgets (alternative to itemBuilder + itemCount)
  /// If provided, itemBuilder and itemCount will be ignored
  final List<Widget>? children;

  /// Fixed number of items per row (overrides responsive mode if set)
  final int? itemsPerRow;

  /// Maximum items per row in responsive mode (default: 4)
  final int maxItemsPerRow;

  /// Minimum width for each item in responsive mode (default: 200)
  final double minItemWidth;

  /// Horizontal spacing between items (default: 10)
  final double horizontalSpacing;

  /// Vertical spacing between rows (default: 10)
  final double verticalSpacing;

  /// Padding around the entire grid
  final EdgeInsetsGeometry? padding;

  /// Alignment of items within each row (default: start)
  final WrapAlignment alignment;

  /// Cross-axis alignment (default: start)
  final WrapCrossAlignment crossAxisAlignment;

  /// Enable smooth animation when items appear (default: false)
  final bool animateItems;

  /// Duration of item appearance animation (default: 300ms)
  final Duration animationDuration;

  /// Stagger delay between item animations (default: 50ms)
  final Duration staggerDelay;

  /// Callback when an item is tapped (provides index)
  final void Function(int index)? onItemTap;

  /// Show loading state with skeleton effect (default: false)
  final bool isLoading;

  /// Number of skeleton items to show when loading (default: 6)
  final int skeletonCount;

  /// Widget to show when there are no items
  final Widget? emptyState;

  /// Scroll controller for the grid
  final ScrollController? scrollController;

  /// Physics for scrolling behavior
  final ScrollPhysics? physics;

  /// Enable shrink wrap for nested scrolling (default: false)
  final bool shrinkWrap;

  /// Background color for the grid container
  final Color? backgroundColor;

  /// Border radius for the grid container
  final BorderRadius? borderRadius;

  const ResponsiveGrid({
    super.key,
    this.itemCount,
    this.itemBuilder,
    this.children,
    this.itemsPerRow,
    this.maxItemsPerRow = 4,
    this.minItemWidth = 200.0,
    this.horizontalSpacing = 10.0,
    this.verticalSpacing = 10.0,
    this.padding,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.animateItems = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.staggerDelay = const Duration(milliseconds: 50),
    this.onItemTap,
    this.isLoading = false,
    this.skeletonCount = 6,
    this.emptyState,
    this.scrollController,
    this.physics,
    this.shrinkWrap = false,
    this.backgroundColor,
    this.borderRadius,
  })  : assert(
          (itemBuilder != null && itemCount != null) || children != null,
          'Either provide itemBuilder with itemCount, or provide children',
        ),
        assert(
          !((itemBuilder != null || itemCount != null) && children != null),
          'Cannot use both itemBuilder/itemCount and children. Choose one approach.',
        ),
        assert(
          itemCount == null || itemCount >= 0,
          'itemCount must be non-negative',
        ),
        assert(maxItemsPerRow > 0, 'maxItemsPerRow must be positive'),
        assert(minItemWidth > 0, 'minItemWidth must be positive'),
        assert(
            horizontalSpacing >= 0, 'horizontalSpacing must be non-negative'),
        assert(verticalSpacing >= 0, 'verticalSpacing must be non-negative'),
        assert(itemsPerRow == null || itemsPerRow > 0,
            'itemsPerRow must be positive if specified'),
        assert(skeletonCount > 0, 'skeletonCount must be positive');

  /// Calculates the number of items per row based on available width
  int _calculateItemsPerRow(double containerWidth) {
    if (itemsPerRow != null) {
      return itemsPerRow!;
    }

    // Calculate how many items can fit based on minimum width
    final availableWidth = containerWidth;

    // Start with 1 item and increase until we can't fit anymore
    int count = 1;
    while (count < maxItemsPerRow) {
      final nextCount = count + 1;
      final itemWidth =
          (availableWidth - (nextCount - 1) * horizontalSpacing) / nextCount;

      if (itemWidth < minItemWidth) {
        break;
      }
      count = nextCount;
    }

    // Fallback based on screen width for better defaults
    if (count == 1 && containerWidth > 600) {
      count = containerWidth > 1200 ? 3 : 2;
    }

    return count;
  }

  /// Calculates the width for each item
  double _calculateItemWidth(double containerWidth, int itemsInRow) {
    final totalSpacing = (itemsInRow - 1) * horizontalSpacing;
    return (containerWidth - totalSpacing) / itemsInRow;
  }

  /// Builds a skeleton loading item
  Widget _buildSkeletonItem(double width) {
    return Container(
      width: width,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Wraps an item with animation if enabled
  Widget _wrapWithAnimation(Widget child, int index) {
    if (!animateItems) return child;

    final delay = staggerDelay * index;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: animationDuration + delay,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Wraps an item with tap handler if callback is provided
  Widget _wrapWithTapHandler(Widget child, int index) {
    if (onItemTap == null) return child;

    return InkWell(
      onTap: () => onItemTap!(index),
      borderRadius: BorderRadius.circular(8),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (isLoading) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final containerWidth = constraints.maxWidth;
          final calculatedItemsPerRow = _calculateItemsPerRow(containerWidth);
          final itemWidth =
              _calculateItemWidth(containerWidth, calculatedItemsPerRow);

          return Container(
            padding: padding,
            decoration: backgroundColor != null
                ? BoxDecoration(
                    color: backgroundColor,
                    borderRadius: borderRadius,
                  )
                : null,
            child: Column(
              children: [
                for (int i = 0; i < skeletonCount; i += calculatedItemsPerRow)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i + calculatedItemsPerRow < skeletonCount
                          ? verticalSpacing
                          : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: _convertAlignment(alignment),
                      children: [
                        for (int j = 0;
                            j < calculatedItemsPerRow && i + j < skeletonCount;
                            j++) ...[
                          _buildSkeletonItem(itemWidth),
                          if (j < calculatedItemsPerRow - 1 &&
                              i + j + 1 < skeletonCount)
                            SizedBox(width: horizontalSpacing),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }

    // Determine the actual item count and builder to use
    final int actualItemCount = children?.length ?? itemCount ?? 0;

    // Show empty state if no items
    if (actualItemCount == 0) {
      return emptyState ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No items to display',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
    }

    // Create a builder function that works with both patterns
    Widget Function(BuildContext, int, double) actualBuilder;

    if (children != null) {
      // Use children directly, wrap in SizedBox with calculated width
      actualBuilder = (context, index, width) {
        return SizedBox(
          width: width,
          child: children![index],
        );
      };
    } else {
      // Use the provided itemBuilder
      actualBuilder = itemBuilder!;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final calculatedItemsPerRow = _calculateItemsPerRow(containerWidth);
        final itemWidth =
            _calculateItemWidth(containerWidth, calculatedItemsPerRow);

        // Build rows
        final rows = <Widget>[];
        for (int i = 0; i < actualItemCount; i += calculatedItemsPerRow) {
          final rowItems = <Widget>[];
          final itemsInThisRow = (i + calculatedItemsPerRow > actualItemCount)
              ? actualItemCount - i
              : calculatedItemsPerRow;

          for (int j = 0; j < itemsInThisRow; j++) {
            final index = i + j;
            Widget item = SizedBox(
              width: itemWidth,
              child: actualBuilder(context, index, itemWidth),
            );

            // Apply tap handler
            item = _wrapWithTapHandler(item, index);

            // Apply animation
            item = _wrapWithAnimation(item, index);

            rowItems.add(item);

            // Add horizontal spacing between items (but not after the last item)
            if (j < itemsInThisRow - 1) {
              rowItems.add(SizedBox(width: horizontalSpacing));
            }
          }

          rows.add(
            Row(
              mainAxisAlignment: _convertAlignment(alignment),
              crossAxisAlignment: _convertCrossAlignment(crossAxisAlignment),
              children: rowItems,
            ),
          );

          // Add vertical spacing between rows (but not after the last row)
          if (i + calculatedItemsPerRow < actualItemCount) {
            rows.add(SizedBox(height: verticalSpacing));
          }
        }

        final content = Container(
          padding: padding,
          decoration: backgroundColor != null
              ? BoxDecoration(
                  color: backgroundColor,
                  borderRadius: borderRadius,
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rows,
          ),
        );

        // Wrap in SingleChildScrollView if needed
        if (shrinkWrap) {
          return SingleChildScrollView(
            controller: scrollController,
            physics: physics,
            child: content,
          );
        }

        return content;
      },
    );
  }

  /// Converts WrapAlignment to MainAxisAlignment
  MainAxisAlignment _convertAlignment(WrapAlignment alignment) {
    switch (alignment) {
      case WrapAlignment.start:
        return MainAxisAlignment.start;
      case WrapAlignment.end:
        return MainAxisAlignment.end;
      case WrapAlignment.center:
        return MainAxisAlignment.center;
      case WrapAlignment.spaceBetween:
        return MainAxisAlignment.spaceBetween;
      case WrapAlignment.spaceAround:
        return MainAxisAlignment.spaceAround;
      case WrapAlignment.spaceEvenly:
        return MainAxisAlignment.spaceEvenly;
    }
  }

  /// Converts WrapCrossAlignment to CrossAxisAlignment
  CrossAxisAlignment _convertCrossAlignment(WrapCrossAlignment crossAlignment) {
    switch (crossAlignment) {
      case WrapCrossAlignment.start:
        return CrossAxisAlignment.start;
      case WrapCrossAlignment.end:
        return CrossAxisAlignment.end;
      case WrapCrossAlignment.center:
        return CrossAxisAlignment.center;
    }
  }
}
