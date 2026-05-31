import 'package:first_demo/res/string/generated/app_localizations.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/routes.dart';
import 'package:first_demo/states/state_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DevMenu extends StatelessWidget {
  const DevMenu({super.key});

  static Map<String Function(AppLocalizations), String> _buildItems() => {
        (AppLocalizations l) => l.counterPageTitle: Routes.COUNTER,
        (AppLocalizations l) => 'Calculator': Routes.CALCULATOR,
        (AppLocalizations l) => l.animalImagePageTitle: Routes.ANIMAL_IMAGE,
        (AppLocalizations l) => l.momentsPageTitle: Routes.MOMENTS,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = stringsOf(context);
    final items = _buildItems();
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(color: theme.colorScheme.primary),
          child: Center(
              child: Text(
            string.devMenu,
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
                    title: Text(entry.key(string)),
                    onTap: () => context.go(entry.value),
                  ))
              .toList(),
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.logout, color: theme.colorScheme.error),
          title: Text(
            'Logout (Clear Token)',
            style: TextStyle(color: theme.colorScheme.error),
          ),
          onTap: () async {
            await authState.logout();
          },
        ),
      ]),
    );
  }
}
