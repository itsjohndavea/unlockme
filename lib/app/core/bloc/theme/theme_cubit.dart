import 'package:bloc/bloc.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.system); // Default to system mode

  void toggleTheme() {
    if (state == ThemeState.light) {
      emit(ThemeState.dark); // Switch to dark mode
    } else if (state == ThemeState.dark) {
      emit(ThemeState.light); // Switch to light mode
    }
  }
}
