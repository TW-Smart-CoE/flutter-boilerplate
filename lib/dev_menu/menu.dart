import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DevMenu extends StatelessWidget {
  DevMenu({Key? key}) : super(key: key);

  static Map<String Function(AppLocalizations), String> _buildItems() => {
        (AppLocalizations l) => l.counterPageTitle: Routes.COUNTER,
        (AppLocalizations l) => l.animalImagePageTitle: Routes.ANIMAL_IMAGE,
        (AppLocalizations l) => l.momentsPageTitle: Routes.MOMENTS,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = l10n(context);
    final items = _buildItems();
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(color: theme.colorScheme.primary),
          child: Center(
              child: Text(
            loc.devMenu,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          )),
        ),
        ...ListTile.divideTiles(
          context: context,
          tiles: items.entries
              .map((entry) => ListTile(
                    style: ListTileStyle.drawer,
                    trailing: const Icon(Icons.arrow_right),
                    title: Text(entry.key(loc)),
                    onTap: () => context.go(entry.value),
                  ))
              .toList(),
        ).toList(),
      ]),
    );
  }
}
