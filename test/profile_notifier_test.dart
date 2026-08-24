import 'package:benwo/application/profile/profile_notifier.dart';
import 'package:benwo/data/models/user_profile_model.dart';
import 'package:benwo/data/repositories/user_profile_repository.dart';
import 'package:benwo/core/theme/app_theme.dart';
import 'package:benwo/presentation/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'profile preferences can be saved, independently cleared, and removed',
    () async {
      final repository = _MemoryProfileRepository();
      final notifier = ProfileNotifier(repository);

      expect(
        await notifier.savePreferences(
          communicationStyle: '温和鼓励',
          bestWorkTime: '清晨',
          taskPace: '均衡推进',
        ),
        isTrue,
      );
      expect(notifier.state.profile?.bestWorkTime, '清晨');

      await notifier.savePreferences(
        communicationStyle: null,
        bestWorkTime: '夜晚',
        taskPace: null,
      );
      expect(notifier.state.profile?.communicationStyle, isNull);
      expect(notifier.state.profile?.bestWorkTime, '夜晚');
      expect(notifier.state.profile?.taskPace, isNull);

      expect(await notifier.clearPreferences(), isTrue);
      expect(repository.profile, isNull);
      expect(notifier.state.profile, isNull);
    },
  );

  testWidgets('profile page waits for and displays persisted preferences', (
    tester,
  ) async {
    final repository = _MemoryProfileRepository()
      ..profile = (UserProfileModel()
        ..communicationStyle = '分析清晰'
        ..bestWorkTime = '夜晚'
        ..taskPace = '均衡推进'
        ..createdAt = DateTime(2026, 7, 20));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileNotifierProvider.overrideWith(
            (ref) => ProfileNotifier(repository),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfilePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '分析清晰'))
          .selected,
      isTrue,
    );
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '夜晚')).selected,
      isTrue,
    );
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '均衡推进'))
          .selected,
      isTrue,
    );
  });
}

class _MemoryProfileRepository implements UserProfileRepository {
  UserProfileModel? profile;

  @override
  Future<void> clearProfile() async => profile = null;

  @override
  Future<UserProfileModel?> getProfile() async => profile;

  @override
  Future<UserProfileModel> saveProfile({
    String? communicationStyle,
    String? bestWorkTime,
    String? taskPace,
  }) async {
    profile = UserProfileModel()
      ..communicationStyle = communicationStyle
      ..bestWorkTime = bestWorkTime
      ..taskPace = taskPace
      ..createdAt = DateTime(2026, 7, 20);
    return profile!;
  }

  @override
  Stream<UserProfileModel?> watchProfile() => Stream.value(profile);
}
