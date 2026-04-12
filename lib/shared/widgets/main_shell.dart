import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../features/clipboard/screens/clipboard_screen.dart';
import '../../features/notes/screens/notes_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/todos/screens/todos_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [
    ClipboardScreen(),
    NotesScreen(),
    TodosScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.content_paste_outlined),
            selectedIcon: const Icon(Icons.content_paste_rounded),
            label: l10n.tabClipboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.note_outlined),
            selectedIcon: const Icon(Icons.note_rounded),
            label: l10n.tabNotes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.checklist_outlined),
            selectedIcon: const Icon(Icons.checklist_rounded),
            label: l10n.tabTasks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
