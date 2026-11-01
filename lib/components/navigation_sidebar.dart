// Shared responsive navigation components used by the main feature pages.
//
// A page provides its menu entries once; the scaffold switches between a
// persistent sidebar at wide widths and a drawer on narrower layouts.
import 'package:flutter/material.dart';
import 'package:gmdex/components/responsive_layout.dart';
import 'package:gmdex/theme/apptheme.dart';

/// Describes one row in the sidebar. This is data, not a widget: each page
// creates a list of these objects to say what its navigation menu should show.
class NavigationSidebarItem {
  const NavigationSidebarItem({
    required this.title,
    this.selected = false,
    this.onTap,
    this.showDividerAfter = false,
  });

  final String title; // The text shown in the menu.
  final bool selected; // Whether this row represents the current page.

  // The action to run when the row is tapped. VoidCallback means a function
  // that takes no arguments and returns no value. The ? means this is optional;
  // for example, the current page's row can have no action.
  final VoidCallback? onTap;
  final bool showDividerAfter;
}

/// Renders the list of menu items either inside a narrow-screen drawer or as a
// permanently visible sidebar on a wide screen.
class NavigationSidebar extends StatelessWidget {
  const NavigationSidebar({
    super.key,
    required this.items,
    required this.inDrawer,
  });

  final List<NavigationSidebarItem> items;
  final bool inDrawer; // Tells this widget which of the two layouts to render.

  @override
  Widget build(BuildContext context) {
    // A Column stacks its children vertically. The for-loop creates one
    // ListTile for every item supplied by the page, so all pages use the same
    // row layout and selection styling.
    final sidebar = Column(
      spacing: AppSpacing.spacingMedium,
      children: [
        for (final item in items) ...[
          ListTile(
            // Flutter applies its selected colors when this is true.
            selected: item.selected,
            title: Text(
              item.title,
              // The conditional expression means "if selected, use this style;
              // otherwise use the default style". The shadows outline selected
              // text to make it stand out against the background.
              style: item.selected
                  ? const TextStyle(
                      shadows: [
                        Shadow(
                          color: AppColors.appBlack,
                          offset: Offset(-1, -1),
                        ),
                        Shadow(
                          color: AppColors.appBlack,
                          offset: Offset(0, -1),
                        ),
                        Shadow(
                          color: AppColors.appBlack,
                          offset: Offset(1, -1),
                        ),
                        Shadow(
                          color: AppColors.appBlack,
                          offset: Offset(-1, 0),
                        ),
                        Shadow(color: AppColors.appBlack, offset: Offset(1, 0)),
                        Shadow(
                          color: AppColors.appBlack,
                          offset: Offset(-1, 1),
                        ),
                        Shadow(color: AppColors.appBlack, offset: Offset(0, 1)),
                        Shadow(color: AppColors.appBlack, offset: Offset(1, 1)),
                      ],
                    )
                  : null,
            ),
            shape: RoundedRectangleBorder(
              // Give the selected row a subtle outline; unselected rows have
              // a transparent outline so their sizes remain consistent.
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: item.selected ? AppColors.hoverGrey : Colors.transparent,
                width: 1,
              ),
            ),
            onTap: item.onTap == null
                ? null
                : () {
                    // This widget is also used inline, where there is no drawer
                    // to close. When it is in a drawer, pop removes that drawer
                    // from the navigation stack before running the page action.
                    if (inDrawer) Navigator.of(context).pop();
                    // The null check above guarantees the callback exists.
                    // The ! tells Dart it is safe to call it here.
                    item.onTap!();
                  },
          ),
          if (item.showDividerAfter)
            const Divider(color: AppColors.primary, thickness: 1),
        ],
      ],
    );

    if (inDrawer) {
      // SafeArea avoids system UI such as the status bar. Padding keeps menu
      // rows away from the drawer edges.
      return Drawer(
        child: SafeArea(
          child: Padding(padding: const EdgeInsets.all(16), child: sidebar),
        ),
      );
    }

    // On wide screens, use a fixed-width column with a border separating it
    // visually from the page content.
    return Container(
      width: 185,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.primary, width: 1)),
      ),
      child: sidebar,
    );
  }
}

/// Builds the common page frame for screens that have a navigation sidebar.
// Each page supplies its own title, menu entries, and main content; this widget
// decides how to arrange those pieces based on the available width.
class ResponsiveNavigationScaffold extends StatelessWidget {
  const ResponsiveNavigationScaffold({
    super.key,
    required this.title,
    required this.items,
    required this.body,
    this.breakpoint = ResponsiveBreakpoints.navigation,
    this.onAddPressed,
    this.addTooltip = 'Create',
    this.onSettingsReturned,
  });

  final String title; // App-bar title on narrow screens.
  final List<NavigationSidebarItem> items; // Page-specific navigation rows.
  final Widget body; // The page's main content, such as a list or form.
  final VoidCallback? onAddPressed;
  final String addTooltip;
  final Future<void> Function()? onSettingsReturned;

  // At or above this width, keep the sidebar visible beside the content.
  // Below it, move navigation into a drawer to leave more room for content.
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // LayoutBuilder provides the actual width available to this widget.
        // This is more reliable than checking the overall device size because
        // the page may be placed in a smaller window or split-screen area.
        final isWide = ResponsiveLayout.isWide(
          constraints.maxWidth,
          breakpoint: breakpoint,
        );
        final sidebarItems = [
          ...items,
          NavigationSidebarItem(
            title: 'Settings',
            onTap: () async {
              await Navigator.of(context).pushNamed<void>('/settings');
              await onSettingsReturned?.call();
            },
          ),
        ];
        return Scaffold(
          // A null appBar means there is no app bar in the wide layout. The
          // narrow layout gets a title and Flutter's automatic drawer button.
          appBar: isWide
              ? null
              : AppBar(
                  title: Text(title),
                  backgroundColor: AppColors.appBlack,
                  actions: onAddPressed == null
                      ? null
                      : [
                          IconButton(
                            tooltip: addTooltip,
                            onPressed: onAddPressed,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                ),
          // Only narrow screens get a drawer. On wide screens the same menu is
          // rendered as the always-visible first child of the body Row below.
          drawer: isWide
              ? null
              : NavigationSidebar(items: sidebarItems, inDrawer: true),
          // A Row places its children horizontally. Expanded makes the main
          // content take all remaining width after the fixed-width sidebar.
          // On narrow screens there is no Row: the content fills the Scaffold.
          body: isWide
              ? Row(
                  children: [
                    NavigationSidebar(items: sidebarItems, inDrawer: false),
                    Expanded(child: body),
                  ],
                )
              : SafeArea(top: false, left: false, right: false, child: body),
        );
      },
    );
  }
}
