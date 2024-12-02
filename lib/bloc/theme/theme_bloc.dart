import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDarkMode: false)) {
    on<InitTheme>((event, emit) async {
      final box = await Hive.openBox('settings');
      final isDarkMode = box.get('isDarkMode', defaultValue: false);
      emit(ThemeState(isDarkMode: isDarkMode));
    });

    on<ToggleTheme>((event, emit) async {
      final box = await Hive.openBox('settings');
      final isDarkMode = !state.isDarkMode;
      await box.put('isDarkMode', isDarkMode);
      emit(ThemeState(isDarkMode: isDarkMode));
    });
  }
}
