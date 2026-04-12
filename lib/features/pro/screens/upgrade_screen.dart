import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/monetization_provider.dart';

class UpgradeScreen extends ConsumerWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(monetizationProvider);
    final settings = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.proTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primaryContainer, cs.tertiaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settings.isPro ? l10n.proHeroActive : l10n.proHeroInactive,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(l10n.proHeroSubtitle),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _FeaturePill(label: l10n.proFeatureFullBackup),
                    _FeaturePill(label: l10n.proFeatureHistory),
                    _FeaturePill(label: l10n.proFeatureFutureAi),
                    _FeaturePill(label: l10n.proFeatureFutureVault),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(l10n.proSectionFree),
          _PlanFeature(
            title: l10n.proFreeCoreTitle,
            subtitle: l10n.proFreeCoreSubtitle,
            included: true,
          ),
          _PlanFeature(
            title: l10n.proFreeAccountTitle,
            subtitle: l10n.proFreeAccountSubtitle,
            included: true,
          ),
          const SizedBox(height: 16),
          _SectionTitle(l10n.proSectionPaid),
          _PlanFeature(
            title: l10n.proPaidBackupTitle,
            subtitle: l10n.proPaidBackupSubtitle,
            included: true,
          ),
          _PlanFeature(
            title: l10n.proPaidHistoryTitle,
            subtitle: l10n.proPaidHistorySubtitle,
            included: true,
          ),
          _PlanFeature(
            title: l10n.proPaidFutureTitle,
            subtitle: l10n.proPaidFutureSubtitle,
            included: true,
          ),
          if (state.error != null) ...[
            const SizedBox(height: 16),
            Text(
              _localizedError(state.error!, l10n),
              style: TextStyle(color: cs.error, fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: settings.isPro || state.purchasePending
                ? null
                : () => ref.read(monetizationProvider.notifier).buyPro(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                settings.isPro
                    ? l10n.proAlreadyUnlocked
                    : state.product != null
                        ? l10n.proUnlockForPrice(state.product!.price)
                        : l10n.proUnlockInStore,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: state.purchasePending
                ? null
                : () =>
                    ref.read(monetizationProvider.notifier).restorePurchases(),
            child: Text(l10n.proRestorePurchase),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  ref.read(monetizationProvider.notifier).simulateUnlock(),
              child: Text(l10n.proDebugSimulate),
            ),
            if (settings.isPro)
              TextButton(
                onPressed: () =>
                    ref.read(settingsProvider.notifier).setPro(false),
                child: Text(l10n.proDebugRemove),
              ),
          ],
        ],
      ),
    );
  }

  String _localizedError(String error, AppLocalizations l10n) {
    switch (error) {
      case 'Google Play is not available on this device.':
        return l10n.proStoreUnavailable;
      case 'Pro product is not configured yet.':
        return l10n.proProductUnavailable;
      default:
        return error;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}

class _PlanFeature extends StatelessWidget {
  const _PlanFeature({
    required this.title,
    required this.subtitle,
    required this.included,
  });

  final String title;
  final String subtitle;
  final bool included;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        included ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: included ? cs.primary : cs.outline,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
