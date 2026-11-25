import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_gallary_app/core/services/auth_controller.dart';
import 'package:my_gallary_app/features/splash/bloc/splash_bloc.dart';
import 'package:my_gallary_app/features/splash/bloc/splash_event.dart';
import 'package:my_gallary_app/features/splash/bloc/splash_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('restores a saved login and opens Home after app restart', () async {
    SharedPreferences.setMockInitialValues({
      'access-token': 'saved-token',
      'user-email': 'user@example.com',
    });
    AuthController.accessToken = null;
    AuthController.userEmail = null;

    final bloc = SplashBloc()..add(const SplashStarted());
    final state = await bloc.stream.firstWhere(
      (state) => state is! SplashInitial,
    );

    expect(state, isA<SplashNavigateToHome>());
    expect((state as SplashNavigateToHome).email, 'user@example.com');

    await bloc.close();
  });
}
