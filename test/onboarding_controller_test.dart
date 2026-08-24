import 'package:benwo/application/onboarding/onboarding_controller.dart';
import 'package:benwo/core/startup/single_user_bootstrap.dart';
import 'package:benwo/data/models/user_profile_model.dart';
import 'package:benwo/data/repositories/user_profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saving onboarding persists only the three AI preferences', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = _FakeProfileRepository();
    final controller = OnboardingController(preferences, repository);

    controller.updateCommunicationStyle('分析清晰');
    controller.updateBestWorkTime('夜晚');
    controller.updateTaskPace('轻松小步');

    expect(await controller.saveProfileAndFinish(), isTrue);
    expect(repository.savedProfile?.communicationStyle, '分析清晰');
    expect(repository.savedProfile?.bestWorkTime, '夜晚');
    expect(repository.savedProfile?.taskPace, '轻松小步');
    expect(
      preferences.getBool(SingleUserBootstrap.onboardingHandledKey),
      isTrue,
    );
  });

  test(
    'skipping onboarding marks it handled without creating a profile',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = _FakeProfileRepository();
      final controller = OnboardingController(preferences, repository);

      await controller.skip();

      expect(repository.savedProfile, isNull);
      expect(
        preferences.getBool(SingleUserBootstrap.onboardingHandledKey),
        isTrue,
      );
    },
  );

  test('failed save keeps selections and onboarding remains pending', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = OnboardingController(
      preferences,
      _FailingProfileRepository(),
    );
    controller.updateCommunicationStyle('直接简洁');

    expect(await controller.saveProfileAndFinish(), isFalse);
    expect(controller.state.communicationStyle, '直接简洁');
    expect(controller.state.errorMessage, isNotNull);
    expect(
      preferences.getBool(SingleUserBootstrap.onboardingHandledKey),
      isNull,
    );
  });
}

class _FakeProfileRepository implements UserProfileRepository {
  UserProfileModel? savedProfile;

  @override
  Future<UserProfileModel?> getProfile() async => savedProfile;

  @override
  Future<UserProfileModel> saveProfile({
    String? communicationStyle,
    String? bestWorkTime,
    String? taskPace,
  }) async {
    savedProfile = UserProfileModel()
      ..communicationStyle = communicationStyle
      ..bestWorkTime = bestWorkTime
      ..taskPace = taskPace
      ..createdAt = DateTime(2026, 7, 20);
    return savedProfile!;
  }

  @override
  Future<void> clearProfile() async => savedProfile = null;

  @override
  Stream<UserProfileModel?> watchProfile() => Stream.value(savedProfile);
}

class _FailingProfileRepository extends _FakeProfileRepository {
  @override
  Future<UserProfileModel> saveProfile({
    String? communicationStyle,
    String? bestWorkTime,
    String? taskPace,
  }) => Future.error(StateError('disk unavailable'));
}
